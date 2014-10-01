EdgeRocket = angular.module("EdgeRocket", ['ui.bootstrap', 'ngResource', 'ngGrid'])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@SystemCompaniesCtrl = ($scope, $http, $resource) ->

  $scope.getCompanies = ->
    $scope.companiesQuery = $resource('/system/companies.json').query()

  $scope.getCompanies()

#  $scope.approve = (id) ->
#    $http({ method: 'POST', url: '/system/pending_users/create_users', data: id:id}).success ->
#      $scope.getPendingUsers()
#      $('.pending-flash').empty().show().append("<div class='alert alert-success'><button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button><h4>The pending user has been approved.</h4></div>")
#      $('.pending-flash').fadeOut(4000)

  $scope.accountsTable = {
    data: 'companiesQuery',
    columnDefs: [{field: 'companyName', displayName: 'Company Name'}, {field: 'overview', displayName: 'Overview'}, {field: 'options', displayName: 'Options'}, {field: 'date', displayName: 'Date'}, {field: 'accountType', displayName: 'Account Type'}, { field : 'domain', displayName : 'Domain', width : '15%', minWidth : '80', cellTemplate: 'cellActionsProcess.html', sortable: false }]
    enableRowSelection: false
  }

@SystemCompaniesCtrl.$inject = ['$scope','$http', '$resource']
