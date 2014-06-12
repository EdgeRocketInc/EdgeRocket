EdgeRocket = angular.module('EdgeRocket', ['ui.bootstrap', 'ngGrid'])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@EmployeesCtrl = ($scope, $http, $modal, $log) ->

  $scope.users = []
  $scope.newUser = {
    id : null,
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
  $scope.gridOptions = { 
    data : 'users',
    multiSelect : false,
    columnDefs : [
      { field : 'email', displayName:'Email'}, 
      { field : 'first_name', displayName : 'First Name', cellTemplate: 'cellFirstName.html' },
      { field : 'last_name', displayName : 'Last Name', cellTemplate: 'cellLastName.html' },
      { field : 'reset_required', displayName : 'Warnings', width : '8%', minWidth : '80', cellTemplate: 'cellFlags.html' },
      { field : 'id', displayName : 'Edit/Delete', width : '8%', minWidth : '80', cellTemplate: 'cellActions.html' }
    ]
  }  

  $scope.clearEditForm = ->
    $scope.newUser.email = ''
    $scope.newUser.first_name = ''
    $scope.newUser.last_name = ''
    $scope.newUser.password = ''
    $scope.newUser.password2 = ''
    $scope.newUser.reset_required_class = 'unchecked'

  loadUsers =  ->
    $http.get('/employees.json').success( (data) ->
      $scope.users = data
      console.log('Successfully loaded users')
    ).error( ->
      console.log('Error loading users')
    )

  loadUsers()

  # Create new user in DB and add to UI
  $scope.createUser = () ->
    console.log('Creating:' + $scope.newUser.email)
    # convert display structure to API payload
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
      $scope.clearEditForm()
    ).error( ->
      console.error('Failed to add user')
    )

  # Update the user in DB and UI
  $scope.updateUser = () ->
    # convert display structure to API payload
    updated_u = { 
      id : $scope.newUser.id, 
      email : $scope.newUser.email,
      first_name : $scope.newUser.first_name,
      last_name : $scope.newUser.last_name,
      password : $scope.newUser.password,
      reset_required : if $scope.newUser.reset_required_class == 'check' then true else false
    }
    console.log('Updating:' + updated_u.email)
    # POST and send a request
    $http.put('/employees/' + updated_u.id + '.json', updated_u).success( (data) ->
      console.log('Successfully updated user')
      # find the user record and update it
      for u,i in $scope.users
        if u.id == updated_u.id
          u.email = $scope.newUser.email
          u.first_name = $scope.newUser.first_name
          u.last_name = $scope.newUser.last_name
          u.reset_required = updated_u.reset_required
          console.log('editing index=' + $scope.editModeIndex + ' email:' + u.email)
          break
      # switch to non-editing mode
      $scope.editModeIndex = -1
      $scope.clearEditForm()
    ).error( ->
      console.error('Failed to update user')
    )

  # Remove user from DB and UI
  $scope.removeUser = (user_id) ->
    $http.delete('/employees/' + user_id + '.json', null).success( (data) ->
      console.log('Successfully removed user id ' + user_id)
      # find and remove record from internal array
      for u,i in $scope.users
        if u.id == user_id
          $scope.users.splice(i,1)
          break
    ).error( ->
      console.error('Failed to remove user')
    )

  # Switch to Edit mode
  $scope.editUser = (user_id) ->
    # find the user record and switch to edit more
    for u,i in $scope.users
      if u.id == user_id
        $scope.editModeIndex = i
        $scope.newUser.id = user_id
        $scope.newUser.email = u.email
        $scope.newUser.first_name = u.first_name
        $scope.newUser.last_name = u.last_name
        $scope.newUser.password = ''
        $scope.newUser.password2 = ''
        $scope.newUser.reset_required_class = if u.reset_required then 'check' else 'unchecked'
        console.log('editing index=' + $scope.editModeIndex + ' email:' + u.email)
        break

  $scope.cancelEditingUser = () ->
    console.log('cancel editing')
    $scope.editModeIndex = -1
    $scope.clearEditForm()

  $scope.toggleResetRequired = () ->
    if $scope.newUser.reset_required_class == 'check'
      $scope.newUser.reset_required_class = 'unchecked'
    else
      $scope.newUser.reset_required_class = 'check'

@EmployeesCtrl.$inject = ['$scope', '$http', '$modal', '$log']
