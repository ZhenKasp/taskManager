$(document).ready ->
  $('.task-check').click ->
    element = $(this)

    $.ajax(
      '/tasks/' + element.data('taskId'),
  		type: 'DELETE',
  		dataType: 'html',
  		error: (jqXHR, textStatus, errorThrown) ->
  			$('.alert').append "AJAX Error: #{textStatus}"
  		success: (data, textStatus) ->
        $('.notice').append "Successful AJAX call"
        element.parent('div').fadeOut(2000, ->
          element.parent('div').remove())
    )
