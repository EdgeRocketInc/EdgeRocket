EdgeRocket = angular.module('EdgeRocket', ['ui.bootstrap'])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@SearchCtrl = ($scope, $http, $modal) ->

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

# controller for modal window
@ModalInstanceCtrl = ($scope, $modalInstance, course) ->
  $scope.course = course

  $scope.enroll = -> 
    $modalInstance.close('enroll')
  
  $scope.cancel = ->
    $modalInstance.dismiss('cancel')

@SearchCtrl.$inject = ['$scope', '$http', '$modal']
@ModalInstanceCtrl.$inject = ['$scope', '$modalInstance', 'course']
