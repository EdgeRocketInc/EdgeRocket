EdgeRocket = angular.module('EdgeRocket', ['ui.bootstrap', 'ngGrid'])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

# This controller is for displaying product details
@PublicProductCtrl = ($scope, $http, $modal, $log, $window) ->

  $scope.course = {}
  $scope.rating = { 
    MAX_STARS : 5, 
    display : 0, 
    current : 0, 
    read_only : true, # true when current user doesn't have a record in my_courses
    color : 'gray',
    description : 'Unrated'
  }
  $scope.found = false

  # Load product/course details
  loadProduct =  ->
    $http.get('/public/products/' + $scope.product_id + '.json').success( (data) ->
      $scope.course = data.product
      $scope.found = !jQuery.isEmptyObject($scope.course)
      # TODO: add price_free field to the DB
      $scope.course.price_free = if $scope.course.price > 0 then false else true
      console.log('Successfully loaded product details')
    ).error( ->
      console.log('Error loading search product details')
    )


  # Calculate and set the rating to display
  setDisplayRating =  ->
    # first set to the rating to the average
    if $scope.course != null && $scope.course.avg_rating != null
      $scope.rating.current = $scope.course.avg_rating
      $scope.rating.color = 'orange'
      $scope.rating.description = 'Avg. rating'
    else
      $scope.rating.current = 0
    # the rating is 0-1 decimal, should be multiplied by 5 for the star rating
    $scope.rating.display = $scope.rating.current * $scope.rating.MAX_STARS
    console.log("rating structure " + JSON.stringify($scope.rating))

  # Invoke methods, and keep in mind they may run async
  loadProduct()

  $scope.goto = ->
    #debugger
    $window.open($scope.course.origin)

@PublicProductCtrl.$inject = ['$scope', '$http', '$modal', '$log', '$window']
