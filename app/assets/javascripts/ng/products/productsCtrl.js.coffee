EdgeRocket = angular.module('EdgeRocket', ['ui.bootstrap'])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@ProductsCtrl = ($scope, $http, $modal, $log, $window) ->

  $scope.course = {}
  $scope.my_course = null
  $scope.rating = { 
    MAX_STARS : 5, 
    display : 0, 
    current : 0, 
    read_only : true, # true when current user doesn't have a record in my_courses
    color : 'gray',
    description : 'Unrated'
  }

  # Load product/course details
  loadProduct =  ->
    $http.get('/products/' + $scope.product_id + '.json').success( (data) ->
      $scope.course = data.product
      # TODO: add price_free field to the DB
      $scope.course.price_free = if $scope.course.price > 0 then false else true
      #debugger
      console.log('Successfully loaded product details')
      loadMyCourse()
    ).error( ->
      console.log('Error loading search product details')
    )

  # Load My course details that add more specific informaiton such as my own rating of this course
  loadMyCourse =  ->
    $http.get('/my_courses/' + $scope.product_id + '.json').success( (data) ->
      $scope.my_course = data.my_course
      console.log('Successfully loaded my course')
      setDisplayRating()
    ).error( ->
      console.log('Error loading search my course')
      # set rating dispolay even if failed to load my courses
      setDisplayRating()
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
    # if this user has rated it, use that rating, otherwise use the average one
    if $scope.my_course != null 
      $scope.rating.read_only = false # the user has my course record
      if $scope.my_course.my_rating != null
        # the user has rated the course
        $scope.rating.current = $scope.my_course.my_rating
        $scope.rating.color = 'red'
        $scope.rating.description = 'My rating'
    # the rating is 0-1 decimal, should be multiplied by 5 for the star rating
    $scope.rating.display = $scope.rating.current * $scope.rating.MAX_STARS
    console.log("rating structure " + JSON.stringify($scope.rating))

  loadProduct()

  $scope.goto = ->
    #debugger
    $window.open($scope.course.origin)

  $scope.backToMyCourses = ->
    $window.location.href = "/my_courses"

  # When leaving the rating control, save the new rating if needed
  $scope.leavingRating = () ->
    # check if rating changed
    if $scope.rating.display != ($scope.rating.current * $scope.rating.MAX_STARS)
      # Save the new my rating
      console.log('rating changed ' + $scope.rating.display )
      data =
        my_rating : $scope.rating.display / $scope.rating.MAX_STARS
        product_id : $scope.my_course.product_id
      $http.put('/my_courses/' + $scope.my_course.id + '/rating.json', data).success( (data) ->
        console.log('Successfully created subscription')
        $scope.rating.current = data.my_rating
        $scope.rating.color = 'red'
        $scope.rating.description = 'My rating'
      ).error( ->
        console.error('Failed to create new subscription')
      )

@ProductsCtrl.$inject = ['$scope', '$http', '$modal', '$log', '$window']
