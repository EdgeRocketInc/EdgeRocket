@EditPasswordCtrl = ($scope, $http, $window, $log) ->

  $scope.statusDone = false
  $scope.serverError = null
  $scope.user  = null
  $scope.newUser = {
    id : null,
    current_password : '',
    new_password : '', 
    new_password2 : '',
  }

  $scope.clearEditForm = ->
    $scope.newUser.id = null
    $scope.newUser.current_password = ''
    $scope.newUser.new_password = ''
    $scope.newUser.new_password2 = ''

  # load current use to use ID and dislay name
  loadCurrentUser =  ->
    $http.get('/users/current.json').success( (data) ->
      $scope.newUser.id = data.id
      $scope.user = data
      console.log('Successfully loaded user')
    ).error( ->
      console.log('Error loading user')
    )

  loadCurrentUser()

  # Update the user in DB and UI
  $scope.updateUserPassword = () ->
    # convert display structure to API payload
    updated_u = $scope.newUser
    console.log('Changing password for user id: ' + updated_u.id)
    # POST and send a request
    $http.put('/employees/' + updated_u.id + '/password.json', updated_u).success( (data) ->
      console.log('Successfully changed password')
      $scope.clearEditForm()
      $scope.statusDone = true
      $scope.serverError = null
    ).error( ->
      console.error('Failed to change password')
      $scope.serverError = 'Failed to change password. Make sure to provide valid current password.'
    )

  $scope.cancel = () ->
    console.log('skip password update')
    $window.location.href = "/user_home"


@EditPasswordCtrl.$inject = ['$scope', '$http', '$window', '$log']
