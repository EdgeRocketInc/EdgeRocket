EdgeRocket = angular.module("EdgeRocket", ['ui.bootstrap', 'ngResource', 'ngGrid'])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@SystemPendingUsersCtrl = ($scope, $http, $resource) ->
  $scope.pendingUsersQuery = $resource('/system/pending_users.json').query()

  $scope.approve = (id) ->
    console.log("cool" + id)
#    $http({ method: 'POST', url: })

  $scope.pendingUsersTable = {
    data: 'pendingUsersQuery',
    columnDefs: [{field: 'type', displayName: 'Type'}, {field: 'companyName', displayName: 'Company Name'}, {field: 'fullName', displayName: 'Last Name, First Name'}, {field: 'email', displayName: 'Email'}, {field: 'date', displayName: 'Date'}, { field : 'id', displayName : 'Approve/Reject', width : '15%', minWidth : '80', cellTemplate: 'cellActionsProcess.html', sortable: false }]
    enableRowSelection: false
  }

@SystemPendingUsersCtrl.$inject = ['$scope','$http', '$resource']
