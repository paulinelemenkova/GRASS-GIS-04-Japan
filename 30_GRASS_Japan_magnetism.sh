#!/bin/sh
# cut out an image subset from initial big image using boundary 'clockwise' coordinates W N E S (xMin, yMax, xMax, yMin). Here: cut off Japan Trench gravity
# Step-4. Extract a subset for the Japan area via GMT
gdal_translate -projwin 128.0000 46.0000 150.0000 30.0000 EMAG2_V3_UpCont_DataTiff.tif magnet.JT.tif
# projecting raster GeoTIFF file to Equal Area Cylindrical projection by GDAL via GMT:
gdalwarp -t_srs '+proj=cea lat_ts=38 lon_0=138' magnet.JT.tif jt_magnet_EAC.tif
# importing geoid raster NetCDF file to GRASS GIS via GDAL:
#g.remove -f type=raster name=jt_grav_EAC-
r.in.gdal jt_magnet_EAC.tif out=jt_magnet_EAC title="Magnetic Anomaly: EMAG2v3 grid"
r.timestamp map=jt_magnet_EAC date='04 May 2020'
g.list rast
r.info jt_magnet_EAC
r.colors jt_magnet_EAC col=haxby
r.colors jt_magnet_EAC col=rainbow
#
d.mon wx1
g.region raster=jt_magnet_EAC -p -g
d.rast jt_magnet_EAC
#
d.vect jt_EAC_bbox color=red width=3 fill_color="none"
d.grid size=4 color=yellow border_color=yellow width=0.1 fontsize=8 bgcolor=white text_color=red
d.vect TopoJT_EAC color='75:23:3' width=0
d.legend raster=jt_magnet_EAC range=-373.4002,440.7733 title=Magnetic_anomaly title_fontsize=7 font="Trebuchet MS" fontsize=6 -t -b bgcolor=white label_step=50 border_color=gray thin=8
d.title map=jt_grav_EAC | d.text text="Japan Islands" font="Trebuchet MS" color=yellow size=1.5 linespacing=0.3
d.text text="EMAG2" color=black size=1.5 font="LucidaGrande" linespacing=0.7
d.text text="Earth" color=black size=1.5 font="LucidaGrande" linespacing=0.7
d.text text="Magnetic" color=black size=1.5 font="LucidaGrande" linespacing=0.7
d.text text="Anomaly" color=black size=1.5 font="LucidaGrande" linespacing=0.7
d.text text="Grid" color=black size=1.5 font="LucidaGrande" linespacing=0.7
