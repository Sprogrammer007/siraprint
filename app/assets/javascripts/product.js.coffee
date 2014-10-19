$(document).ready ->

  calc_sqft = (w, l) ->
    unit = $('#unit').find(':selected').val()

    if (unit == "inch")
      return ((w * l)/144)
    else
      return (w * l)

  calc_price = (s, r) ->
    return parseFloat(Math.round((s * r) * 100) / 100).toFixed(2) 
    
  

  change_price = (w, l, t) ->
    sqft = calc_sqft(w, l)
    url = "http://localhost:3000/large_prints/#{t}/get_price/"
    quantity = $('.quantity-field').val()

    $.post(url, sqft: sqft, undefined, "json").done (data) ->
      $('#product_rate').val(data.price)
      price = calc_price(sqft, data.price)
      $('.per-placeholder').html("$#{price}")

      if (quantity != '')
        price = price * quantity

      $('.total-placeholder').html("$#{price}")
      $('#ordered_product_price').val(price)

  convert_to_feet = (x) ->
    return parseFloat(Math.ceil((x * 0.083333) * 10) / 10).toFixed(1)

  convert_to_inch = (x) ->
    return parseFloat(Math.floor(x * 12)).toFixed(0)

    
  $('.product-item-materials').on "click", "label", (e) ->
    id = $(this).prev("input[type=radio]").attr("value")
    $(this).prev("input[type=radio]").prop("checked", true)
    e.preventDefault()
    url = "http://localhost:3000/large_prints/#{id}/get_thickness/"
    $.post(url, undefined, undefined, "script").done ->

  $('#unit').change (e)->
    unit = $(this).find(':selected').val()
    width = $('.product-width').val()
    length = $('.product-length').val()
    if (width != "" || length != "")
      if (unit == "inch")
        $('.product-width').val(convert_to_inch(width))
        $('.product-length').val(convert_to_inch(length))
      else
        $('.product-width').val(convert_to_feet(width))
        $('.product-length').val(convert_to_feet(length))


  $('.product-width, .product-length').change (e)->
    unit = $('#unit').find(':selected').val()
    width = $('.product-width').val()
    length = $('.product-length').val()
    rate = $('#product_rate').val()
    thickness = $('.thickness-selection').find(':selected').val()
    
    if ($(this).val() <= 0)
      $(this).val('')
      return alert("width or length cannot be 0")
   
    if ($(this).hasClass('.product-width'))
      if (unit == "inch")
        if (length != "" && length >= 52 && width > 52) 
          alert("width cannot be more then 52 inch")
          $(this).val('')
      else
        if (length != "" && length >= 4.3 && width >= 4.3) 
          alert("width cannot be more  then 4.3 feet")
          $(this).val('')
    else
      if (unit == "inch")
        if (width != "" && width >= 52 && length > 52) 
          alert("length cannot be more then 52 inch")
          $(this).val('')
      else
        if (width != "" && width >= 4.3 && length > 4.3) 
          alert("length cannot be more  then 4.3 feet")
          $(this).val('')

    if (rate != '' && thickness != undefined && thickness != '')
      change_price(width, length, thickness)  
    
              
  $('.product-width, .product-length').focus (e)->
    rate = $('#product_rate').val()
    thickness = $('.thickness-selection').find(':selected').val()
    if (rate != '' && thickness != undefined && thickness == '')
      alert("Please select a thickness")
      $(this).blur()
      return false

  $('.product-item-thickness-options').on 'change', 'select', (e)->
    width = $('.product-width').val()
    length = $('.product-length').val()
    id = $(this).find(':selected').val()
    url = "http://localhost:3000/large_prints/#{id}/get_price/"
    sqft = calc_sqft(width, length)
    rate = $('#product_rate').val()

    if (width == "" || length == "")
      $(this).prop('selectedIndex', 0)
      return alert("You must enter a length & width")

    if (rate != '')
      if (id == '')
        return
      else
        change_price(width, length, id)
    else
      if (id == '')
        return
      else
        $.post(url, sqft: sqft, undefined, "json").done (data) ->
          $('#product_rate').val(data.price)
          $('.product-item-upload').removeClass('hidden')
          price = calc_price(sqft, data.price)
          $('.per-placeholder').html("$#{price}")
          $('.total-placeholder').html("$#{price}")
          $('#ordered_product_price').val(price)

  $('.product-item-upload').on 'change', '.btn-file :file', ->
    input = $(this)  
    numFiles = (if input.get(0).files then input.get(0).files.length else 1)
    label = input.val().replace(/\\/g, "/").replace(/.*\//, "")
    input.trigger "fileselect", [
      numFiles
      label
    ]
    return

  $(".btn-file :file").on "fileselect", (event, numFiles, label) ->
    input = $(this).parents(".input-group").find(":text")
    log = (if numFiles > 1 then numFiles + " files selected" else label)
    if input.length
      input.val log
      if ($('.product-item-final').hasClass('hidden'))
        $('.product-item-final').removeClass('hidden')
    else
      alert log  if log
    return

  $('.quantity-field').change (e) ->
    quantity = $(this).val()
    price = $('.per-placeholder').html()

    if (quantity < 1)
      $(this).val(1)
      alert("Number of prints must be atleast 1")
    else if (price == '')
      $(this).val(1)
    else
      new_price = parseFloat(Math.round((price.replace("$", '') * quantity) * 100) / 100).toFixed(2) 
      $('.total-placeholder').html("$#{new_price}")

  $('.large-prints-form').submit (e) ->
    thickness = $('.thickness-selection').find(':selected').val()
    total_price = $('.total-placeholder').html()

    if (total_price == '')
      alert("Please follow the steps and enter the require informations")
      e.preventDefault();
      return false
    else if (thickness == undefined || thickness == '')
      alert("Please select a thickness")
      e.preventDefault();
      return false
    else
      return
