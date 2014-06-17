EdgeRocket = angular.module('EdgeRocket', ['ui.bootstrap'])

#EdgeRocket.config(["$httpProvider", (provider) ->
#provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
#])

@ProfileCtrl = ($scope, $http) ->
  $scope.user = null
  $scope.profile = null

  loadData =  ->
  $http.get('/users/current.json').success( (data) ->
    $scope.user = data

    if $scope.user.best_role == 'admin' ||  $scope.user.best_role == 'SA'
      $scope.user.admin_role = true

    $http.get('/profile/current.json').success( (data) ->
      $scope.profile = data.profile
      console.log('Successfully loaded profile')
      console.log('Profile'+ $scope.profile.title)
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

@ProfileCtrl.$inject = ['$scope', '$http']
