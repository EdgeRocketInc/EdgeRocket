EdgeRocket = angular.module('EdgeRocket', ['ui.bootstrap'])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@ProfileCtrl = ($scope, $http) ->
  $scope.user = null
  $scope.profile = null
  $scope.statusDone = false

  loadData =  ->
  $http.get('/users/current.json').success( (data) ->
    $scope.user = data
    console.log('User'+ $scope.user.first_name)

  $http.get('/profile/current.json').success( (data) ->
      $scope.profile = data.profile
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
    console.log('Updating:' + updated_u.first_name + ',' + updated_u.last_name)
    # POST and send a request
    $http.put('/employees/' + user.id + '.json', updated_u).success( (data) ->
      console.log('Successfully updated user')
      # POST and send a request
      $http.post('/profile.json', new_p).success( (data) ->
        console.log('Successfully created profile')
        $scope.statusDone = true
      ).error( ->
        console.error('Failed to createe/update profile')
      )
    ).error( ->
      console.error('Failed to update user')
    )

    console.log('Creating/Updating profile:' + $scope.profile.title)
    new_p = {
      title : $scope.profile.title,
      employee_identifier : $scope.profile.employee_identifier,
      user_id : user.id
    }

  $scope.removeProfile = (user,index) ->
    $http.delete('/users/user/' + user.id + '.json', null).success( (data) ->
      console.log('Successfully removed user')
    ).error( ->
      console.error('Failed to remove user')
    )

@ProfileCtrl.$inject = ['$scope', '$http']
