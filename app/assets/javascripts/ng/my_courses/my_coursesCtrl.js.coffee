EdgeRocket = angular.module('EdgeRocket', ['ui.bootstrap'])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@MyCoursesCtrl = ($scope, $http, $modal, $log) ->

  loadMyCourses =  ->
    $http.get('/my_courses.json').success( (data) ->
      # massage groups and courses insde
      for cg in data.course_groups
        if cg.status=='compl'
          cg.statusClass = 'text-success'
          cg.statusText = 'Completed'
          cg.section_open = false
        else if cg.status=='reg'
          cg.statusClass = 'text-warning'
          cg.statusText = 'Registered'
          cg.section_open = true
        else if cg.status=='wish'
          cg.statusClass = 'text-info'
          cg.statusText = 'Wishlist'
          cg.section_open = true
        else
          cg.statusClass = 'text-primary'
          cg.statusText = 'In Progress'
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

  $scope.courseComplete = (cgroup,crs_index) ->
    $scope.courseMove('compl',cgroup,crs_index)

  $scope.courseWip = (cgroup,crs_index) ->
    $scope.courseMove('wip',cgroup,crs_index)

  $scope.courseRegister = (cgroup,crs_index) ->
    $scope.courseMove('reg',cgroup,crs_index)

  $scope.courseWishlist = (cgroup,crs_index) ->
    $scope.courseMove('wish',cgroup,crs_index)

  $scope.courseMove = (target,cgroup,crs_index) ->
    mc_id = cgroup.my_courses[crs_index].id
    console.log('my course id = ' + mc_id)
    # Create data object to PUT and send a request
    data =
      status: target
    $http.put('/course_subscription/' + mc_id + '.json', data).success( (data) ->
      console.log('Successfully created subscription')
    ).error( ->
      console.error('Failed to create new subscription')
    )
    # remove this course from its current group
    mc = cgroup.my_courses.splice(crs_index,1)
    # add this course to the new group
    new_group = (g for g in $scope.data.course_groups when g.status is target)[0]
    new_group.my_courses.push(mc[0])

@MyCoursesCtrl.$inject = ['$scope', '$http', '$modal', '$log']
