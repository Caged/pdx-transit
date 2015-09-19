all: \
	data/shp/trimet-boundary.shp \
	data/shp/trimet-park-and-rides.shp \
	data/shp/trimet-rail-stops.shp \
	data/shp/trimet-rail-lines.shp \
	data/shp/trimet-routes.shp \
	data/shp/trimet-stops.shp \
	data/shp/trimet-route-stops.shp \
	data/shp/trimet-transit-centers.shp

.SECONDARY:

################################################################################
#	SHAPEFILES: TRIMET
################################################################################
data/shp/trimet-boundary.shp: data/gz/trimet/tm_boundary.zip
data/shp/trimet-park-and-rides.shp: data/gz/trimet/tm_parkride.zip
data/shp/trimet-rail-stops.shp: data/gz/trimet/tm_rail_stops.zip
data/shp/trimet-rail-lines.shp: data/gz/trimet/tm_rail_lines.zip
data/shp/trimet-routes.shp: data/gz/trimet/tm_routes.zip
data/shp/trimet-stops.shp: data/gz/trimet/tm_stops.zip
data/shp/trimet-route-stops.shp: data/gz/trimet/tm_route_stops.zip
data/shp/trimet-transit-centers.shp: data/gz/trimet/tm_tran_cen.zip

################################################################################
# SHAPEFILE EXTRACTION
################################################################################
shp/%.shp:
	rm -rf $(basename $@)
	mkdir -p $(basename $@)
	tar --exclude="._*" -xzm -C $(basename $@) -f $<

	for file in `find $(basename $@) -name '*.shp'`; do \
		ogr2ogr -dim 2 -f 'ESRI Shapefile' -t_srs 'EPSG:4326' $(basename $@).$${file##*.} $$file; \
		chmod 644 $(basename $@).$${file##*.}; \
	done
	rm -rf $(basename $@)

################################################################################
# ARCHIVE REQUEST
################################################################################
data/gz/trimet/%.zip:
	mkdir -p $(dir $@)
	curl -L --remote-time 'http://developer.trimet.org/gis/data/$(notdir $@)' -o $@.download
	mv $@.download $@
