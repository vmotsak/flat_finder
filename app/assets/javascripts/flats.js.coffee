# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
###
$(".flats.index-1").ready ->
  addedmarkers = []
  handler = Gmaps.build('Google')
  handler.buildMap
    internal:
      id: "gmap"
  , ->
    addedmarkers = markers.map((m) ->
      marker = handler.addMarker(m)
      marker.serviceObject.set "id", m.id.$oid # You can add other attributes using set
      id = marker.getServiceObject().id
      google.maps.event.addListener marker.getServiceObject(), "mouseover", ->
        $("#flat-details-" + id).toggleClass "selected"
        return

      google.maps.event.addListener marker.getServiceObject(), "mouseout", ->
        $("#flat-details-" + id).toggleClass "selected"
        return

      marker
    )
    handler.bounds.extendWith addedmarkers
    handler.fitMapToBounds()
    return

  $(".flat-details").on "click", ->
    console.log this
    id = $(this).data("id")
    result = $.grep(addedmarkers, (e) ->
      e.serviceObject.id is id
    )
    toggleBounce result[0].getServiceObject()  if result
    return

  toggleBounce = (marker) ->
    if marker.getAnimation()?
      marker.setAnimation null
    else
      marker.setAnimation google.maps.Animation.BOUNCE
    return

###