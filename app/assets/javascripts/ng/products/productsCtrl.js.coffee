EdgeRocket = angular.module('EdgeRocket', ['ui.bootstrap'])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@ProductsCtrl = ($scope, $http, $modal, $log, $window) ->

  $scope.course = {}

  loadProduct =  ->
    $http.get('/products/' + $scope.product_id + '.json').success( (data) ->
      $scope.course = data.product
      # the rating is 0-1 decimal, should be multiplied by 5 for the start rating
      $scope.course.display_rating = $scope.course.avg_rating * 5
      # TODO: add price_free field to the DB
      $scope.course.price_free = if $scope.course.price > 0 then false else true
      #debugger
      console.log('Successfully loaded product details')
    ).error( ->
      console.log('Error loading search product details')
    )

  loadProduct()

  $scope.goto = ->
    #debugger
    $window.open($scope.course.origin)

@ProductsCtrl.$inject = ['$scope', '$http', '$modal', '$log', '$window']
