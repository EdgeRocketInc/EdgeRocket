EdgeRocket = angular.module("EdgeRocket", ['ui.bootstrap', 'ngResource', 'ngGrid'])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])


@SystemPendingUsersCtrl = ($scope, $http, $resource) ->
  pendingUsersFactory = $resource('/system/pending_users.json')
  $scope.pendingUsers = pendingUsersFactory.query()
  $scope.pendingUsersTable = {
    data: 'pendingUsers',
    columnDefs: [{field: 'type', displayName: 'Type'},{field: 'companyName', displayName: 'Company Name'},{field: 'fullName', displayName: 'Last Name, First Name'}, {field: 'email', displayName: 'Email'}, {field: 'date', displayName: 'Date'},  { field : 'id', displayName : 'Approve/Reject', width : '15%', minWidth : '80', cellTemplate: 'cellActionsProcess.html', sortable: false }],
    enableRowSelection: false
  }