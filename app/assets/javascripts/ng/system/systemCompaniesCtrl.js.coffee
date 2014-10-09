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
    $('.pending-flash').empty().show().append("<div class='alert alert-success'><button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button><h4>Company has been activated.</h4></div>")
    $('.pending-flash').fadeOut(4000)
    $scope.companiesQuery = $resource('/system/companies.json').query()
    return false;

  $scope.disableCompany = (id) ->
    $http({ method: 'POST', url: '/system/companies/disable_company', data:
      id: id}).success ->
        $scope.getCompanies()
    $('.pending-flash').empty().show().append("<div class='alert alert-success'><button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button><h4>Company has been disabled.</h4></div>")
    $('.pending-flash').fadeOut(4000)
    $scope.companiesQuery = $resource('/system/companies.json').query()
    return false;

  $scope.checkIfDisabled = (columnValue) ->
    if columnValue == true
      "glyphicon glyphicon-ban-circle glyph-big red"
    else
      ""

  $scope.$watch($scope.companiesQuery, () ->
    $scope.accountsTable = {
      data: 'companiesQuery',
      columnDefs: [
        {field: 'companyName', displayName: 'Company Name'},
        {field: 'overview', displayName: 'Overview'},
        {field: 'options', displayName: 'Options'},
        {field: 'date', displayName: 'Date', groupable: false},
        {field: 'accountType', displayName: 'Account Type'},
        { field: 'domain', displayName: 'Domain'},
        {field: 'disabled', displayName: 'Disabled', cellTemplate: 'cellDisabled.html'},
        { field: 'id', displayName: 'Activate/Disable', width: '15%', minWidth: '80', cellTemplate: 'cellActions.html'}
      ]
        enableRowSelection: false
    })

  $scope.accountsTable = {
    data: 'companiesQuery',
    columnDefs: [
      {field: 'companyName', displayName: 'Company Name'},
      {field: 'overview', displayName: 'Overview'},
      {field: 'options', displayName: 'Options'},
      {field: 'date', displayName: 'Date', groupable: false},
      {field: 'accountType', displayName: 'Account Type'},
      { field: 'domain', displayName: 'Domain'},
      {field: 'disabled', displayName: 'Disabled', cellTemplate: 'cellDisabled.html'},
      { field: 'id', displayName: 'Activate/Disable', width: '15%', minWidth: '80', cellTemplate: 'cellActions.html'}
    ]
    enableRowSelection: false
  }

  $scope.uiMode = { adding: false, editIndex: -1 }

  $scope.editCompany = () ->
    $scope.validation.message = null
    # find the user record and switch to edit more
    #    for u,i in $scope.companies
    #      if u.id == user_id
    $scope.uiMode = { adding: false, editIndex: 1 }
#        $scope.newUser.id = user_id
#        $scope.newUser.email = u.email
#        $scope.newUser.first_name = u.first_name
#        $scope.newUser.last_name = u.last_name
#        $scope.newUser.password = ''
#        $scope.newUser.password2 = ''
#        $scope.newUser.reset_required_class = if u.reset_required then 'check' else 'unchecked'

# select the user role
#        $scope.newUser.theRole = null
#        for ur in $scope.userRoles
#          if u.best_role != null && u.best_role.toLowerCase() == ur.value.toLowerCase()
#            $scope.newUser.theRole = ur
#            break


@SystemCompaniesCtrl.$inject = ['$scope', '$http', '$resource']
