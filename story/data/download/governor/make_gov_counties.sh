#!/bin/bash

OFFICE_ID="331"
DISTRICT_STR="gov"
MAPSHAPER_COLORS="#115E9B85,#AE191C85"
MAPSHAPER_CATEGORIES="DFL,R"

# echo "Downloading precinct results ..." &&
# echo "state;county_id;precinct_id;office_id;office_name;district;\
# cand_order;cand_name;suffix;incumbent;party;counties_reporting;\
# counties_voting;votes;votes_pct;votes_office" | \
#   cat - <(wget -O - -o /dev/null 'https://electionresultsfiles.sos.state.mn.us/20221108/allracesbycounty.txt') > gov-counties.csv &&

csv2json -s "," gov-counties.csv | ndjson-cat | \
  ndjson-split | \
  ndjson-filter "d.office_id == \"$OFFICE_ID\"" > $DISTRICT_STR.tmp.ndjson &&

echo "Downloading precinct maps ..." &&
  wget https://resources.gisdata.mn.gov/pub/gdrs/data/pub/us_mn_state_dot/bdry_counties/shp_bdry_counties.zip && \
  unzip shp_bdry_counties.zip  && \
  shp2json County_Boundaries_in_Minnesota.shp | \
  mapshaper - -quiet -proj longlat from=County_Boundaries_in_Minnesota.prj -o ./County_Boundaries_in_Minnesota.json format=geojson && \
  cat County_Boundaries_in_Minnesota.json | \
  geo2topo counties=- > ./counties-longlat.tmp.json && \
  rm County_Boundaries_in_Minnesota.* && \
  rm -rf ./metadata && \
  rm shp_bdry_counties.zip &&

echo "Getting vote totals ..." &&
cat $DISTRICT_STR.tmp.ndjson | \
  ndjson-map '{"id":  d.county_id, "county_id": d.county_id, "precinct_id": d.precinct_id, "name": d.cand_name, "votes": parseInt(d.votes), "votes_pct": parseFloat(d.votes_pct), "party": d.party}' | \
  ndjson-reduce '(p[d.id] = p[d.id] || []).push({name: d.name, votes: d.votes, votes_pct: d.votes_pct, party: d.party}), p' '{}' | \
  ndjson-split 'Object.keys(d).map(key => ({id: key, votes: d[key]}))' | \
  ndjson-map '{"id": d.id, "votes": d.votes.filter(obj => obj.name != "").sort((a, b) => b.votes - a.votes)}' | \
  ndjson-map '{"id": d.id, "votes": d.votes, "winner": d.votes[0].votes != d.votes[1].votes ? d.votes[0].party : "even", "winner_margin": (d.votes[0].votes_pct - d.votes[1].votes_pct).toFixed(2)}' | \
  ndjson-map '{"id": d.id, "winner": d.winner, "winner_margin": d.winner_margin, "total_votes": d.votes.reduce((a, b) => a + b.votes, 0), "votes_obj": d.votes}' > joined.tmp.ndjson &&

echo "Joining results to precinct map ..." &&
ndjson-split 'd.objects.counties.geometries' < counties-longlat.tmp.json | \
  ndjson-map -r d3 '{"type": d.type, "arcs": d.arcs, "properties": {"id": d.properties.COUNTY_COD, "county": d.properties.COUNTY_NAM, "area_sqmi": d.properties.SHAPE_area * 0.00000038610}}' | \
  ndjson-join --left 'd.properties.id' 'd.id' - <(cat joined.tmp.ndjson) | \
   ndjson-map '{"type": d[0].type, "arcs": d[0].arcs, "properties": {"id": d[0].properties.id, "county": d[0].properties.county, "area_sqmi": d[0].properties.SHAPE_area, "winner": d[1] != null ? d[1].winner : null, "winner_margin": d[1] != null ? d[1].winner_margin : null, "wmargin": d[1] != null && d[1].winner == "R" ? d[1].winner_margin * -1 : d[1] != null ? d[1].winner_margin * 1 : null, "votes_sqmi": d[1] != null ? d[1].total_votes / d[0].properties.area_sqmi : null, "total_votes": d[1] != null ? d[1].total_votes : null, "votes_obj": d[1] != null ? d[1].votes_obj : null}}' | \
   ndjson-reduce 'p.geometries.push(d), p' '{"type": "GeometryCollection", "geometries":[]}' > counties.geometries.tmp.ndjson &&

echo "Putting it all together ..." &&
ndjson-join '1' '1' <(ndjson-cat counties-longlat.tmp.json) <(cat counties.geometries.tmp.ndjson) |
  ndjson-map '{"type": d[0].type, "bbox": d[0].bbox, "transform": d[0].transform, "objects": {"counties": {"type": "GeometryCollection", "geometries": d[1].geometries}}, "arcs": d[0].arcs}' > counties-final.json &&
topo2geo counties=$DISTRICT_STR-counties.json < counties-final.json &&

echo "Creating SVG ..." &&
mapshaper $DISTRICT_STR-counties.json \
  -quiet \
  -proj +proj=utm +zone=15 +ellps=GRS80 +datum=NAD83 +units=m +no_defs \
  -colorizer name=calcFill colors="$MAPSHAPER_COLORS" nodata='#dfdfdf' categories="$MAPSHAPER_CATEGORIES" \
  -style fill='calcFill(winner)' \
  -o $DISTRICT_STR-counties.svg &&

#rm gov-counties.csv &&
rm *.tmp.* &&
rm counties-final.json