EdgeRocket = angular.module('EdgeRocket', ['ui.bootstrap'])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@MyCoursesCtrl = ($scope, $http, $modal, $log) ->

  loadMyCourses =  ->
    $http.get('/my_courses.json').success( (data) ->
      for status,cg of data.course_groups
        cg.statusClass = if status=='Completed' then 'bg-success' else 'bg-info'
        #console.log('status=' + status + ' Class=' + cg.statusClass)
        for c in cg
          # TODO make it less ugly by refactoring the whole JSON structure
          c.product.vendor = (v for v in data.vendors when v.id is c.product.vendor_id)[0]
          #console.log('vendor=' + c.product.vendor.name)
      $scope.data = data
      console.log('Successfully loaded user_home')
     ).error( ->
      console.log('Error loading user_home')
    )

  loadMyCourses()

@MyCoursesCtrl.$inject = ['$scope', '$http', '$modal', '$log']
