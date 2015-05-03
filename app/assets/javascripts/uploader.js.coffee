ready = ->
  $fileDone = 0
  $maxFileNum = $('#fileupload').data('side')
  $uploadedFile = 0

  $('#fileupload').fileupload
    dataType: 'json',
    add: (e, data) ->

      $uploadedFile = $uploadedFile + data.originalFiles.length

      if $uploadedFile > $maxFileNum || data.originalFiles.length > $maxFileNum
        alert("One too many file, try uploading " + $maxFileNum + " or less." ) 
        return

      types = /(\.|\/)(gif|jpe?g|png|pdf)$/i
      file = data.files[0]
      if types.test(file.type) || types.test(file.name)
        data.context = $(tmpl("template-upload", file))
        $('#fileupload').append(data.context)

        data.submit()
        #Once File Upload begins the dialog cannot be closed
        $('#uploader').find('.close').remove()
        $('#uploader').find('.notice').html("Uploading your designs... this could take a while thank you for your patience.")
      else
        alert("Only pdf, jpeg, gif, and png files are allowed")

    progress: (e, data) ->
      if data.context
        progress = parseInt(data.loaded / data.total * 100, 10)
        data.context.find('.progress').addClass('active')
        data.context.find('.bar').css('width', progress + '%')
        data.context.find('.bar-number').html(progress + '%')

    done: (e, data) ->
      if $fileDone < $maxFileNum
        $fileDone++
        return

      file = data.originalFiles[0]
      file2 = data.originalFiles[1]
      content = {}
      data = {}
      content['data']= {}

      domain = $('#fileupload').attr('action')
      path = $('#fileupload input[name=key]').val().replace('${filename}', file.name)
      data['print_pdf'] = (domain + path)

      if file2 != undefined
        path2 = $('#fileupload input[name=key]').val().replace('${filename}', file2.name)
        data['print_pdf_2'] = (domain + path2)

      to = $('#fileupload').data('patch')
      content['dataType'] = 'json'
      content['method'] = "PATCH" 
      content['success'] = (data, status) ->
        $('#fileupload').replaceWith($(tmpl("template-done", file)))
        $fileDone = 0
        $uploadedFile = 0

      content['data'][$('#fileupload').data('as')] =  data
      $.ajax(to, content)
    
      $('#fileupload').find('.progress').removeClass('active')
   
    fail: (e, data) ->
      alert("#{data.files[0].name} failed to upload.")
      console.log("Upload failed:")
      $fileDone = $fileDone--
      $uploadedFile = $uploadedFile--

  $('#uploader').on 'hidden.bs.modal', (e) ->
    to = $('#fileupload').data('destroy')
    success = (data, status) ->
      location.reload()

    $.ajax(to, dataType: 'json', method: 'DELETE')
    $('#fileupload').remove()

$(document).on('set.uploader', ready)

