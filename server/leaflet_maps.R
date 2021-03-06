output$mymap <- renderLeaflet({
  # if no mapbox key exists use cartodb dark matter
  if (key == "") {
    map <- leaflet() %>%
      addProviderTiles(
        "CartoDB.DarkMatter"
      ) %>%
      setView(
        lng = 40,
        lat = 30.45,
        zoom = 3
      ) %>%
      htmlwidgets::onRender("function(el, x) {
        L.control.zoom({ position: 'bottomleft' }).addTo(this)
    }")
  } else {
    map <- leaflet(options = leafletOptions(zoomControl = FALSE)) %>%
      addProviderTiles(
        "MapBox",
        options = providerTileOptions(
          id = "mapbox.dark", noWrap = FALSE,
          accessToken = key
        )
      ) %>%
      setView(
        lng = 40,
        lat = 30.45,
        zoom = 3
      ) %>%
      htmlwidgets::onRender("function(el, x) {
        L.control.zoom({ position: 'topright' }).addTo(this)
    }")
  }
})

output$map_wuhan <- renderLeaflet({
  wuhan <- data.frame(
    lon = 114.283,
    lat = 30.583
  )
  coords <- st_as_sf(wuhan, coords = c("lon", "lat"), crs = 4326)
  china <- countries[countries$ADMIN == "China", ]
  leaflet(options = leafletOptions(
    zoomControl = FALSE, minZoom = 4, maxZoom = 4, scrollWheelZoom = FALSE,
    dragging = FALSE, touchZoom = FALSE, doubleClickZoom = FALSE,
    boxZoom = FALSE, attributionControl = FALSE
  )) %>%
    addPolygons(
      data = china,
      fillOpacity = 0,
      color = "#00bb8b",
      weight = 1
    ) %>%
    addPulseMarkers(
      lng = wuhan$lon,
      lat = wuhan$lat,
      icon = makePulseIcon(heartbeat = 0.5, color = "#fb5a19"),
    ) %>%
    setView(
      lat = wuhan$lat + 7,
      lng = wuhan$lon,
      zoom = 1
    )
})


output$map_emergency <- renderLeaflet({
  leaflet(options = leafletOptions(
    zoomControl = FALSE, minZoom = 2, maxZoom = 2, scrollWheelZoom = FALSE,
    dragging = FALSE, touchZoom = FALSE, doubleClickZoom = FALSE,
    boxZoom = FALSE, attributionControl = FALSE
  )) %>%
    addPolygons(
      data = infected,
      fillOpacity = 0,
      color = "#00bb8b",
      weight = 1
    ) %>%
    addPulseMarkers(
      data = coords_inf,
      icon = makePulseIcon(heartbeat = 0.5, color = "#fb5a19", iconSize = 3)
    ) %>%
    setView(
      lat = 40,
      lng = 0,
      zoom = 2
    )
})
