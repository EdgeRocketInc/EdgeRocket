EdgeRocket = angular.module('EdgeRocket', ['ui.bootstrap'])

$(document).ready ->

  addProductIdToForm = (productID) ->
    $("#product-id-for-new-recommendation").val productID

  changeProductsDisplayed = (searchTerm) ->
    products = $("#products-table").find("tr")
    products.each ->
      text = $(this).find(".product-recommendation").text().toLowerCase()
      if text.indexOf(searchTerm.toLowerCase()) > -1
        $(this).show()
      else
        $(this).hide()


  $("#recommendation-search").bind "keyup", ->
    searchTerm = $(this).val()
    changeProductsDisplayed searchTerm

  $(".product-recommendation").click ->
    $("#products-table").find("tr").removeClass "selected-skill"
    productID = $(this).attr("data-product-id")
    addProductIdToForm productID
    $(this).parents("tr").addClass "selected-skill"

