0. sudo chmod +x /Users/hargaja/Desktop/workspace/microcanvas/REACTOR/20221109-elex22maps/story/data/download/hcs/make_hs_maps.sh

1. ./make_potus_maps.sh

2. QGIS > Field Calculator > add "wmargin" field to resulting json file

CASE 
  WHEN "winner" = 'DFL' THEN ("winner_margin" * 1)
  WHEN "winner" = 'R' THEN ("winner_margin" * -1)
  WHEN "winner" = 'even' THEN 0
  ELSE NULL 
END 




POST-ELECTION PROCESSING

change the target precinct urls

cd /Users/hargaja/Desktop/workspace/microcanvas/REACTOR/20221109-elex22maps/story/data/download/governor

./make_gov_maps.sh

./make_gov_counties.sh

./make_gov_metro.sh

QGIS > gov-results-geo.json > gov.csv

QGIS > gov-counties.json > gov-counties.csv

move all to desktop

REPEAT FOR ALL RACES

MOVE DESKTOP FILES TO PUBLIC/DATA

GITHUB COMMIT

AWS DEPLOY

CHORUS WRITEUP

POST TO AUDIENCE