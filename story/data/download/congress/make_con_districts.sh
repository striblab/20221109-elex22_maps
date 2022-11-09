#!/bin/bash

OFFICE_ID1="0104"
OFFICE_ID2="0105"
OFFICE_ID3="0106"
OFFICE_ID4="0107"
OFFICE_ID5="0108"
OFFICE_ID6="0109"
OFFICE_ID7="0110"
OFFICE_ID8="0111"
DISTRICT_STR="con"
MAPSHAPER_COLORS="#115E9B85,#AE191C85"
MAPSHAPER_CATEGORIES="DFL,R"

echo "Downloading precinct results ..." &&
echo "state;county_id;precinct_id;office_id;office_name;district;\
cand_order;cand_name;suffix;incumbent;party;districts_reporting;\
districts_voting;votes;votes_pct;votes_office" | \
  cat - <(wget -O - -o /dev/null 'https://electionresultsfiles.sos.state.mn.us/20221108/ushouse.txt') > con-district.csv &&

csv2json -s ";" con-district.csv | ndjson-cat | \
  ndjson-split | \
  ndjson-filter "d.office_id == \"$OFFICE_ID1\" || d.office_id == \"$OFFICE_ID2\" || d.office_id == \"$OFFICE_ID3\" || d.office_id == \"$OFFICE_ID4\" || d.office_id == \"$OFFICE_ID5\" || d.office_id == \"$OFFICE_ID6\" || d.office_id == \"$OFFICE_ID7\" || d.office_id == \"$OFFICE_ID8\"" > $DISTRICT_STR.tmp.ndjson &&

echo "Downloading precinct maps ..." &&
  wget https://resources.gisdata.mn.gov/pub/gdrs/data/pub/us_mn_state_lcc/bdry_congressionaldistricts2022/shp_bdry_congressionaldistricts2022.zip && \
  unzip shp_bdry_congressionaldistricts2022.zip  && \
  shp2json cng2022.shp | \
  mapshaper - -quiet -proj longlat from=cng2022.prj -o ./cng2022.json format=geojson && \
  cat cng2022.json | \
  geo2topo districts=- > ./districts-longlat.tmp.json && \
  rm cng2022.* && \
  rm *.lyr && \
  rm -rf ./metadata && \
  rm shp_bdry_congressionaldistricts2022.zip &&

echo "Getting vote totals ..." &&
cat $DISTRICT_STR.tmp.ndjson | \
  ndjson-map '{"id":  d.district, "county_id": d.county_id, "precinct_id": d.precinct_id, "name": d.cand_name, "votes": parseInt(d.votes), "votes_pct": parseFloat(d.votes_pct), "party": d.party}' | \
  ndjson-reduce '(p[d.id] = p[d.id] || []).push({name: d.name, votes: d.votes, votes_pct: d.votes_pct, party: d.party}), p' '{}' | \
  ndjson-split 'Object.keys(d).map(key => ({id: key, votes: d[key]}))' | \
  ndjson-map '{"id": d.id, "votes": d.votes.filter(obj => obj.name != "").sort((a, b) => b.votes - a.votes)}' | \
  ndjson-map '{"id": d.id, "votes": d.votes, "winner": d.votes[0].votes != d.votes[1].votes ? d.votes[0].party : "even", "winner_margin": (d.votes[0].votes_pct - d.votes[1].votes_pct).toFixed(2)}' | \
  ndjson-map '{"id": d.id, "winner": d.winner, "winner_margin": d.winner_margin, "total_votes": d.votes.reduce((a, b) => a + b.votes, 0), "votes_obj": d.votes}' > joined.tmp.ndjson &&

echo "Joining results to precinct map ..." &&
ndjson-split 'd.objects.districts.geometries' < districts-longlat.tmp.json | \
  ndjson-map -r d3 '{"type": d.type, "arcs": d.arcs, "properties": {"id": d.properties.DISTRICT, "area_sqmi": d.properties.AREA * 0.00000038610}}' | \
  ndjson-join --left 'd.properties.id' 'd.id' - <(cat joined.tmp.ndjson) | \
   ndjson-map '{"type": d[0].type, "arcs": d[0].arcs, "properties": {"id": d[0].properties.id, "county": d[0].properties.county, "area_sqmi": d[0].properties.area_sqmi, "winner": d[1] != null ? d[1].winner : null, "winner_margin": d[1] != null ? d[1].winner_margin : null, "wmargin": d[1] != null && d[1].winner == "R" ? d[1].winner_margin * -1 : d[1] != null ? d[1].winner_margin * 1 : null, "votes_sqmi": d[1] != null ? d[1].total_votes / d[0].properties.area_sqmi : null, "total_votes": d[1] != null ? d[1].total_votes : null, "votes_obj": d[1] != null ? d[1].votes_obj : null}}' | \
   ndjson-reduce 'p.geometries.push(d), p' '{"type": "GeometryCollection", "geometries":[]}' > districts.geometries.tmp.ndjson &&

echo "Putting it all together ..." &&
ndjson-join '1' '1' <(ndjson-cat districts-longlat.tmp.json) <(cat districts.geometries.tmp.ndjson) |
  ndjson-map '{"type": d[0].type, "bbox": d[0].bbox, "transform": d[0].transform, "objects": {"districts": {"type": "GeometryCollection", "geometries": d[1].geometries}}, "arcs": d[0].arcs}' > districts-final.json &&
topo2geo districts=$DISTRICT_STR-district.json < districts-final.json &&

echo "Creating SVG ..." &&
mapshaper $DISTRICT_STR-district.json \
  -quiet \
  -proj +proj=utm +zone=15 +ellps=GRS80 +datum=NAD83 +units=m +no_defs \
  -colorizer name=calcFill colors="$MAPSHAPER_COLORS" nodata='#dfdfdf' categories="$MAPSHAPER_CATEGORIES" \
  -style fill='calcFill(winner)' \
  -o $DISTRICT_STR-district.svg &&

rm con-district.csv &&
rm *.tmp.* &&
rm districts-final.json