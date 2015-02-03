#= require active_admin/base
#= require tinymce-jquery
#= require jquery-fileupload/basic

$(document).ready ->
  $('#slider_image_slide_image').fileupload
    dataType: "script"

  tinyMCE.init
    #General options
    mode : "textareas",
    theme : "modern",
    editor_selector: "tinymce"

  $('form').on 'click', '.remove_tier_fields, .remove_thickness_fields', (event) ->
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    event.preventDefault()

  $('form').on 'click', '.add_new_thickness, .add_new_tier', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    if $(this).hasClass('add_new_tier')

      if $('.large-print-tier-field-group').is(':empty')
        $(this).parent().siblings('.large-print-tier-field-group').html(
          $(this).data('fields').replace(regexp, time).replace("Default Thickness", "New Thickness"))
      else
        $(this).parent().siblings('.large-print-tier-field-group').find('.w25').last()
        .after($(this).data('fields').replace(regexp, time).replace("Default Thickness", "New Thickness"))
    
    else
      $(this).parent().siblings('fieldset').last()
      .after($(this).data('fields').replace(regexp, time).replace("Default Thickness", "New Thickness"))
    event.preventDefault()

  $('.col-thicknesses').on 'click', '.view_thickness_details', (event) ->
    $('.material-detail-wrapper').html($(this).data('detail'))

  #Select all select none
  $('.select_all').click (e) ->
    $('input[type="checkbox"]').each (index, ele) ->
      if !$(ele).prop("checked")
        $(ele).prop("checked", true)
      return

  $('.select_none').click (e) ->
    $('input[type="checkbox"]').each (index, ele) ->
      if $(ele).prop("checked")
        $(ele).prop("checked", false)
      return

  return