#!/bin/sh
# cut out an image subset from initial big image using boundary 'clockwise' coordinates W N E S (xMin, yMax, xMax, yMin). Here: cut off Japan Trench gravity
# Step-4. Extract a subset for the Japan area via GMT
gdal_translate -projwin 128.0000 46.0000 150.0000 30.0000 GlobSed-v2.nc jt_sedthick.nc
# projecting raster GeoTIFF file to Equal Area Cylindrical projection by GDAL via GMT:
gdalwarp -t_srs '+proj=cea lat_ts=38 lon_0=138' jt_sedthick.nc jt_sedthick_EAC.tif
# importing raster NetCDF file to GRASS GIS via GDAL:
#g.remove -f type=raster name=jt_grav_EAC-
r.in.gdal jt_sedthick_EAC.tif out=jt_sedthick_EAC title="Sediment thickness grid"
r.timestamp map=jt_sedthick_EAC date='04 May 2020'
r.info jt_sedthick_EAC
g.list rast
#
d.mon wx1
r.colors jt_sedthick_EAC col=haxby
g.region raster=jt_sedthick_EAC -p -g
d.rast jt_sedthick_EAC
#
d.vect jt_EAC_bbox color=red width=3 fill_color="none"
d.grid size=4 color=yellow border_color=yellow width=0.1 fontsize=8 bgcolor=white text_color=red
d.vect TopoJT_EAC color='75:23:3' width=0
d.legend raster=jt_sedthick_EAC range=3,8837 title=Sediment_thick,m title_fontsize=7 font="Trebuchet MS" fontsize=6 -t -b bgcolor=white label_step=500 border_color=gray thin=8
d.title map=jt_grav_EAC | d.text text="Sediment thickness" font="Hiragino Sans GB" color=blue size=1.0 linespacing=0.3
d.text text="GlobSed" color=black size=1.5 font="LucidaGrande" linespacing=0.7
d.text text="Earth" color=black size=1.5 font="LucidaGrande" linespacing=0.7
d.text text="Ocean" color=black size=1.5 font="LucidaGrande" linespacing=0.7
d.text text="Sediment" color=black size=1.5 font="LucidaGrande" linespacing=0.7
d.text text="Thickness" color=black size=1.5 font="LucidaGrande" linespacing=0.7
d.font -l
