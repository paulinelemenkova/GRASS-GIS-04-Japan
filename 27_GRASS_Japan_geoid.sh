#!/bin/sh
# cut out an image subset from initial big image using boundary 'clockwise' coordinates W N E S (xMin, yMax, xMax, yMin). Here: cut off Japan Trench geoid
gdal_translate -projwin 128.0000 46.0000 150.0000 30.0000 geoid.egm96.grd geoid.JT.grd

# projecting raster GRD file in WGS84 to Equal Area Cylindr. proj. NetCDF by GDAL via GMT:
gdalwarp -t_srs '+proj=cea lat_ts=38 lon_0=138' geoid.JT.grd geoid_JT_EAC.nc

# importing geoid raster NetCDF file to GRASS GIS via GDAL:
r.in.gdal geoid_JT_EAC.nc out=geoid_JT_EAC title="Geoid: EGM96 grid"
r.timestamp map=geoid_JT_EAC date='04 May 2020'
g.list rast
r.info geoid_JT_EAC

# visualization
d.mon wx0
g.region raster=geoid_JT_EAC res=0.001 nsres=0.001 ewres=0.001 -p -g
r.colors geoid_JT_EAC col=roygbiv
d.rast geoid_JT_EAC
#
r.contour geoid_JT_EAC out=GeoidJT step=3 --overwrite
d.vect GeoidJT color='100:93:134' width=0
d.grid size=4 color=white border_color=yellow width=0.1 fontsize=8 text_color=red
d.legend raster=geoid_JT_EAC range=-3,44 title=Geoid,m title_fontsize=8 font="Trebuchet MS" fontsize=6 -t -b bgcolor=white label_step=5 border_color=gray thin=8
d.title map=geoid_JT_EAC | d.text text="Geoid model: Japan archipelago area" font="Trebuchet MS" color="black" size=3
