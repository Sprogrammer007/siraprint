ready = ->
  
  $uploading = 'not started';
  $fileDone = 0
  $maxFileNum = 0
  $uploadedFile = 0
  $fileNames = []
  $removing = false;

  $('#fileupload').fileupload
    dataType: 'json',
    add: (e, data) ->
      $maxFileNum = $('#fileupload').data('side')
      $uploadedFile++
      if $uploadedFile > $maxFileNum || data.originalFiles.length > $maxFileNum
        $('#fileupload').find('.alerts').html("One too many file, try uploading " + $maxFileNum + " or less." ) 
        return

      types = /(\.|\/)(gif|jpe?g|png|pdf)$/i
      file = data.files[0]
      if types.test(file.type) || types.test(file.name)
        data.context = $(tmpl("template-upload", file))
        $('#fileupload').append(data.context)

        data.submit()
        #Once File Upload begins the dialog cannot be closed
        $uploading = 'started'
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
      if data.originalFiles.length == 2
        $fileNames[$fileDone] = data.originalFiles[$fileDone].name
      else
        $fileNames[$fileDone] = data.originalFiles[0].name

      $fileDone++
      if $fileDone < $maxFileNum
        return

      $uploading = 'updating db'
      orderProductID = $()
      content = {}
      data = {}
      content['data']= {}

      domain = $('#fileupload').attr('action')
      path = $('#fileupload input[name=key]').val().replace('${filename}', $fileNames[0])
      data['print_pdf'] = (domain + path)

      if $fileNames[1] != undefined
        path2 = $('#fileupload input[name=key]').val().replace('${filename}', $fileNames[1])
        data['print_pdf_2'] = (domain + path2)

      to = $('#fileupload').data('patch')
      content['dataType'] = 'json'
      content['method'] = "PATCH" 
      content['success'] = (data, status) ->
        if ($('.order-cart').length == 1)
          id =  $('#fileupload').data('oid')
          link1 = "<a href='" + domain + path + "'>" + $fileNames[0] + "</a>";
          link2 = '';
          if $fileNames[1] != undefined
            link2 = "<a href='" + domain + path2 + "'>" + $fileNames[1] + "</a>";
          console.log(id)
          $('.upload-' + id ).replaceWith(link1 + link2);
          $('#uploader').modal('hide')
        else 
          $('#fileupload').replaceWith($(tmpl("template-done", file)))
        $fileNames = []
        $fileDone = 0
        $uploadedFile = 0
        $uploading = 'completed'

      content['data'][$('#fileupload').data('as')] =  data
      $.ajax(to, content)
    
      $('#fileupload').find('.progress').removeClass('active')
   
    fail: (e, data) ->
      alert("#{data.files[0].name} failed to upload.")
      $fileNames = [];
      $fileDone = $fileDone--
      $uploadedFile = $uploadedFile--
      $uploading = 'failed'
      $('#fileupload').remove()
      $('#uploader').modal('hide')


  $('#uploader').on 'hidden.bs.modal', (e) ->
    if ($removing)
      return
    $removing = true
    to = $('#fileupload').data('destroy')
    if (to)
      $.ajax(to, dataType: 'json', method: 'DELETE').done () ->
        $removing = false;
    
      $('#fileupload').remove()
      

$(document).on('set.uploader', ready)

