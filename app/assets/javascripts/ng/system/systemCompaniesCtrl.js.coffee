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
    return false


  $scope.disableCompany = (id) ->
    $http({ method: 'POST', url: '/system/companies/disable_company', data:
      id: id}).success ->
        $scope.getCompanies()
        $('.pending-flash').empty().show().append("<div class='alert alert-success'><button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button><h4>Company has been disabled.</h4></div>")
        $('.pending-flash').fadeOut(4000)
    return false


  $scope.checkIfDisabled = (columnValue) ->
    if columnValue == true
      "glyphicon glyphicon-ban-circle glyph-big red"
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

  $scope.uiMode = { editIndex: -1 }

  $scope.getCompany = (id) ->
    for c, i in $scope.companiesQuery
      if c.id == id
        return c

  $scope.editCompany = (company_id) ->
    # find the user record and switch to edit more
    company = $scope.getCompany(company_id)
    $scope.uiMode = { editIndex: company.id }
    $scope.editCompany.id = company.id
    $scope.editCompany.companyName = company.companyName
    $scope.editCompany.domain = company.domain
    $scope.editCompany.options = company.options
    $scope.editCompany.type = company.accountType
    $scope.editCompany.overview = company.overview

  $scope.clearEditForm = ->
    $scope.editCompany.id = ''
    $scope.editCompany.companyName = ''
    $scope.editCompany.domain = ''
    $scope.editCompany.options = ''
    $scope.editCompany.type = ''
    $scope.editCompany.overview = ''

  $scope.updateCompany = () ->
    # convert display structure to API payload
    company = {company:
        {
          company_name: $scope.editCompany.companyName
          domain: $scope.editCompany.domain
          options: $scope.editCompany.options
          account_type: $scope.editCompany.type
          overview: $scope.editCompany.overview
        }
      }

    if $scope.validateCompanyInfo(company)

    # POST and send a request
      $http.put('/system/company/' + $scope.editCompany.id, company).success((data) ->
        $('.pending-flash').empty().show().append("<div class='alert alert-success'><button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button><h4>Company has been updated.</h4></div>")
        $('.pending-flash').fadeOut(4000)
        # update companies
        $scope.getCompanies()
        # switch to non-editing mode
        $scope.uiMode = { editIndex: -1 }
        $scope.clearEditForm()
      ).error( ->
        $('.pending-flash').empty().show().append("<div class='alert alert-danger'><button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button><h4>Company could not be updated.</h4></div>")
        $('.pending-flash').fadeOut(4000)
      )


  $scope.cancelEditingCompany = () ->
    $scope.uiMode = { editIndex: -1 }
    $scope.clearEditForm()

  $scope.validateCompanyInfo = (company) ->
    if company.company.company_name == '' || company.company.account_type == '' || company.company.options == '' || $scope.validateJson(company.company.options)
      $('.pending-flash').empty().show().append("<div class='alert alert-danger'><button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button><h4>Company could not be updated.</h4></div>")
      $('.pending-flash').fadeOut(4000)
      return false
    else
      return true

  $scope.validateJson = (options) ->
    try
      JSON.parse(options)
    catch e
      return true
    return false


@SystemCompaniesCtrl.$inject = ['$scope', '$http', '$resource']
