#!/bin/bash

OFFICE_ID1="0188"
OFFICE_ID2="0189"
OFFICE_ID3="0190"
OFFICE_ID4="0191"
OFFICE_ID5="0192"
OFFICE_ID6="0193"
OFFICE_ID7="0194"
OFFICE_ID8="0195"
OFFICE_ID9="0196"
OFFICE_ID10="0197"
OFFICE_ID11="0198"
OFFICE_ID12="0199"
OFFICE_ID13="0200"
OFFICE_ID14="0201"
OFFICE_ID15="0202"
OFFICE_ID16="0203"
OFFICE_ID17="0204"
OFFICE_ID18="0205"
OFFICE_ID19="0206"
OFFICE_ID20="0207"
OFFICE_ID21="0208"
OFFICE_ID22="0209"
OFFICE_ID23="0210"
OFFICE_ID24="0211"
OFFICE_ID25="0212"
OFFICE_ID26="0213"
OFFICE_ID27="0214"
OFFICE_ID28="0215"
OFFICE_ID29="0216"
OFFICE_ID30="0217"
OFFICE_ID31="0218"
OFFICE_ID32="0219"
OFFICE_ID33="0220"
OFFICE_ID34="0221"
OFFICE_ID35="0222"
OFFICE_ID36="0223"
OFFICE_ID37="0224"
OFFICE_ID38="0225"
OFFICE_ID39="0226"
OFFICE_ID40="0227"
OFFICE_ID41="0228"
OFFICE_ID42="0229"
OFFICE_ID43="0230"
OFFICE_ID44="0231"
OFFICE_ID45="0232"
OFFICE_ID46="0233"
OFFICE_ID47="0234"
OFFICE_ID48="0235"
OFFICE_ID49="0236"
OFFICE_ID50="0237"
OFFICE_ID51="0238"
OFFICE_ID52="0239"
OFFICE_ID53="0240"
OFFICE_ID54="0241"
OFFICE_ID55="0242"
OFFICE_ID56="0243"
OFFICE_ID57="0244"
OFFICE_ID58="0245"
OFFICE_ID59="0246"
OFFICE_ID60="0247"
OFFICE_ID61="0248"
OFFICE_ID62="0249"
OFFICE_ID63="0250"
OFFICE_ID64="0251"
OFFICE_ID65="0252"
OFFICE_ID66="0253"
OFFICE_ID67="0254"
OFFICE_ID68="0255"
OFFICE_ID69="0256"
OFFICE_ID70="0257"
OFFICE_ID71="0258"
OFFICE_ID72="0259"
OFFICE_ID73="0260"
OFFICE_ID74="0261"
OFFICE_ID75="0262"
OFFICE_ID76="0263"
OFFICE_ID77="0264"
OFFICE_ID78="0265"
OFFICE_ID79="0266"
OFFICE_ID80="0267"
OFFICE_ID81="0268"
OFFICE_ID82="0269"
OFFICE_ID83="0270"
OFFICE_ID84="0271"
OFFICE_ID85="0272"
OFFICE_ID86="0273"
OFFICE_ID87="0274"
OFFICE_ID88="0275"
OFFICE_ID89="0276"
OFFICE_ID90="0277"
OFFICE_ID91="0278"
OFFICE_ID92="0279"
OFFICE_ID93="0280"
OFFICE_ID94="0281"
OFFICE_ID95="0282"
OFFICE_ID96="0283"
OFFICE_ID97="0284"
OFFICE_ID98="0285"
OFFICE_ID99="0286"
OFFICE_ID100="0287"
OFFICE_ID101="0288"
OFFICE_ID102="0289"
OFFICE_ID103="0290"
OFFICE_ID104="0291"
OFFICE_ID105="0292"
OFFICE_ID106="0293"
OFFICE_ID107="0294"
OFFICE_ID108="0295"
OFFICE_ID109="0296"
OFFICE_ID110="0297"
OFFICE_ID111="0298"
OFFICE_ID112="0299"
OFFICE_ID113="0300"
OFFICE_ID114="0301"
OFFICE_ID115="0302"
OFFICE_ID116="0303"
OFFICE_ID117="0304"
OFFICE_ID118="0305"
OFFICE_ID119="0306"
OFFICE_ID120="0307"
OFFICE_ID121="0308"
OFFICE_ID122="0309"
OFFICE_ID123="0310"
OFFICE_ID124="0311"
OFFICE_ID125="0312"
OFFICE_ID126="0313"
OFFICE_ID127="0314"
OFFICE_ID128="0315"
OFFICE_ID129="0316"
OFFICE_ID130="0317"
OFFICE_ID131="0318"
OFFICE_ID132="0319"
OFFICE_ID133="0320"
OFFICE_ID134="0321"
DISTRICT_STR="leg"
MAPSHAPER_COLORS="#115E9B85,#AE191C85"
MAPSHAPER_CATEGORIES="DFL,R"

echo "Downloading precinct results ..." &&
echo "state;county_id;precinct_id;office_id;office_name;district;\
cand_order;cand_name;suffix;incumbent;party;districts_reporting;\
districts_voting;votes;votes_pct;votes_office" | \
  cat - <(wget -O - -o /dev/null 'https://electionresultsfiles.sos.state.mn.us/20181106/LegislativeByDistrict.txt') > leg.csv &&

csv2json -s ";" leg.csv | ndjson-cat | \
  ndjson-split | \
  ndjson-filter "d.office_id == \"$OFFICE_ID1\" || d.office_id == \"$OFFICE_ID2\" || d.office_id == \"$OFFICE_ID3\" || d.office_id == \"$OFFICE_ID4\" || d.office_id == \"$OFFICE_ID5\" || d.office_id == \"$OFFICE_ID6\" || d.office_id == \"$OFFICE_ID7\" || d.office_id == \"$OFFICE_ID8\" || d.office_id == \"$OFFICE_ID9\" || d.office_id == \"$OFFICE_ID10\" || d.office_id == \"$OFFICE_ID11\" || d.office_id == \"$OFFICE_ID12\" || d.office_id == \"$OFFICE_ID13\" || d.office_id == \"$OFFICE_ID14\" || d.office_id == \"$OFFICE_ID15\" || d.office_id == \"$OFFICE_ID16\" || d.office_id == \"$OFFICE_ID17\" || d.office_id == \"$OFFICE_ID18\" || d.office_id == \"$OFFICE_ID19\" || d.office_id == \"$OFFICE_ID20\" || d.office_id == \"$OFFICE_ID21\" || d.office_id == \"$OFFICE_ID22\" || d.office_id == \"$OFFICE_ID23\" || d.office_id == \"$OFFICE_ID24\" || d.office_id == \"$OFFICE_ID25\" || d.office_id == \"$OFFICE_ID26\" || d.office_id == \"$OFFICE_ID27\" || d.office_id == \"$OFFICE_ID28\" || d.office_id == \"$OFFICE_ID29\" || d.office_id == \"$OFFICE_ID30\" || d.office_id == \"$OFFICE_ID31\" || d.office_id == \"$OFFICE_ID32\" || d.office_id == \"$OFFICE_ID33\" || d.office_id == \"$OFFICE_ID34\" || d.office_id == \"$OFFICE_ID35\" || d.office_id == \"$OFFICE_ID36\" || d.office_id == \"$OFFICE_ID37\" || d.office_id == \"$OFFICE_ID38\" || d.office_id == \"$OFFICE_ID39\" || d.office_id == \"$OFFICE_ID40\" || d.office_id == \"$OFFICE_ID41\" || d.office_id == \"$OFFICE_ID42\" || d.office_id == \"$OFFICE_ID43\" || d.office_id == \"$OFFICE_ID44\" || d.office_id == \"$OFFICE_ID45\" || d.office_id == \"$OFFICE_ID46\" || d.office_id == \"$OFFICE_ID47\" || d.office_id == \"$OFFICE_ID48\" || d.office_id == \"$OFFICE_ID49\" || d.office_id == \"$OFFICE_ID50\" || d.office_id == \"$OFFICE_ID51\" || d.office_id == \"$OFFICE_ID52\" || d.office_id == \"$OFFICE_ID53\" || d.office_id == \"$OFFICE_ID54\" || d.office_id == \"$OFFICE_ID55\" || d.office_id == \"$OFFICE_ID56\" || d.office_id == \"$OFFICE_ID57\" || d.office_id == \"$OFFICE_ID58\" || d.office_id == \"$OFFICE_ID59\" || d.office_id == \"$OFFICE_ID60\" || d.office_id == \"$OFFICE_ID61\" || d.office_id == \"$OFFICE_ID62\" || d.office_id == \"$OFFICE_ID63\" || d.office_id == \"$OFFICE_ID64\" || d.office_id == \"$OFFICE_ID65\" || d.office_id == \"$OFFICE_ID66\" || d.office_id == \"$OFFICE_ID67\" || d.office_id == \"$OFFICE_ID68\" || d.office_id == \"$OFFICE_ID69\" || d.office_id == \"$OFFICE_ID70\" || d.office_id == \"$OFFICE_ID71\" || d.office_id == \"$OFFICE_ID72\" || d.office_id == \"$OFFICE_ID73\" || d.office_id == \"$OFFICE_ID74\" || d.office_id == \"$OFFICE_ID75\" || d.office_id == \"$OFFICE_ID76\" || d.office_id == \"$OFFICE_ID77\" || d.office_id == \"$OFFICE_ID78\" || d.office_id == \"$OFFICE_ID79\" || d.office_id == \"$OFFICE_ID80\" || d.office_id == \"$OFFICE_ID81\" || d.office_id == \"$OFFICE_ID82\" || d.office_id == \"$OFFICE_ID83\" || d.office_id == \"$OFFICE_ID84\" || d.office_id == \"$OFFICE_ID85\" || d.office_id == \"$OFFICE_ID86\" || d.office_id == \"$OFFICE_ID87\" || d.office_id == \"$OFFICE_ID88\" || d.office_id == \"$OFFICE_ID89\" || d.office_id == \"$OFFICE_ID90\" || d.office_id == \"$OFFICE_ID91\" || d.office_id == \"$OFFICE_ID92\" || d.office_id == \"$OFFICE_ID93\" || d.office_id == \"$OFFICE_ID94\" || d.office_id == \"$OFFICE_ID95\" || d.office_id == \"$OFFICE_ID96\" || d.office_id == \"$OFFICE_ID97\" || d.office_id == \"$OFFICE_ID98\" || d.office_id == \"$OFFICE_ID99\" || d.office_id == \"$OFFICE_ID100\" || d.office_id == \"$OFFICE_ID101\" || d.office_id == \"$OFFICE_ID102\" || d.office_id == \"$OFFICE_ID103\" || d.office_id == \"$OFFICE_ID104\" || d.office_id == \"$OFFICE_ID105\" || d.office_id == \"$OFFICE_ID106\" || d.office_id == \"$OFFICE_ID107\" || d.office_id == \"$OFFICE_ID108\" || d.office_id == \"$OFFICE_ID109\" || d.office_id == \"$OFFICE_ID110\" || d.office_id == \"$OFFICE_ID111\" || d.office_id == \"$OFFICE_ID112\" || d.office_id == \"$OFFICE_ID113\" || d.office_id == \"$OFFICE_ID114\" || d.office_id == \"$OFFICE_ID115\" || d.office_id == \"$OFFICE_ID116\" || d.office_id == \"$OFFICE_ID117\" || d.office_id == \"$OFFICE_ID118\" || d.office_id == \"$OFFICE_ID119\" || d.office_id == \"$OFFICE_ID120\" || d.office_id == \"$OFFICE_ID121\" || d.office_id == \"$OFFICE_ID122\" || d.office_id == \"$OFFICE_ID123\" || d.office_id == \"$OFFICE_ID124\" || d.office_id == \"$OFFICE_ID125\" || d.office_id == \"$OFFICE_ID126\" || d.office_id == \"$OFFICE_ID127\" || d.office_id == \"$OFFICE_ID128\" || d.office_id == \"$OFFICE_ID129\" || d.office_id == \"$OFFICE_ID130\" || d.office_id == \"$OFFICE_ID131\" || d.office_id == \"$OFFICE_ID132\" || d.office_id == \"$OFFICE_ID133\" || d.office_id == \"$OFFICE_ID134\"" > $DISTRICT_STR.tmp.ndjson &&

echo "Downloading precinct maps ..." &&
  shp2json house2022.shp | \
  mapshaper - -quiet -proj longlat from=house2022.prj -o ./house2022.json format=geojson && \
  cat house2022.json | \
  geo2topo districts=- > ./districts-longlat.tmp.json &&

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
   ndjson-map '{"type": d[0].type, "arcs": d[0].arcs, "properties": {"id": d[0].properties.id, "area_sqmi": d[0].properties.area_sqmi, "winner": d[1] != null ? d[1].winner : null, "winner_margin": d[1] != null ? d[1].winner_margin : null, "votes_sqmi": d[1] != null ? d[1].total_votes / d[0].properties.area_sqmi : null, "total_votes": d[1] != null ? d[1].total_votes : null, "votes_obj": d[1] != null ? d[1].votes_obj : null}}' | \
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

rm *.tmp.* &&
rm leg.csv &&
rm districts-final.json