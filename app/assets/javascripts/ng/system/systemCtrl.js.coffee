EdgeRocket = angular.module("EdgeRocket", ["ui.bootstrap", "ngResource", 'ngGrid'])
EdgeRocket.config [
  "$httpProvider"
  "$resourceProvider"
  (provider) ->
    provider.defaults.stripTrailingSlashes = false
    provider.defaults.headers.common["X-CSRF-Token"] = $("meta[name=csrf-token]").attr("content")
]

EdgeRocket.factory 'surveysFactory', ($resource) ->
  return $resource('/system/surveys.json')

@SystemSurveysCtrl = ($scope, $http, surveysFactory) ->

    $scope.surveys = surveysFactory.query()

    $scope.gridOptions = {
      data: 'surveys',
      columnDefs: [{field: 'processed', displayName: 'Processed'}, {field: 'created_at', displayName: 'Date Submitted'}]
    }
