class MapWidget
  constructor: () ->
    @data = $('#data').data("map")

    @map = L.mapbox.map('map', 'nypllabs.g6ei9mm0',
      zoomControl: false
      scrollWheelZoom: false
      touchZoom: false
      animate: true
      attributionControl: false
      minZoom: 12
      maxZoom: 21
      dragging: true
      tileLayer: # added this because maptiles.nypl does not support retina yet
        detectRetina: false
    )

    layer_data = $("#data").data("layer")
    tileset = layer_data.tilejson
    tiletype = layer_data.tileset_type

    if (tiletype!="wmts")
      @overlay = L.mapbox.tileLayer(tileset,
        zIndex: 2
        detectRetina: false # added this because maptiles.nypl does not support retina yet
      ).addTo(@map)
    else
      @overlay = new L.TileLayer.WMTS(tileset ,
        zIndex: 2
        detectRetina: false # added this because maptiles.nypl does not support retina yet
      ).addTo(@map)

    L.control.zoom(
      position: 'bottomleft'
    ).addTo(@map)

    t = @
    @map.on('load', @loadData)


  loadData: () =>
    el = $("#stats")


    bbox = @data.bbox.split(",")

    console.log @data.bbox, bbox

    W = parseFloat(bbox[0])
    S = parseFloat(bbox[1])
    E = parseFloat(bbox[2])
    N = parseFloat(bbox[3])

    SW = new L.LatLng(S, W)
    NW = new L.LatLng(N, W)
    NE = new L.LatLng(N, E)
    SE = new L.LatLng(S, E)

    bounds = new L.LatLngBounds(SW, NE)

    @map.fitBounds( bounds )

    # $.getJSON(url, (data) ->
    #   el.find('.spinner').remove()
    #   console.log data
    #   t.processData(data)
    # )

  # processData: (data) =>
  #   # console.log "processing data"

  #   no_color = '#AF2228'
  #   yes_color = '#609846'
  #   fix_color = '#FFB92D'
  #   nil_color = '#AAAAAA'

  #   return unless data?.nil_poly?.features? && data?.fix_poly?.features? && data?.no_poly?.features? && data?.yes_poly?.features?

  #   # console.log "processing started"

  #   m = @map

  #   yes_json = L.geoJson(data.yes_poly,
  #     style: (feature) ->
  #       color: yes_color
  #       opacity: 0.7
  #       weight: 2
  #       dashArray: [6,6]
  #       fillOpacity: 0
  #       stroke: true
  #   )
  #   no_json = L.geoJson(data.no_poly,
  #     style: (feature) ->
  #       color: no_color
  #       opacity: 0.7
  #       weight: 2
  #       dashArray: [6,6]
  #       fillOpacity: 0
  #       stroke: true
  #   )
  #   fix_json = L.geoJson(data.fix_poly,
  #     style: (feature) ->
  #       color: fix_color
  #       opacity: 0.7
  #       weight: 2
  #       dashArray: [6,6]
  #       fillOpacity: 0
  #       stroke: true
  #   )
  #   nil_json = L.geoJson(data.nil_poly,
  #     style: (feature) ->
  #       color: nil_color
  #       opacity: 0.7
  #       weight: 2
  #       dashArray: [6,6]
  #       fillOpacity: 0
  #       stroke: true
  #   )

  #   bounds = new L.LatLngBounds()

  #   if data.yes_poly.features.length>0
  #     yes_json.addTo(m)
  #     bounds.extend(yes_json.getBounds())

  #   if data.no_poly.features.length>0
  #     no_json.addTo(m)
  #     bounds.extend(no_json.getBounds())

  #   if data.fix_poly.features.length>0
  #     fix_json.addTo(m)
  #     bounds.extend(fix_json.getBounds())

  #   if data.nil_poly.features.length>0
  #     nil_json.addTo(m)
  #     bounds.extend(nil_json.getBounds())

  #   m.panTo(bounds.getCenter())

$ ->
  window._s = new MapWidget