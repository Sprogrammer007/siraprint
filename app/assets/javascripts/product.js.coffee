ready = ->
  $(".dropdown.keep-open").on
    "shown.bs.dropdown": ->
      @closable = false
      return false

    click: ->
      @closable = false
      return

    "hide.bs.dropdown": ->
      @closable

  # $('.dropdown').on 'hide.bs.dropdown', ->
  #   return false;

  calc_sqft = (w, l) ->
    unit = $('.product-unit').find(':selected').val()

    if (unit == "inch")
      return ((w * l)/144)
    else
      return (w * l)

  calc_price = (s, r) ->
    return parseFloat(Math.round((s * r) * 100) / 100).toFixed(2) 
    
  change_price = (w, l, t) ->
    sqft = calc_sqft(w, l)
    url = $('.price-url').data('price-url')
    quantity = $('.quantity-field').val()
    f_price = Math.round(($('.finishing-placeholder').html().replace("$", '') * 100) / 100)
    
    $.post(url, sqft: sqft, undefined, "json").done (data) ->
      if data == null
        $('#_orderproduct_rate').val(0)
      else
        $('#_orderproduct_rate').val(data.price)
      price = calc_price(sqft, data.price)
      
      $('.per-placeholder').html("$#{price}")
      $('#_orderunit_price').val(price)
      if (quantity != '')
        price = price * quantity
      if ( $('.finishing-placeholder').html() != '' )
        price = price + parseFloat(f_price))
       
      $('.total-placeholder').html("$#{price}")
      $('#_ordertotal_price').val(price)

  convert_to_feet = (x) ->
    return parseFloat(Math.ceil((x * 0.083333) * 100) / 100).toFixed(2)

  convert_to_inch = (x) ->
    return parseFloat(Math.floor(x * 12)).toFixed(0)

  $('.order_form').on 'change', '.product-unit', (e) ->
    unit = $(this).find(':selected').val()
    width = $('.product-width').val()
    length = $('.product-length').val()

    if (unit == "inch")
      new_width = convert_to_inch(width)
      new_length = convert_to_inch(length)
      $('.product-width').val(new_width)
      $('.product-length').val(new_length)
      e.preventDefault()
    else
      new_width = convert_to_feet(width)
      new_length = convert_to_feet(length)
      $('.product-width').val(new_width)
      $('.product-length').val(new_length)
      e.preventDefault()

  $('.order_form').on 'change', '.product-width, .product-length', (e) ->
    unit = $('.product-unit').find(':selected').val()
    width = $('.product-width').val()
    length = $('.product-length').val()
    rate = $('#_orderproduct_rate').val()
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
        if (length != "" && length >= 4.34 && width >= 4.34) 
          alert("width cannot be more  then 4.34 feet")
          $(this).val('')
    else
      if (unit == "inch")
        if (width != "" && width >= 52 && length > 52) 
          alert("length cannot be more then 52 inch")
          $(this).val('')
      else
        if (width != "" && width >= 4.34 && length > 4.34) 
          alert("length cannot be more  then 4.34 feet")
          $(this).val('')

    if (rate != '' && thickness != undefined && thickness != '')
      change_price(width, length, thickness)  

  $('.order_form').on 'focus', '.product-width, .product-length', (e)->
    rate = $('#_orderproduct_rate').val()
    thickness = $('.thickness-selection').find(':selected').val()
    if (rate != '' && thickness != undefined && thickness == '')
      alert("Please select a thickness")
      $(this).blur()
      return false

  $('.order_form').on 'change', '.side-selection ', (e)->
    side = $(this).find(':selected').val()
    w = $('.product-width').val()
    l = $('.product-length').val()
    u = $('.product-unit').find(':selected').val()
    name = $(this).data('name')
    url = $(this).data('url')

    $.post(url, {name: name, side: side, width: w, length: l, unit: u } , undefined, "script")

  $('.order_form').on 'change', '.thickness-selection', (e)->
    width = $('.product-width').val()
    length = $('.product-length').val()
    id = $(this).find(':selected').val()
    url = $('.price-url').data('price-url')
    sqft = calc_sqft(width, length)
    rate = $('#_orderproduct_rate').val()

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
          if data == null
            $('#_orderproduct_rate').val(0)
          else
            $('#_orderproduct_rate').val(data.price)
          price = calc_price(sqft, data.price)
          $('.per-placeholder').html("$#{price}")
          $('.total-placeholder').html("$#{price}")
          $('#_orderunit_price').val(price)
          $('#_ordertotal_price').val(price)

  $('.order_form').on 'change', '.btn-file :file', ->
    input = $(this)  
    numFiles = (if input.get(0).files then input.get(0).files.length else 1)
    label = input.val().replace(/\\/g, "/").replace(/.*\//, "")
    input.trigger "fileselect", [
      numFiles
      label
    ]
    return

  $('.order_form').on 'change', '.finish-selection', ->
    option = $(this).find(':selected').val()
    w = $('.product-width').val()
    l = $('.product-length').val()
    sqft = calc_sqft(w, l)
    u = $('#_orderunit_price').val()
    f = $('.finishing-placeholder').html()
    q = $('.quantity-field').val()

    if (w == "" || l == "")
      $(this).prop('selectedIndex', 0)
      return alert("You must enter a length & width")
    else if (u == "")
      $(this).prop('selectedIndex', 0)
      return alert("You must enter a select a thickness")

    if option == "Grommets"
      $('.grommets-box').removeClass('hidden')
      if f != ''
        $('.finishing-placeholder').html("0")

    else
      $('.grommets-box').addClass('hidden')
      f_price = parseFloat(sqft).toFixed(2) 
      $('.finishing-placeholder').html("$#{f_price}")
      new_total = (parseFloat(f_price) + (parseFloat(u) * q)).toFixed(2)
      $('#_ordertotal_price').val(new_total)
      $('.total-placeholder').html("$#{new_total}")
  
  # Grommet Quantity Change
  $('.order_form').on 'change', '.grommets-field', ->
    gq = $(this).val()
    u = $('#_orderunit_price').val()
    q = $('.quantity-field').val()
    f_price = gq * 1

    $('.finishing-placeholder').html("$#{f_price}")
    new_total = (parseFloat(f_price) + (parseFloat(u) * q)).toFixed(2)
    $('#_ordertotal_price').val(new_total)
    $('.total-placeholder').html("$#{new_total}")

  # File Upload
  $('.order_form').on "fileselect", ".btn-file :file", (event, numFiles, label) ->
    input = $(this).parents(".input-group").find(":text")
    log = (if numFiles > 1 then numFiles + " files selected" else label)
    if input.length
      input.val log
    else
      alert log  if log
    return


  # Quantity Change
  $('.order_form').on 'change', '.quantity-field', (e) ->
    quantity = $(this).val()
    price = $('.per-placeholder').html()

    if (quantity < 1)
      $(this).val(1)
      alert("Number of prints must be atleast 1")
    else if (price == '')
      $(this).val(1)
    else
      new_price = parseFloat(Math.round((price.replace("$", '') * quantity) * 100) / 100).toFixed(2) 
      $('#_ordertotal_price').val(new_price)
      $('.total-placeholder').html("$#{new_price}")

  # Update Quantity for Order Page
  $('.qty-update-button').click (e) ->
    e.preventDefault()
    quantity = $(this).parents().prev("input").val()
    url = $(this).attr('data-url')
    $.post(url, {quantity: quantity} , undefined, "script")

  # Metal Signs

  $('.sign-item-size').on 'change', 'select', (e) ->
    price = parseFloat($(this).find(':selected').text().split('$')[1])
  
    if !isNaN(price)
      price = price * $('.quantity-field').val()
      $('.per-placeholder').html("$#{price}")
      $('.total-placeholder').html("$#{price}")
      $('#_orderunit_price').val(price)
      $('#_ordertotal_price').val(price)
      
    else
      $('.per-placeholder').html("$0")
      $('.total-placeholder').html("$0")
      $('#_orderunit_price').val(0)
      $('#_ordertotal_price').val(0)


$(document).ready(ready)
$(document).on('page:load', ready)