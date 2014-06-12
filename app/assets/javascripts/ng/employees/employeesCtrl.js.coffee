EdgeRocket = angular.module('EdgeRocket', ['ui.bootstrap'])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@EmployeesCtrl = ($scope, $http, $modal, $log) ->

  $scope.users = []
  $scope.newUser = { 
    email : '', 
    first_name : '',
    last_name : '',
    password : '', 
    password2 : '',
    reset_required_class : 'unchecked'
  }
  $scope.editModeIndex = -1 # will set to $index when editing a user in place
  $scope.userMode = true
  $scope.currentUser = null 

  loadUsers =  ->
    $http.get('/employees.json').success( (data) ->
      $scope.users = data
      console.log('Successfully loaded users')
    ).error( ->
      console.log('Error loading users')
    )

  loadUsers()

  $scope.createUser = () ->
    console.log('Creating:' + $scope.newUser.email)
    new_u = { 
      id : null, 
      email : $scope.newUser.email,
      first_name : $scope.newUser.first_name,
      last_name : $scope.newUser.last_name,
      password : $scope.newUser.password,
      reset_required : if $scope.newUser.reset_required_class == 'check' then true else false
    }
    # POST and send a request
    $http.post('/employees.json', new_u).success( (data) ->
      console.log('Successfully created user')
      # use new user ID
      new_u.id = data.id
      $scope.users.push(new_u)
      $scope.newUser.email = ''
      $scope.newUser.first_name = ''
      $scope.newUser.last_name = ''
      $scope.newUser.password = ''
      $scope.newUser.password2 = ''
      $scope.newUser.reset_required_class = 'unchecked'
    ).error( ->
      console.error('Failed to add user')
    )

  $scope.updateUser = (user,index) ->
    updated_u = { 
      email : user.email,
      first_name : user.first_name,
      last_name : user.last_name
    }
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

  $scope.toggleResetRequired = () ->
    if $scope.newUser.reset_required_class == 'check'
      $scope.newUser.reset_required_class = 'unchecked'
    else
      $scope.newUser.reset_required_class = 'check'


  $scope.changeUserSecurity = () ->
    modalInstance = $modal.open({
      templateUrl: 'userSecurity.html',
      controller: SecurityModalCtrl
    })

    modalInstance.result.then () ->
      console.log('result ' )
      # Create data object to POST and send a request
      data =
        password: '1234'
      $http.post('/employees/security.json', data).success( (data) ->
        console.log('Successfully set preferences')
      ).error( ->
        console.error('Failed to set preferences')
      )    

# controller for modal window
@SecurityModalCtrl = ($scope, $modalInstance, $window, $http) ->
  console.log('modal ctrl')
  $scope.selected = ''

  $scope.save = () ->
    console.log('fields = ')
    $modalInstance.close()

  $scope.cancel = ->
    $modalInstance.dismiss('cancel')

@SecurityModalCtrl.$inject = ['$scope', '$modalInstance', '$window', '$http'] 
@EmployeesCtrl.$inject = ['$scope', '$http', '$modal', '$log']
