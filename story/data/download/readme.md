0. sudo chmod +x /Users/hargaja/Desktop/workspace/microcanvas/REACTOR/20221109-elex22maps/story/data/download/sos/make_sos_counties.sh

1. ./make_potus_maps.sh

2. QGIS > Field Calculator > add "wmargin" field to resulting json file

CASE 
  WHEN "winner" = 'DFL' THEN ("winner_margin" * 1)
  WHEN "winner" = 'R' THEN ("winner_margin" * -1)
  WHEN "winner" = 'even' THEN 0
  ELSE NULL 
END 

