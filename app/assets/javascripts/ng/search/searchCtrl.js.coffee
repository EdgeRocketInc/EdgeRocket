EdgeRocket = angular.module('EdgeRocket', ['ui.bootstrap'])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@SearchCtrl = ($scope, $http, $modal, $log, $filter) ->

  $scope.items = []
  # for media type checkboxes
  $scope.mediaCbAll = { class : 'check' }
  $scope.mediaCheckboxes = [
    { class : 'check', label : 'Courses', media_type : 'online' }
    { class : 'check', label : 'Books', media_type : 'book' }
    { class : 'check', label : 'Articles', media_type : 'blog' }
    { class : 'check', label : 'Videos', media_type : 'video' }
  ]
  $scope.limitItems = 100

  loadCourses =  ->
    $http.get('/search.json').success( (data) ->
      #debugger
      # the server may return literal null
      if data != 'null'
        # massage data for displaying
        for item in data
          # add a display rating variable 
          item.display_rating = item.avg_rating * 5
          # add a formatted price 
          item.price_fmt = if item.price > 0 then $filter('currency')(item.price, '$') else 'Free'
        $scope.items = data
      else
        $scope.items = null
      console.log('Successfully loaded search data')
    ).error( ->
      console.log('Error loading search data')
    )

  loadCourses()

  # modal window with course details
  $scope.openModal = (selectedCourse) ->
    $scope.course = selectedCourse
    modalInstance = $modal.open({
      templateUrl: 'searchModalDetails.html',
      controller: ModalInstanceCtrl
      resolve:
        course: () ->
          return $scope.course
    })

    modalInstance.result.then (crs) ->
      console.log('Adding course...' + crs.id)
      # Create data object to POST and send a request
      data =
        course_id: crs.id
        status: 'wish'
        assigned_by: 'Self'
      $http.post('/course_subscription.json', data).success( (data) ->
        console.log('Successfully created subscription')
      ).error( ->
        console.error('Failed to create new subscription')
      )

  # toggle all media type checkboxes, and filter the search result accordingly
  $scope.toggleMediaAll = ->
    if $scope.mediaCbAll.class == 'check'
      $scope.mediaCbAll.class = 'unchecked'
      for cb in $scope.mediaCheckboxes
        cb.class = 'unchecked'
    else
      $scope.mediaCbAll.class = 'check'
      for cb in $scope.mediaCheckboxes
        cb.class = 'check'

  # toggle single media type check box
  $scope.toggleMediaCbox = (cbox) ->
    if cbox.class == 'check' 
      cbox.class = 'unchecked' 
      $scope.mediaCbAll.class = 'unchecked'
    else
      cbox.class = 'check' 
    
  # Filter for media types. 
  # Returns true if all media types are enabled or a specific type matches enabled checkbox
  $scope.filterMediaType = (product) ->
    result = false
    if $scope.mediaCbAll.class == 'check'
      result = true
    else
      for cbox in $scope.mediaCheckboxes
        if cbox.class == 'check' && product.media_type == cbox.media_type
          result = true
          break
    result

# ------- controller for modal window --------------

@ModalInstanceCtrl = ($scope, $modalInstance, $window, $http, course) ->
  $scope.course = course
  $scope.alerts = []

  $http.get('/products/' + course.id + '.json').success( (data) ->
    $scope.course_description = data.product.description
    console.log('Successfully loaded product details')
  ).error( ->
    console.log('Error loading search product details')
  )

  loadUser =  ->
    $http.get('/users/current.json').success( (data) ->
      $scope.user = data
      if $scope.user.best_role == 'admin' ||  $scope.user.best_role == 'SA'
        $scope.user.admin_role = true
      console.log('Successfully loaded user')
    ).error( ->
      console.log('Error loading user')
    )

  loadPlaylists =  ->
    $http.get('/user_home.json').success( (data) ->
      $scope.pl_data = data
      console.log('Successfully loaded playlists')
    ).error( ->
      console.log('Error loading playlists')
    )

  loadUser()
  loadPlaylists()

  $scope.enroll = ->
    #alert('enroll')
    $modalInstance.close($scope.course)

  $scope.goto = ->
    $window.open($scope.course.origin)
    $modalInstance.dismiss('goto')

  $scope.cancel = ->
    $modalInstance.dismiss('cancel')

  $scope.addToPlaylist = (course, playlist) ->
    console.log('addToPlaylist course id=' + course.id + ' playlist=' + playlist.title)
    # POST and send a request
    data = {}
    $http.post('/playlists/' + playlist.id + '/courses/' + course.id + '.json', data).success( (data) ->
      console.log('Successfully added to playlist')
      $scope.alerts.push({ 
        type: 'success', 
        msg: '* Added to Playlist' 
      })
    ).error( ->
      console.error('Failed to add to playlist')
    )

@SearchCtrl.$inject = ['$scope', '$http', '$modal', '$log', '$filter']
@ModalInstanceCtrl.$inject = ['$scope', '$modalInstance', '$window', '$http', 'course']
