@SystemPendingUsersCtrl = ($scope, $http, $resource) ->

  $scope.getPendingUsers = ->
    $scope.pendingUsersQuery = $resource('/system/pending_users.json').query()

  $scope.getPendingUsers()

  $scope.approve = (id) ->
    $http({ method: 'POST', url: '/system/pending_users/create_users', data: id:id}).success ->
      $scope.getPendingUsers()
      $('.pending-flash').empty().show().append("<div class='alert alert-success'><button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button><h4>The pending user has been approved.</h4></div>")
      $('.pending-flash').fadeOut(4000)

  $scope.pendingUsersTable = {
    data: 'pendingUsersQuery',
    columnDefs: [{field: 'type', displayName: 'Type'}, {field: 'companyName', displayName: 'Company Name'}, {field: 'fullName', displayName: 'Last Name, First Name'}, {field: 'email', displayName: 'Email'}, {field: 'date', displayName: 'Date'}, { field : 'id', displayName : 'Approve/Reject', width : '15%', minWidth : '80', cellTemplate: 'cellActionsProcess.html', sortable: false }]
    enableRowSelection: false
  }

@SystemPendingUsersCtrl.$inject = ['$scope','$http', '$resource']
