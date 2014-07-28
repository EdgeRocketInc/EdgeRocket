EdgeRocket = angular.module('EdgeRocket', ['ui.bootstrap', 'ngGrid'])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@EmployeesCtrl = ($scope, $http, $modal, $log) ->

  MIN_PASS_LEN = 8

  $scope.userRoles = [
    { value : 'user', name : 'Standard User' }
    { value : 'Admin', name : 'Administrator' }
    { value : 'SA', name : 'Super Administrator' }
  ]

  $scope.users = []
  $scope.newUser = {
    # will be filled out by clearEditForm call
  }
  $scope.validation = { message : null }


  # This method is called when a grid is selected
  $scope.beforeSelect = (rowItem) ->
    false # disable select

  # will set to index when editing a user in place
  # the index value is not really used at this time; it works as long as it is >=0 
  $scope.uiMode = { adding : false, editIndex : -1 }
  $scope.currentUser = null 
  $scope.gridOptions = { 
    data : 'users',
    multiSelect : false,
    beforeSelectionChange : $scope.beforeSelect
    columnDefs : [
      { field : 'email', displayName:'Email'}, 
      { field : 'first_name', displayName : 'First Name', cellTemplate: 'cellFirstName.html' },
      { field : 'last_name', displayName : 'Last Name', cellTemplate: 'cellLastName.html' },
      { field : 'reset_required', displayName : 'Warnings', width : '8%', minWidth : '80', cellTemplate: 'cellFlags.html' },
      { field : 'id', displayName : 'Edit/Delete', width : '8%', minWidth : '80', cellTemplate: 'cellActions.html' }
    ]
  }  

  clearEditForm = ->
    $scope.newUser.id = null
    $scope.newUser.email = ''
    $scope.newUser.first_name = ''
    $scope.newUser.last_name = ''
    $scope.newUser.password = ''
    $scope.newUser.password2 = ''
    $scope.newUser.reset_required_class = 'unchecked'
    $scope.newUser.theRole = null
    $scope.validation.message = null

  loadUsers =  ->
    $http.get('/employees.json').success( (data) ->
      $scope.users = data.users
      console.log('Successfully loaded users')
    ).error( ->
      console.log('Error loading users')
    )

  clearEditForm()
  loadUsers()

  $scope.addUser = () ->
    console.log('switching to adding mode')
    $scope.uiMode = { adding : true, editIndex : -1 }
    clearEditForm()

  # Create new user in DB and add to UI
  $scope.createUser = () ->
    console.log('Creating:' + $scope.newUser.email)
    if $scope.newUser.password == null || $scope.newUser.password.length < MIN_PASS_LEN
      $scope.validation = { message: "Password must have 8 or more characters" }
    else if $scope.newUser.password != $scope.newUser.password2
      $scope.validation = { message: "Password confirmation does not match" }
    else
      # convert display structure to API payload
      new_u = { 
        id : null, 
        email : $scope.newUser.email,
        first_name : $scope.newUser.first_name,
        last_name : $scope.newUser.last_name,
        password : $scope.newUser.password,
        reset_required : if $scope.newUser.reset_required_class == 'check' then true else false
        best_role : if $scope.newUser.theRole then $scope.newUser.theRole.value else null
      }
      # POST and send a request
      $http.post('/employees.json', new_u).success( (data) ->
        console.log('Successfully created user')
        # use new user ID
        new_u.id = data.id
        $scope.users.push(new_u)
        $scope.uiMode = { adding : false, editIndex : -1 }
        clearEditForm()
      ).error( ->
        console.error('Failed to add user')
      )

  # Update the user in DB and UI
  $scope.updateUser = () ->
    if $scope.newUser.password != $scope.newUser.password2
      $scope.validation = { message: "Password confirmation does not match" }
    else
      # convert display structure to API payload
      updated_u = { 
        id : $scope.newUser.id, 
        email : $scope.newUser.email,
        first_name : $scope.newUser.first_name,
        last_name : $scope.newUser.last_name,
        password : $scope.newUser.password,
        reset_required : if $scope.newUser.reset_required_class == 'check' then true else false
        best_role : if $scope.newUser.theRole then $scope.newUser.theRole.value else null
      }
      console.log('Updating: ' + updated_u.email)
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
            u.best_role = updated_u.best_role
            console.log('editing index=' + $scope.uiMode.editIndex + ' email:' + u.email)
            break
        # switch to non-editing mode
        $scope.uiMode = { adding : false, editIndex : -1 }
        clearEditForm()
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
    $scope.validation.message = null
    # find the user record and switch to edit more
    for u,i in $scope.users
      if u.id == user_id
        $scope.uiMode = { adding : false, editIndex : i }
        $scope.newUser.id = user_id
        $scope.newUser.email = u.email
        $scope.newUser.first_name = u.first_name
        $scope.newUser.last_name = u.last_name
        $scope.newUser.password = ''
        $scope.newUser.password2 = ''
        $scope.newUser.reset_required_class = if u.reset_required then 'check' else 'unchecked'

        # select the user role
        $scope.newUser.theRole = null
        for ur in $scope.userRoles
          if u.best_role != null && u.best_role.toLowerCase() == ur.value.toLowerCase()
            $scope.newUser.theRole = ur
            break

        console.log('editing index=' + $scope.uiMode.editIndex + ' email:' + u.email)
        break

  $scope.cancelEditingUser = () ->
    console.log('cancel editing')
    $scope.uiMode = { adding : false, editIndex : -1 }
    clearEditForm()

  $scope.toggleResetRequired = () ->
    if $scope.newUser.reset_required_class == 'check'
      $scope.newUser.reset_required_class = 'unchecked'
    else
      $scope.newUser.reset_required_class = 'check'

@EmployeesCtrl.$inject = ['$scope', '$http', '$modal', '$log']
