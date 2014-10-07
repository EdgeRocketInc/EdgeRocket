EdgeRocket = angular.module("EdgeRocket", ['ui.bootstrap', 'ngResource', 'ngGrid'])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@SystemCompaniesCtrl = ($scope, $http, $resource) ->
  $scope.getCompanies = ->
    $scope.companiesQuery = $resource('/system/companies.json').query()

  $scope.getCompanies()

  $scope.activateCompany = (id) ->
    $http({ method: 'POST', url: '/system/companies/activate_company', data:
      id: id}).success ->
    $scope.getCompanies()
    $('.pending-flash').empty().show().append("<div class='alert alert-success'><button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button><h4>Company has been disabled.</h4></div>")
    $('.pending-flash').fadeOut(4000)

  $scope.disableCompany = (id) ->
    $http({ method: 'POST', url: '/system/companies/disable_company', data:
      id: id}).success ->
    $scope.getCompanies()
    $('.pending-flash').empty().show().append("<div class='alert alert-success'><button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button><h4>Company has been disabled.</h4></div>")
    $('.pending-flash').fadeOut(4000)

  $scope.checkIfDisabled = (company) ->
    if row.getProperty(col.field) == true
      "glyphicon glyphicon-trash glyph-big glyph-action red"
    else
      ""

  $scope.accountsTable = {
    data: 'companiesQuery',
    columnDefs: [
      {field: 'companyName', displayName: 'Company Name'},
      {field: 'overview', displayName: 'Overview'},
      {field: 'options', displayName: 'Options'},
      {field: 'date', displayName: 'Date'},
      {field: 'accountType', displayName: 'Account Type'},
      { field: 'domain', displayName: 'Domain'},
      {field: 'disabled', displayName: 'Disabled', cellTemplate: 'cellDisabled.html'},
      { field: 'id', displayName: 'Activate/Disable', width: '15%', minWidth: '80', cellTemplate: 'cellActions.html'}
    ]
    enableRowSelection: false
  }

@SystemCompaniesCtrl.$inject = ['$scope', '$http', '$resource']
