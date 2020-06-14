#!/bin/sh
# raster NetCDF in WGS84 warped to an Equal Area Cylindrical proj by GDAL via GMT:
gdalwarp -t_srs '+proj=cea lat_ts=38 lon_0=138' jt_relief.nc jt_relief_EAC.nc
#
# g.remove -f type=raster name=jt_relief_EAC
r.in.gdal jt_relief_EAC.nc out=jt_relief_EAC title="Topography: GEBCO grid"
r.timestamp map=jt_relief_EAC date='04 May 2020'
g.list rast
r.info jt_relief_EAC
#
# mapping raster
d.mon wx0
g.region raster=jt_relief_EAC -p
r.colors jt_relief_EAC col=haxby
r.slope.aspect elevation=jt_relief_EAC aspect=jt_aspect_EAC
d.shade shade=jt_aspect_EAC color=jt_relief_EAC
r.contour jt_relief_EAC out=TopoJT_EAC step=2000 --overwrite
d.vect TopoJT_EAC color='75:23:3' width=0
#
# border box
v.in.region output=jt_EAC_bbox
v.info map=jt_EAC_bbox
d.vect jt_EAC_bbox color=red width=3 fill_color="none"
#
# grid
d.grid size=5 color='172:219:250' border_color=yellow width=0.1 fontsize=8 text_color=red bgcolor=white
#
# legend
r.info jt_relief_EAC
d.legend raster=jt_relief_EAC range=-9759.701,3700.742 title=Topography,m title_fontsize=8 font=Arial fontsize=7 -t -b bgcolor=white label_step=1000 border_color=gray thin=8
#
# texts
d.text text="Shaded relief" color='0:0:51' size=2.0 font="Trebuchet MS"
d.text text="GEBCO" color='0:0:51' size=2.0 font="Trebuchet MS"
d.text text="Sea of Japan" color=yellow size=2.5 font="Trebuchet MS"
d.text text="Pacific Ocean" color=yellow size=2.5 font="Trebuchet MS"
d.text text="Honshu Island" color=green size=2.5 font="Trebuchet MS"
d.text text="J  a  p  a  n" color=yellow size=2.5 font="Trebuchet MS" rotation=55
d.text text="T  r  e  n  c  h" color=yellow size=2.5 font="Trebuchet MS" rotation=78
#
d.title map=jt_relief_EAC | d.text text="Shaded topography: Japan Islands" color="green" size=3
# list of available fonts
d.font -l
#g.remove -f type=vector name=jt_relief_EAC
