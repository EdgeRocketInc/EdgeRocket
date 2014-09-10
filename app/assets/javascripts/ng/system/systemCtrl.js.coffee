EdgeRocket = angular.module("EdgeRocket", ["ui.bootstrap", "ngResource", 'ngGrid'])
EdgeRocket.config [
  "$httpProvider"
  "$resourceProvider"
  (provider) ->
    provider.defaults.stripTrailingSlashes = false
    provider.defaults.headers.common["X-CSRF-Token"] = $("meta[name=csrf-token]").attr("content")
    provider.defaults.headers.patch = {'Content-Type': 'application/json;charset=utf-8'}
]

EdgeRocket.factory 'surveysFactory', ($resource) ->
  return $resource('/system/surveys.json')

@SystemSurveysCtrl = ($scope, $http, surveysFactory) ->

    getSurveys = ->
      $scope.surveys = surveysFactory.get ->
        $scope.unprocessedSurveys = $scope.surveys.unprocessed
        $scope.processedSurveys = $scope.surveys.processed

    getSurveys()

    $scope.process = (id) ->
      $http({ method: 'PATCH', url: '/system/surveys', data: id:id}).success ->
        getSurveys()

    $scope.undoProcess = (id) ->
      $http({ method: 'PATCH', url: '/system/surveys/undo', data: id:id}).success ->
        getSurveys()


    $scope.unprocessedSurveysTable = {
      data: 'unprocessedSurveys',
      columnDefs: [{field: 'email', displayName: 'Users Email'}, {field: 'date', displayName: 'Date Completed'}, {field: 'fullName', displayName: 'Name'}, { field : 'id', displayName : 'Process/Details', width : '15%', minWidth : '80', cellTemplate: 'cellActionsProcess.html', sortable: false }],
      enableRowSelection: false
    }
    $scope.processedSurveysTable = {
      data: 'processedSurveys',
      columnDefs: [{field: 'email', displayName: 'Users Email'}, {field: 'date', displayName: 'Date Completed'}, {field: 'fullName', displayName: 'Name'}, { field : 'id', displayName : 'Undo/Details', width : '15%', minWidth : '80', cellTemplate: 'cellActionsUnprocess.html', sortable: false}],
      enableRowSelection: false
    }

@SystemSurveysCtrl.$inject = ['$scope', '$http', 'surveysFactory']
