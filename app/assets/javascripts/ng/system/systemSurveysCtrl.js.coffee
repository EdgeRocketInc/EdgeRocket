EdgeRocket = angular.module("EdgeRocket", ['ui.bootstrap', 'ngResource', 'ngGrid'])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@SystemSurveysCtrl = ($scope, $http, $resource, $modal) ->

#    $scope.skills = all_prefs
    # not a real factory, but is simple to work around Heroku injections
    surveysFactory = $resource('/system/surveys.json')

    getSurveys = ->
      $scope.surveys = surveysFactory.get ->
        $scope.unprocessedSurveys = $scope.surveys.unprocessed
        $scope.processedSurveys = $scope.surveys.processed

    getSurveys()

    $scope.summonModal = (id) ->
      $http({ method: 'GET', url: '/system/one_survey', params: id:id}).success (data) ->
        $scope.userPrefs = data
        modalInstance = $modal.open({
          templateUrl: 'userSurvey.html',
          controller: SurveyModalCtrl,
          size: 'lg',
          resolve: {
            userPrefs: ->
              return $scope.userPrefs
          }
        })

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


# --- controller for modal window
@SurveyModalCtrl = ($scope, $modalInstance, $window, $http, userPrefs) ->

  findOther = (skills) ->
    skills.forEach (skill) ->
      if skill.other_skill
        $scope.otherSkill = skill.other_skill

  $http.get('/surveys/skills.json').success( (data) ->
    $scope.skills = data.skills
    console.log('Successfully loaded skills')
  ).error( ->
    console.log('Error loading skills')
  )
#  $scope.skills = all_prefs
  $scope.userPrefs = userPrefs.skills
  if $scope.userPrefs
    findOther(userPrefs.skills)

  $scope.findChecked = (thing) ->
    if $scope.userPrefs
      $scope.userPrefs.forEach (pref) ->
        if pref.id == thing.key_name
          thing.checked = true

  $scope.cancel = ->
    $modalInstance.dismiss('cancel')
    $scope.skills.forEach (array) ->
      array.forEach (skill) ->
        skill.checked = false



@SystemSurveysCtrl.$inject = ['$scope', '$http', '$resource', '$modal']
@SurveyModalCtrl.$inject = ['$scope', '$modalInstance', '$window', '$http', 'userPrefs']