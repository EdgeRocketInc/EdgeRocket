$(document).ready ->

  submitButton = $("#submit-query-btn")
  submitButton.attr "disabled", true
  analyticsHours = $("#analytics_hours")
  analyticsSearches = $("#analytics_searches")

  analyticsHours.bind "keyup", ->
    if analyticsSearches.val() isnt "" and $(this).val() isnt ""
      submitButton.removeAttr "disabled"
    else
      submitButton.attr "disabled", true

  analyticsSearches.bind "keyup", ->
    if $(this).val() isnt "" and analyticsHours.val() isnt ""
      submitButton.removeAttr "disabled"
    else
      submitButton.attr "disabled", true



