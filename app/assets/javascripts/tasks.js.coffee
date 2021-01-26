$ ->
  $('.task-check').click ->
    $taskCheckbox = $(this)

    $.ajax(
      '/tasks/' + $taskCheckbox.data('taskId'),
      type: 'DELETE',
      error: ({ error }) ->
        $alert = $('.alert')

        $alert.append(error)
        $alert.fadeOut(2000, $alert.find('span').remove)
      success: ->
        $taskDiv = $taskCheckbox.parent('div')
        $taskDiv.fadeOut(2000, $taskDiv.remove)
    )
