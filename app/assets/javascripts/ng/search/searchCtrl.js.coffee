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

# controller for modal window
@ModalInstanceCtrl = ($scope, $modalInstance, $window, $http, course) ->
  $scope.course = course

  $http.get('/products/' + course.id + '.json').success( (data) ->
    $scope.course_description = data.description
    console.log('Successfully loaded product details')
  ).error( ->
    console.log('Error loading search product details')
  )

  $scope.enroll = ->
    #alert('enroll')
    $modalInstance.close($scope.course)

  $scope.goto = ->
    $window.open($scope.course.origin)
    $modalInstance.dismiss('goto')

  $scope.cancel = ->
    $modalInstance.dismiss('cancel')

@SearchCtrl.$inject = ['$scope', '$http', '$modal', '$log']
@ModalInstanceCtrl.$inject = ['$scope', '$modalInstance', '$window', '$http', 'course']
