EdgeRocket = angular.module('EdgeRocket', [])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@SearchCtrl = ($scope, $http) ->

  loadCourses =  ->
    $http.get('/search.json').success( (data) ->
      $scope.courses = data
      console.log('Successfully loaded search data')
     ).error( ->       
      console.log('Error loading search data')
    )
       
  loadCourses()  

@SearchCtrl.$inject = ['$scope', '$http']
