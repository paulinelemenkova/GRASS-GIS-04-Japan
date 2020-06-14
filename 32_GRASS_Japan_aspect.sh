#!/bin/sh
# GRASS GIS script for plotting and reclassifying topographic slope aspect map: compass orientation. Here: Japan Archipelago.
g.list rast
#
d.mon wx0
g.region raster=jt_relief_EAC -p
r.slope.aspect elevation=jt_relief_EAC slope=jt_slope_EAC aspect=jt_aspect_EAC pcurvature=jt_pcurv_EAC tcurvature=jt_tcurv_EAC --overwrite

r.contour jt_relief_EAC out=TopoJT_EAC step=2000 --overwrite
d.vect TopoJT_EAC color='75:23:3' width=0

# display aspect map
d.mon wx0
r.colors map=jt_aspect_EAC color=aspectcolr
d.rast jt_aspect_EAC
d.grid size=5 color='252:242:180' border_color=blue width=0.1 fontsize=8 text_color=blue bgcolor=white
d.legend raster=jt_aspect_EAC title=Aspect,grad title_fontsize=8 font=Arial fontsize=8 -t -b bgcolor=white label_step=30 border_color=gray thin=8
d.title map=jt_aspect_EAC | d.text text="Aspect map" font="Hiragino Sans GB" color=blue size=0.8 linespacing=0.3
d.text text="Slope" color=black size=1.5 font="LucidaGrande" linespacing=0.7
d.text text="Aspect" color=black size=1.5 font="LucidaGrande" linespacing=0.7
d.text text="Compass" color=black size=1.5 font="LucidaGrande" linespacing=0.7
d.text text="Direction" color=black size=1.5 font="LucidaGrande" linespacing=0.7
d.font -l

# generate integer aspect map with degrees CCW from East
r.slope.aspect elevation=jt_relief_EAC aspect=jt_aspect_EAC precision=CELL --overwrite

# generate compass orientation and classify four major directions (N, E, S, W)
r.mapcalc "aspect_4_directions = eval( \\
   compass=(450 - jt_aspect_EAC ) % 360, \\
     if(compass >=0. && compass < 45., 1)  \\
   + if(compass >=45. && compass < 135., 2) \\
   + if(compass >=135. && compass < 225., 3) \\
   + if(compass >=225. && compass < 315., 4) \\
   + if(compass >=315., 1) \\
)"

# assign text labels
r.category aspect_4_directions separator=comma rules=- << EOF
1,North
2,East
3,South
4,West
EOF

# assign color table
r.colors aspect_4_directions rules=- << EOF
1 255,234,0
2 136,72,152
3 230,0,51
4 195,216,37
EOF

#
d.mon wx2
d.rast aspect_4_directions
d.legend raster=aspect_4_directions fontsize=10 font=Arial
d.title map=aspect_4_directions | d.text text="Reclassified aspect map" font="Hiragino Sans GB" color=white size=0.8 linespacing=0.3
d.text text="Reclassified" color=black size=1.5 font="LucidaGrande" linespacing=0.7
d.text text="Aspect" color=black size=1.5 font="LucidaGrande" linespacing=0.7
d.text text="Map" color=black size=1.5 font="LucidaGrande" linespacing=0.7
d.text text="Japanese" color=black size=1.5 font="LucidaGrande" linespacing=0.7
d.text text="Archipelago" color=black size=1.5 font="LucidaGrande" linespacing=0.7
d.grid size=5 color='252:242:180' border_color=blue width=0.1 fontsize=8 text_color=blue bgcolor=white
