#!/bin/bash

OFFICE_ID="0332"
DISTRICT_STR="sos"
MAPSHAPER_COLORS="#115E9B85,#AE191C85"
MAPSHAPER_CATEGORIES="DFL,R"

echo "Downloading precinct results ..." &&
echo "state;county_id;precinct_id;office_id;office_name;district;\
cand_order;cand_name;suffix;incumbent;party;precincts_reporting;\
precincts_voting;votes;votes_pct;votes_office" | \
  cat - <(wget -O - -o /dev/null 'https://electionresultsfiles.sos.state.mn.us/20181106/allracesbyprecinct.txt') > sos.csv &&

csv2json -s ";" sos.csv | ndjson-cat | \
  ndjson-split | \
  ndjson-filter "d.office_id == \"$OFFICE_ID\"" > $DISTRICT_STR.tmp.ndjson &&

echo "Downloading precinct maps ..." &&
  wget ftp://ftp.gisdata.mn.gov/pub/gdrs/data/pub/us_mn_state_sos/bdry_votingdistricts/shp_bdry_votingdistricts.zip && \
  unzip shp_bdry_votingdistricts.zip  && \
  shp2json bdry_votingdistrictis.shp | \
  mapshaper - -quiet -proj longlat from=bdry_votingdistrictis.prj -o ./bdry_votingdistricts.json format=geojson && \
  cat bdry_votingdistricts.json | \
  geo2topo precincts=- > ./precincts-longlat.tmp.json && \
  rm bdry_votingdistrictis.* && \
  rm -rf ./metadata && \
  rm shp_bdry_votingdistricts.zip &&

echo "Getting vote totals ..." &&
cat $DISTRICT_STR.tmp.ndjson | \
  ndjson-map '{"id":  d.county_id + d.precinct_id, "county_id": d.county_id, "precinct_id": d.precinct_id, "name": d.cand_name, "votes": parseInt(d.votes), "votes_pct": parseFloat(d.votes_pct), "party": d.party}' | \
  ndjson-reduce '(p[d.id] = p[d.id] || []).push({name: d.name, votes: d.votes, votes_pct: d.votes_pct, party: d.party}), p' '{}' | \
  ndjson-split 'Object.keys(d).map(key => ({id: key, votes: d[key]}))' | \
  ndjson-map '{"id": d.id, "votes": d.votes.filter(obj => obj.name != "").sort((a, b) => b.votes - a.votes)}' | \
  ndjson-map '{"id": d.id, "votes": d.votes, "winner": d.votes[0].votes != d.votes[1].votes ? d.votes[0].party : "even", "winner_margin": (d.votes[0].votes_pct - d.votes[1].votes_pct).toFixed(2)}' | \
  ndjson-map '{"id": d.id, "winner": d.winner, "winner_margin": d.winner_margin, "total_votes": d.votes.reduce((a, b) => a + b.votes, 0), "votes_obj": d.votes}' > joined.tmp.ndjson &&

echo "Joining results to precinct map ..." &&
ndjson-split 'd.objects.precincts.geometries' < precincts-longlat.tmp.json | \
  ndjson-map -r d3 '{"type": d.type, "arcs": d.arcs, "properties": {"id": d3.format("02")(d.properties.COUNTYCODE) + d.properties.PCTCODE, "congdist": d.properties.CONGDIST, "mnsendist": d.properties.MNSENDIST, "mnlegdist": d.properties.MNLEGDIST, "county": d.properties.COUNTYNAME, "precinct": d.properties.PCTNAME, "area_sqmi": d.properties.Shape_Area * 0.00000038610}}' | \
  ndjson-join --left 'd.properties.id' 'd.id' - <(cat joined.tmp.ndjson) | \
   ndjson-map '{"type": d[0].type, "arcs": d[0].arcs, "properties": {"id": d[0].properties.id, "congdist": d[0].properties.congdist, "mnsendist": d[0].properties.mnsendist, "mnlegdist": d[0].properties.mnlegdist, "county": d[0].properties.county, "precinct": d[0].properties.precinct, "area_sqmi": d[0].properties.area_sqmi, "winner": d[1] != null ? d[1].winner : null, "winner_margin": d[1] != null ? d[1].winner_margin : null, "wmargin": d[1] != null && d[1].winner == "R" ? d[1].winner_margin * -1 : d[1] != null ? d[1].winner_margin * 1 : null, "votes_sqmi": d[1] != null ? d[1].total_votes / d[0].properties.area_sqmi : null, "total_votes": d[1] != null ? d[1].total_votes : null, "votes_obj": d[1] != null ? d[1].votes_obj : null}}' | \
   ndjson-reduce 'p.geometries.push(d), p' '{"type": "GeometryCollection", "geometries":[]}' > precincts.geometries.tmp.ndjson &&

echo "Putting it all together ..." &&
ndjson-join '1' '1' <(ndjson-cat precincts-longlat.tmp.json) <(cat precincts.geometries.tmp.ndjson) |
  ndjson-map '{"type": d[0].type, "bbox": d[0].bbox, "transform": d[0].transform, "objects": {"precincts": {"type": "GeometryCollection", "geometries": d[1].geometries}}, "arcs": d[0].arcs}' > precincts-final.json &&
topo2geo precincts=$DISTRICT_STR-results-geo.json < precincts-final.json &&

echo "Creating SVG ..." &&
mapshaper $DISTRICT_STR-results-geo.json \
  -quiet \
  -proj +proj=utm +zone=15 +ellps=GRS80 +datum=NAD83 +units=m +no_defs \
  -colorizer name=calcFill colors="$MAPSHAPER_COLORS" nodata='#dfdfdf' categories="$MAPSHAPER_CATEGORIES" \
  -style fill='calcFill(winner)' \
  -o $DISTRICT_STR.svg &&

rm sos.csv &&
rm *.tmp.* &&
rm precincts-final.json