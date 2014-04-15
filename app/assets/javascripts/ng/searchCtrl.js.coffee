EdgeRocket = angular.module('EdgeRocket', [])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@SearchCtrl = ($scope, $http) ->

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

@SearchCtrl.$inject = ['$scope', '$http']
