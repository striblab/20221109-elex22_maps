#!/bin/bash


OFFICE_ID1="0121"
OFFICE_ID2="0122"
OFFICE_ID3="0123"
OFFICE_ID4="0124"
OFFICE_ID5="0125"
OFFICE_ID6="0126"
OFFICE_ID7="0127"
OFFICE_ID8="0128"
OFFICE_ID9="0129"
OFFICE_ID10="0130"
OFFICE_ID11="0131"
OFFICE_ID12="0132"
OFFICE_ID13="0133"
OFFICE_ID14="0134"
OFFICE_ID15="0135"
OFFICE_ID16="0136"
OFFICE_ID17="0137"
OFFICE_ID18="0138"
OFFICE_ID19="0139"
OFFICE_ID20="0140"
OFFICE_ID21="0141"
OFFICE_ID22="0142"
OFFICE_ID23="0143"
OFFICE_ID24="0144"
OFFICE_ID25="0145"
OFFICE_ID26="0146"
OFFICE_ID27="0147"
OFFICE_ID28="0148"
OFFICE_ID29="0149"
OFFICE_ID30="0150"
OFFICE_ID31="0151"
OFFICE_ID32="0152"
OFFICE_ID33="0153"
OFFICE_ID34="0154"
OFFICE_ID35="0155"
OFFICE_ID36="0156"
OFFICE_ID37="0157"
OFFICE_ID38="0158"
OFFICE_ID39="0159"
OFFICE_ID40="0160"
OFFICE_ID41="0161"
OFFICE_ID42="0162"
OFFICE_ID43="0163"
OFFICE_ID44="0164"
OFFICE_ID45="0165"
OFFICE_ID46="0166"
OFFICE_ID47="0167"
OFFICE_ID48="0168"
OFFICE_ID49="0169"
OFFICE_ID50="0170"
OFFICE_ID51="0171"
OFFICE_ID52="0172"
OFFICE_ID53="0173"
OFFICE_ID54="0174"
OFFICE_ID55="0175"
OFFICE_ID56="0176"
OFFICE_ID57="0177"
OFFICE_ID58="0178"
OFFICE_ID59="0179"
OFFICE_ID60="0180"
OFFICE_ID61="0181"
OFFICE_ID62="0182"
OFFICE_ID63="0183"
OFFICE_ID64="0184"
OFFICE_ID65="0185"
OFFICE_ID66="0186"
OFFICE_ID67="0187"
DISTRICT_STR="sen"
MAPSHAPER_COLORS="#115E9B85,#AE191C85"
MAPSHAPER_CATEGORIES="DFL,R"

echo "Downloading precinct results ..." &&
echo "state;county_id;precinct_id;office_id;office_name;district;\
cand_order;cand_name;suffix;incumbent;party;precincts_reporting;\
precincts_voting;votes;votes_pct;votes_office" | \
  cat - <(wget -O - -o /dev/null 'https://electionresultsfiles.sos.state.mn.us/20181106/allracesbyprecinct.txt') > sen.csv &&

csv2json -s ";" sen.csv | ndjson-cat | \
  ndjson-split | \
  ndjson-filter "d.office_id == \"$OFFICE_ID1\" || d.office_id == \"$OFFICE_ID2\" || d.office_id == \"$OFFICE_ID3\" || d.office_id == \"$OFFICE_ID4\" || d.office_id == \"$OFFICE_ID5\" || d.office_id == \"$OFFICE_ID6\" || d.office_id == \"$OFFICE_ID7\" || d.office_id == \"$OFFICE_ID8\" || d.office_id == \"$OFFICE_ID9\" || d.office_id == \"$OFFICE_ID10\" || d.office_id == \"$OFFICE_ID11\" || d.office_id == \"$OFFICE_ID12\" || d.office_id == \"$OFFICE_ID13\" || d.office_id == \"$OFFICE_ID14\" || d.office_id == \"$OFFICE_ID15\" || d.office_id == \"$OFFICE_ID16\" || d.office_id == \"$OFFICE_ID17\" || d.office_id == \"$OFFICE_ID18\" || d.office_id == \"$OFFICE_ID19\" || d.office_id == \"$OFFICE_ID20\" || d.office_id == \"$OFFICE_ID21\" || d.office_id == \"$OFFICE_ID22\" || d.office_id == \"$OFFICE_ID23\" || d.office_id == \"$OFFICE_ID24\" || d.office_id == \"$OFFICE_ID25\" || d.office_id == \"$OFFICE_ID26\" || d.office_id == \"$OFFICE_ID27\" || d.office_id == \"$OFFICE_ID28\" || d.office_id == \"$OFFICE_ID29\" || d.office_id == \"$OFFICE_ID30\" || d.office_id == \"$OFFICE_ID31\" || d.office_id == \"$OFFICE_ID32\" || d.office_id == \"$OFFICE_ID33\" || d.office_id == \"$OFFICE_ID34\" || d.office_id == \"$OFFICE_ID35\" || d.office_id == \"$OFFICE_ID36\" || d.office_id == \"$OFFICE_ID37\" || d.office_id == \"$OFFICE_ID38\" || d.office_id == \"$OFFICE_ID39\" || d.office_id == \"$OFFICE_ID40\" || d.office_id == \"$OFFICE_ID41\" || d.office_id == \"$OFFICE_ID42\" || d.office_id == \"$OFFICE_ID43\" || d.office_id == \"$OFFICE_ID44\" || d.office_id == \"$OFFICE_ID45\" || d.office_id == \"$OFFICE_ID46\" || d.office_id == \"$OFFICE_ID47\" || d.office_id == \"$OFFICE_ID48\" || d.office_id == \"$OFFICE_ID49\" || d.office_id == \"$OFFICE_ID50\" || d.office_id == \"$OFFICE_ID51\" || d.office_id == \"$OFFICE_ID52\" || d.office_id == \"$OFFICE_ID53\" || d.office_id == \"$OFFICE_ID54\" || d.office_id == \"$OFFICE_ID55\" || d.office_id == \"$OFFICE_ID56\" || d.office_id == \"$OFFICE_ID57\" || d.office_id == \"$OFFICE_ID58\" || d.office_id == \"$OFFICE_ID59\" || d.office_id == \"$OFFICE_ID60\" || d.office_id == \"$OFFICE_ID61\" || d.office_id == \"$OFFICE_ID62\" || d.office_id == \"$OFFICE_ID63\" || d.office_id == \"$OFFICE_ID64\" || d.office_id == \"$OFFICE_ID65\" || d.office_id == \"$OFFICE_ID66\" || d.office_id == \"$OFFICE_ID67\"" > $DISTRICT_STR.tmp.ndjson &&

echo "Downloading precinct maps ..." &&
  wget ftp://ftp.gisdata.mn.gov/pub/gdrs/data/pub/us_mn_state_sos/bdry_votingdistricts/shp_bdry_votingdistricts.zip && \
  unzip shp_bdry_votingdistricts.zip  && \
  shp2json bdry_votingdistricts.shp | \
  mapshaper - -quiet -proj longlat from=bdry_votingdistricts.prj -o ./bdry_votingdistricts.json format=geojson && \
  cat bdry_votingdistricts.json | \
  geo2topo precincts=- > ./precincts-longlat.tmp.json && \
  rm bdry_votingdistricts.* && \
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
  ndjson-map -r d3 '{"type": d.type, "arcs": d.arcs, "properties": {"id": d3.format("02")(d.properties.COUNTYCODE) + d.properties.PCTCODE, "congdist": d.properties.CONGDIST, "mnsendist": d.properties.MNSENDIST, "mnlegdist": d.properties.MNLEGDIST, "county": d.properties.COUNTYNAME, "precinct": d.properties.PCTNAME, "area_sqmi": 90000000 * 0.00000038610}}' | \
  ndjson-join --left 'd.properties.id' 'd.id' - <(cat joined.tmp.ndjson) | \
   ndjson-map '{"type": d[0].type, "arcs": d[0].arcs, "properties": {"id": d[0].properties.id, "congdist": d[0].properties.congdist, "mnsendist": d[0].properties.mnsendist, "mnlegdist": d[0].properties.mnlegdist, "county": d[0].properties.county, "precinct": d[0].properties.precinct, "area_sqmi": d[0].properties.area_sqmi, "winner": d[1] != null ? d[1].winner : null, "winner_margin": d[1] != null ? d[1].winner_margin : null, "votes_sqmi": d[1] != null ? d[1].total_votes / d[0].properties.area_sqmi : null, "total_votes": d[1] != null ? d[1].total_votes : null, "votes_obj": d[1] != null ? d[1].votes_obj : null}}' | \
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

rm *.tmp.* &&
rm precincts-final.json