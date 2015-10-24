# application.coffee

addEmailLink = ->
  if $("#email") != null
    userName     = "aaron.zick"
    hostName     = "gmail.com"
    emailAddress = userName + "@" + hostName
    $("#email").replaceWith "<a href='mailto:" + emailAddress + "'>" + emailAddress + "</a>"

workPageSelector = ( category ) ->
  $selected = $('.work-page-button.selected')

  departing_cat = $selected.attr( "category" )

  if category == "all" and departing_cat != "all"
    $( ".work-item" ).not( ":visible" ).fadeIn()
  else
    $( ".#{category}" ).not( ":visible" ).fadeIn( "slow" )
    $( ".work-item").not( ".#{category}").fadeOut( "slow" )


  if $selected != null
    $selected.removeClass 'selected'

  $(".work-page-button[category='" + category + "'").addClass 'selected'


#############################################################

# to do : enum
pages = ['landing','about','work','gear','blog','contact']
page = 0

$(document).ready ->
  navTop = $('#'+pages[1]).position().top

  addEmailLink()

  $(".work-page-button").on 'click', (e) ->
    workPageSelector( $(this).attr("category") )

  $(window).resize ->
    navTop = $(window).height() + 171
    handleScrollCase $('#landing').parent().scrollTop()

  $('#landing').parent().scroll ->
    handleScrollCase $(this).scrollTop()

  handleScrollCase = ( top ) ->
    currentPos = top
    currentNavPos = $('#navigation-bar').position().top

    # arrow
    if currentPos > 10
      if $('#arrow').css( 'display' ) != 'none'
        $('#arrow').fadeOut 600
    else
      if $('#arrow').css( 'display' ) == 'none'
        $('#arrow').fadeIn 600

    pageHeight = $('#landing').parent().height()
    percentageBGScroll = ((currentPos - pageHeight)/(pageHeight + 2367 - pageHeight/2))*100
    if percentageBGScroll > 100
      percentageBGScroll = 100
    if percentageBGScroll < 0
      percentageBGScroll = 0

    $('html').css('background-position-y',(percentageBGScroll)+'%')

    # nav bar scrolling
    smallDif = 0
    if $(window).width() <= 880
      smallDif = 91

    $navBar = $('#navigation-bar-container')
    if currentPos > (navTop - smallDif)
      $navBar.addClass 'fixed-to-top'
    else
      $navBar.removeClass 'fixed-to-top'

    # name scrolling
    $name = $('#name')

    if currentPos > 80
      $name.addClass 'fixed-to-top'
    else
      $name.removeClass 'fixed-to-top'

    for cur_page in pages
      if $('#'+cur_page).offset().top < 100 && $('#'+cur_page).offset().top > -$('#'+cur_page).height() && !$("#"+cur_page+"_button").is(':animated')
        $("#"+cur_page+"_button").addClass('current')
        $("#"+cur_page+"_button").removeClass('not_current')
      else
        $("#"+cur_page+"_button").removeClass('current')
        $("#"+cur_page+"_button").addClass('not_current')
