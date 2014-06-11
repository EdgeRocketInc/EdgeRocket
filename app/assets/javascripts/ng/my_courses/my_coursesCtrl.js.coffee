EdgeRocket = angular.module('EdgeRocket', ['ui.bootstrap'])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@MyCoursesCtrl = ($scope, $http, $modal, $log) ->

  $scope.mediaTypes = {
    'video': {
      'glyph' : 'glyphicon-facetime-video',
      'text' : 'Video'
    }
    'mooc': {
      'glyph' : 'glyphicon-cloud',
      'text' : 'MOOC'
    }
  }

  loadMyCourses =  ->
    $http.get('/my_courses.json').success( (data) ->
      # massage groups and courses insde
      for cg in data.course_groups
        if cg.status=='compl'
          cg.statusClass = 'text-success'
          cg.statusText = 'Completed'
          cg.section_open = true
        else if cg.status=='reg'
          cg.statusClass = 'text-warning'
          cg.statusText = 'Assigned'
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
          #debugger
      # massage playlists
      for pl in data.my_playlists
        pl.checked = 'expand'
      $scope.data = data
      $scope.options_json = angular.fromJson($scope.data.account.options)
      console.log('Successfully loaded user_home')
    ).error( ->
      console.log('Error loading user_home')
    )

  loadMyCourses()

  $scope.courseComplete = (cgroup,crs_index) ->
    $scope.courseMove('compl',cgroup,crs_index)
    $scope.current_my_course = cgroup.my_courses[crs_index]
    # prompt user to submit a comment
    modalInstance = $modal.open({
      templateUrl: 'commentModal.html',
      controller: CommentModalCtrl
      resolve:
        current_my_course: () ->
          return $scope.current_my_course
    })

    modalInstance.result.then (review) ->
      # Create data object to POST and send a request
      console.log('new review title=' + review.title + ' for id ' + $scope.current_my_course.product_id)
      data = review
      $http.post('/products/' + $scope.current_my_course.product_id + '/reviews.json', data).success( (data) ->
        console.log('Successfully created review')
      ).error( ->
        console.error('Failed to create review')
      )  

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
    $scope.cgroup = cgroup
    $scope.crs_index = crs_index
    $http.put('/course_subscription/' + mc_id + '.json', data).success( (result_data) ->
      # remove this course from its current group
      mc = $scope.cgroup.my_courses.splice($scope.crs_index,1)
      mc[0].percent_complete = result_data.percent_complete
      # add this course to the new group
      new_group = (g for g in $scope.data.course_groups when g.status is target)[0]
      new_group.my_courses.push(mc[0])
      console.log('Successfully updated subscription')
    ).error( ->
      console.error('Failed to update subscription')
    )

# controller for modal window
@CommentModalCtrl = ($scope, $modalInstance, $window, $http, current_my_course) ->
  console.log('Comment modal ctrl')
  $scope.newReview = { title : '', actor_name : 'me' }
  $scope.rating = { MAX_STARS : 5, display : null }
  $scope.current_my_course = current_my_course

  # When leaving the rating control, save the new rating if needed
  $scope.leavingRating = () ->
    # check if rating changed
    if $scope.rating.display != null
      # Save the new my rating
      console.log('rating changed ' + $scope.rating.display )
      data =
        my_rating : $scope.rating.display / $scope.rating.MAX_STARS
        product_id : $scope.current_my_course.product_id
      $http.put('/my_courses/' + $scope.current_my_course.id + '/rating.json', data).success( (data) ->
        console.log('Successfully updated rating')
      ).error( ->
        console.error('Failed to update rating')
      )

  $scope.save = () ->
    console.log('submitting comment...')
    $modalInstance.close($scope.newReview)

  $scope.cancel = ->
    $modalInstance.dismiss('cancel')

@CommentModalCtrl.$inject = ['$scope', '$modalInstance', '$window', '$http', 'current_my_course'] 
@MyCoursesCtrl.$inject = ['$scope', '$http', '$modal', '$log']
