EdgeRocket = angular.module('EdgeRocket', ['ui.bootstrap'])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@EmployeesCtrl = ($scope, $http, $modal, $log) ->

  $scope.newUser = { email : '' }
  $scope.editModeIndex = -1 # will set to $index when editing a user in place
  $scope.userMode = true
  $scope.currentUser = null # will set to the user for managing courses

  loadUsers =  ->
    $http.get('/employees.json').success( (data) ->
      $scope.users = data
      console.log('Successfully loaded users')
    ).error( ->
      console.log('Error loading users')
    )

  loadUsers()

  $scope.createUser = ()->
    console.log('Creating:' + $scope.newUser.email)
    new_u = { id : null, email : $scope.newUser.email }
    # POST and send a request
    $http.post('/employees.json', new_u).success( (data) ->
      console.log('Successfully created user')
      # use new user ID
      new_u.id = data.id
      $scope.users.push(new_u)
      $scope.newUser.email = ''
    ).error( ->
      console.error('Failed to add user')
    )

  $scope.updateUser = (user,index) ->
    updated_u = { email : user.email }
    console.log('Updating:' + updated_u.email)
    # POST and send a request
    $http.put('/employees/' + user.id + '.json', updated_u).success( (data) ->
      console.log('Successfully updated user')
      # switch to non-editing mode
      $scope.editModeIndex = -1
    ).error( ->
      console.error('Failed to update user')
    )
  $scope.removeUser = (user,index) ->
    $http.delete('/employees/' + user.id + '.json', null).success( (data) ->
      console.log('Successfully removed user')
      $scope.users.splice(index,1)
    ).error( ->
      console.error('Failed to remove user')
    )

  $scope.editUser = (user,index) ->
    $scope.editModeIndex = index
    console.log('editing index=' + $scope.editModeIndex + ' email:' + user.email)

  $scope.cancelEditingUser = () ->
    console.log('cancel editing')
    $scope.editModeIndex = -1
  
@EmployeesCtrl.$inject = ['$scope', '$http', '$modal', '$log']
