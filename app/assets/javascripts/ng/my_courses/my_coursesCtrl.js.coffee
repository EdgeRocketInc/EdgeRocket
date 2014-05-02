EdgeRocket = angular.module('EdgeRocket', ['ui.bootstrap'])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@MyCoursesCtrl = ($scope, $http, $modal, $log) ->

  loadMyCourses =  ->
    $http.get('/my_courses.json').success( (data) ->
      # massage groups and courses insde
      for cg in data.course_groups
        if cg.status=='Completed'
          cg.statusClass = 'text-success'
          cg.section_open = false
        else
          cg.statusClass = 'text-warning'
          cg.section_open = true
        #console.log('status=' + status + ' Class=' + cg.statusClass)
        for c in cg.my_courses
          # TODO make it less ugly by refactoring the whole JSON structure
          c.product.vendor = (v for v in data.vendors when v.id is c.product.vendor_id)[0]
          #console.log('vendor=' + c.product.vendor.name)
      # massage playlists
      for pl in data.my_playlists
        pl.checked = 'expand'
      $scope.data = data
      console.log('Successfully loaded user_home')
     ).error( ->
      console.log('Error loading user_home')
    )

  loadMyCourses()

@MyCoursesCtrl.$inject = ['$scope', '$http', '$modal', '$log']
