#!/bin/sh
# raster NetCDF in WGS84 warped to Equal Area Cylindrical proj by GDAL via GMT:
gdalwarp -t_srs '+proj=cea lat_ts=38 lon_0=138' jt_relief.nc jt_relief_EAC.nc
# GRASS GIS
g.list rast
# import raster NetCDF file to GRASS via GDAL:
r.in.gdal jt_relief_EAC.nc out=jt_relief_EAC title="Topography: GEBCO"
r.timestamp map=jt_relief_EAC date='04 May 2020'
r.info jt_relief_EAC
g.region raster=jt_relief_EAC -p
# visualize raster
d.mon wx0
r.colors --help
r.colors jt_relief_EAC col=srtm_plus
d.rast jt_relief_EAC
# isolines
r.contour jt_relief_EAC out=TopoJT_EAC step=1500 --overwrite
d.vect TopoJT_EAC color='brown' width=0
# grid
d.grid size=4 color=white border_color=yellow width=0.1 fontsize=8 text_color=red
# border box
v.in.region output=jt_relief_bbox
g.list vect
v.info map=jt_relief_bbox
d.vect jt_relief_bbox color=red width=3 fill_color="none"
# legend
d.legend raster=jt_relief_EAC range=-9759.701,3700.742 title=Topography,m title_fontsize=8 font=Arial fontsize=7 -t -b bgcolor=white label_step=1000 border_color=gray thin=8
# texts
d.text text="Topography" color='0:0:51' size=2.0 font=Arial
d.text text="GEBCO" color='0:0:51' size=2.0 font=Arial
d.text text="Japan Trench" color='0:0:51' size=2.0 font=Arial
d.text text="Sea of Japan" color=yellow size=2.5 font="Verdana Bold"
d.text text="Pacific Ocean" color=yellow size=2.5 font="Verdana Bold"
d.text text="Honshu Island" color=blue size=2.5 font="Trebuchet MS"
d.text text="Hokkaido Island" color=blue size=2.0 font="Trebuchet MS"
d.text text="Kyushu" color=blue size=2.0 font="Trebuchet MS"
d.text text="Shikoku" color=blue size=2.0 font="Trebuchet MS"
d.text text="Korea" color=blue size=2.0 font="Trebuchet MS"
d.text text="J  a  p  a  n" color=yellow size=2.5 font="Trebuchet MS" rotation=57
d.text text="T  r  e  n  c  h" color=yellow size=2.5 font="Trebuchet MS" rotation=78
# title
d.title map=jt_relief_EAC | d.text text="Topography Japan Trench" color="red" size=5
# list of available fonts
d.font -l
#g.remove -f type=vector name=jt_relief
