# This controller is for displaying product details
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
  $scope.reviews = null
  $scope.newReview = { title : '', actor_name : 'me', gplus : false }
  $scope.enrolled = false
  $scope.showAlert = true

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
      $scope.enrolled = if $scope.my_course==null then false else true
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

  loadReviews = ->
    $http.get('/products/' + $scope.product_id + '/reviews.json').success( (data) ->
      $scope.reviews = data.reviews
      #debugger
      console.log('Successfully loaded product reviews')
      loadMyCourse()
    ).error( ->
      console.log('Error loading search product reviews')
    )

  # Loading current user just for account options
  loadAccountOptions = ->
    $http.get('/users/current.json').success( (data) ->
      $scope.user = data
      console.log('Successfully loaded user')
      $scope.options_json = angular.fromJson($scope.user.account.options)
      if $scope.options_json.discussions
        # set checkbox for G+
        $scope.options_json.gbox_class = if $scope.options_json.discussions == 'gplus' then 'check' else null
        loadReviews()
    ).error( ->
      console.log('Error loading user')
    )


  # Invoke methods, and keep in mind they may run async
  loadProduct()
  # load options and reviews
  loadAccountOptions()

  $scope.goto = ->
    #debugger
    # Post an event to KeenIO via ER server
    $http.post('/products/' + $scope.course.id + '/goto.json', null).success( (data) ->
      console.log('product clicked')
    ).error( ->
      console.error('Failed to post prduct click event')
    )
    $window.open($scope.course.origin)

  $scope.backToMyCourses = ->
    $window.location.href = "/user_home"

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
        console.log('Successfully updated rating')
        $scope.rating.current = data.my_rating
        $scope.rating.color = 'red'
        $scope.rating.description = 'My rating'
      ).error( ->
        console.error('Failed to update rating')
      )

  $scope.createReview = () ->
    # Create data object to POST and send a request
    console.log('new title=' + $scope.newReview.title)
    $scope.newReview.gplus = ($scope.options_json.gbox_class == 'check')
    data = $scope.newReview
    $http.post('/products/' + $scope.product_id + '/reviews.json', data).success( (data) ->
      saved_reviews = { 
        title : $scope.newReview.title, 
        user : { first_name : '<me>', last_name : null }
      }
      $scope.reviews.splice(0,0,saved_reviews)
      $scope.newReview.title = ''
      console.log('Successfully created review')
    ).error( ->
      console.error('Failed to create review')
    )
    return true

  $scope.toggleGBox = () ->
    if $scope.options_json.gbox_class == 'check'
      $scope.options_json.gbox_class = 'unchecked'
    else
      $scope.options_json.gbox_class = 'check'

  $scope.closeAlert = ->
    $scope.showAlert = false

  # Add this course to the user's wishlist
  $scope.enroll = ->
    # Create data object to POST and send a request
    data =
      course_id: $scope.product_id
      status: 'wish'
      assigned_by: 'Self'
    $http.post('/course_subscription.json', data).success( (data) ->
      console.log('Successfully created subscription')
      $scope.enrolled = true
      $scope.showAlert = true
    ).error( ->
      console.error('Failed to create new subscription')
    )

@ProductsCtrl.$inject = ['$scope', '$http', '$modal', '$log', '$window']
