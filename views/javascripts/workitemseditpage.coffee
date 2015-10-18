# workitemseditpage.coffee

$.fn.child = (s) ->
  return $(this).children(s)[0]

$(document).ready ->
  # listen for x-button click -> send ajax -> remove from table

  $(".x-button").on 'click', (e) ->
    console.log "X"

    $tr = $(this).parent().parent()
    id = $tr.attr( "work_item_id" )

    $.ajax(
        type: "get",
        url: "/workitems/delete/" + id,
        success: () ->
          $tr.slideUp 300, () ->
            $tr.remove()
      )

  # double click to update

  $("tr.past-work-item td").on 'click', (e) ->
    e.preventDefault()

    $td = $(this)
    id  = $td.parent().attr( "work_item_id" )

    console.log $td.child()

    $this = $( $td.children()["context"] )

    text      = $this.text()
    attribute = $this.attr( "class" )

    $this.replaceWith("
      <td class='updating-attribute'>
        <input type='text' work_item_attribute='" + attribute + "' value='" + text +  "' />
      </td>" )

$(document).keyup (e) ->
  if e.which == 27 
    data = {}

    for td in $( ".updating-attribute" )
      $td = $( td )

      id        = $td.parent().attr( "work_item_id" )
      attribute = $td.children().attr( "work_item_attribute" )
      value     = $td.children().val()

      data[ id ] = [ attribute, value ]

    console.log $.param( data )

    $.ajax(
        type: "put",
        url: "/workitems/update",
        data: $.param( data ),
        success: () ->
          for td in $( ".updating-attribute" )
            $td = $( td )

            id        = $td.parent().attr( "work_item_id" )
            attribute = $td.children().attr( "work_item_attribute" )
            value     = $td.children().val()

            $td.replaceWith("<td class=#{attribute} >#{value}</td>" )
      )

      
