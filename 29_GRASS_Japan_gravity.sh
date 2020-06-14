#!/bin/sh
# cut out an image subset from initial big image using boundary 'clockwise' coordinates W N E S (xMin, yMax, xMax, yMin). Here: cut off Japan Trench gravity
# Step-4. Extract a subset for the Japan trench area via GMT
img2grd grav_27.1.img -R128/150/30/46 -Gjt_grav.grd -T1 -I1 -E -S0.1 -V
# projecting raster GRD file in WGS84 to Equal Area Cylindrical projection NetCDF file by GDAL via GMT:
gdalwarp -t_srs '+proj=cea lat_ts=38 lon_0=138' jt_grav.grd jt_grav_EAC.tif
# importing geoid raster NetCDF file to GRASS GIS via GDAL:
#g.remove -f type=raster name=jt_grav_EAC-
r.in.gdal jt_grav_EAC.tif out=jt_grav_EAC title="Gravity: EGM96 grid"
r.timestamp map=jt_grav_EAC date='04 May 2020'
g.list rast
r.info jt_grav_EAC
r.colors jt_grav_EAC col=celsius
#
d.mon wx0
g.region raster=jt_grav_EAC -p -g
d.rast jt_grav_EAC
#
d.grid size=5 color=yellow border_color=yellow width=0.1 fontsize=8 bgcolor=white text_color=red
d.legend raster=jt_grav_EAC range=-30,44 title=Gravity,mGal title_fontsize=8 font="Trebuchet MS" fontsize=6 -t -b bgcolor=white label_step=5 border_color=gray thin=8
d.title map=jt_grav_EAC | d.text text="Japan Islands" font="Trebuchet MS" color=yellow size=1.5 linespacing=0.3
d.text text="Marine" color=black size=1.5 font="LucidaGrande" linespacing=0.7
d.text text="free-air" color=black size=1.5 font="LucidaGrande" linespacing=0.7
d.text text="gravity" color=black size=1.5 font="LucidaGrande" linespacing=0.7
