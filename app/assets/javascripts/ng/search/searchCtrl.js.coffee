EdgeRocket = angular.module('EdgeRocket', ['ui.bootstrap'])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@SearchCtrl = ($scope, $http, $modal, $log) ->

  $scope.rows = [0]
  $scope.rowItems = []
  $scope.rowItems[0] = []

  loadCourses =  ->
    $http.get('/search.json').success( (data) ->
      # chunk data into rows for iterating on the page
      r = 0
      c = 0
      for item in data
        # add a display rating variable 
        item.display_rating = item.avg_rating * 5
        $scope.rowItems[r][c] = item
        if (c >= 3)
          r++
          $scope.rowItems[r] = []
          $scope.rows[r] = r
          c = 0
        else
          c++
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

@SearchCtrl.$inject = ['$scope', '$http', '$modal', '$log']
@ModalInstanceCtrl.$inject = ['$scope', '$modalInstance', '$window', '$http', 'course']
