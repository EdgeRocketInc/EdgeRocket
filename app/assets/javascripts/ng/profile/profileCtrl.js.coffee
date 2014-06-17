EdgeRocket = angular.module('EdgeRocket', ['ui.bootstrap'])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@ProfileCtrl = ($scope, $http) ->
  $scope.user = null
  $scope.profile = null
  $scope.orig_user = null
  $scope.orig_profile = null

  loadData =  ->
  $http.get('/users/current.json').success( (data) ->
    $scope.user = data
    $scope.orig_user = {
      first_name : $scope.user.first_name,
      last_name : $scope.user.last_name
    }
    console.log('User'+ $scope.user.first_name)

  $http.get('/profile/current.json').success( (data) ->
      $scope.profile = data.profile
      $scope.orig_profile = {
        title : $scope.profile.title,
        employee_id : $scope.profile.employee_id
      }
      console.log('Successfully loaded profile')
      #console.log('Profile'+ JSON.stringify($scope.profile, null, 4))
    ).error( ->
      console.log('Error loading profile')
    )
  ).error( ->
    console.log('Error loading user')
  )

  loadData()

  $scope.updateProfile = (user, profile) ->
    updated_u = {
      first_name : user.first_name,
      last_name : user.last_name
    }
    console.log('Updating:' + updated_u.first_name+','+updated_u.last_name)
    # POST and send a request
    $http.put('/employees/' + user.id + '.json', updated_u).success( (data) ->
      console.log('Successfully updated user')
      $scope.orig_user = {
        first_name : user.first_name,
        last_name : user.last_name
      }

      # switch to non-editing mode
    ).error( ->
      console.error('Failed to update user')
    )

    console.log('Creating/Updating profile:' + $scope.profile.title)
    new_p = {
      title : $scope.profile.title,
      employee_id : $scope.profile.employee_id,
      user_id : user.id
    }
    # POST and send a request
    $http.post('/profile.json', new_p).success( (data) ->
      console.log('Successfully created profile')
      $scope.orig_profile = {
        title : profile.title,
        employee_id : profile.employee_id
      }
      # use new user ID
    ).error( ->
      console.error('Failed to createe/update profile')
    )


  $scope.removeProfile = (user,index) ->
    $http.delete('/users/user/' + user.id + '.json', null).success( (data) ->
      console.log('Successfully removed user')
    ).error( ->
      console.error('Failed to remove user')
    )

  $scope.cancelEditingProfile = () ->
    console.log('cancel editing')

    elem = document.getElementById("mainform").elements
    i = 0

    while i < elem.length
      if elem[i].name == 'first_name'
        elem[i].value = $scope.orig_user.first_name

      if elem[i].name == 'last_name'
        elem[i].value = $scope.orig_user.last_name

      if elem[i].name == 'title'
        elem[i].value = $scope.orig_profile.title

      if elem[i].name == 'employee_id'
        elem[i].value = $scope.orig_profile.employee_id

      i++

@ProfileCtrl.$inject = ['$scope', '$http']
