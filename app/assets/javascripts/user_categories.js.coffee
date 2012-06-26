merge = ->
  result = ""
  $('.mass_checkbox').each((index) ->
    if $(this).attr("checked")
      result += ", " + $(this).attr("name").substring(2)
  )

  if result.length > 0
    result = result.substring(2)

  $.ajax({
    url: "/user_categories/merge?ids=#{result}"
    type: "PUT"
    error: (xhr, status, error) ->
      alert(error)
    success: ->
      location.reload()
  })

$ ->
  $("#btnMerge").click(merge)
