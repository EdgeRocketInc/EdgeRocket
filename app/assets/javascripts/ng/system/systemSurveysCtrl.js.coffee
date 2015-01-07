@SystemSurveysCtrl = ($scope, $http, $resource, $modal) ->

#    $scope.skills = all_prefs

    # not a real factory, but is simple to work around Heroku injections
    surveysFactory = $resource('/system/surveys.json')

    getSurveys = ->
      surveys = surveysFactory.get ->
        $scope.unprocessedSurveys = surveys.unprocessed
        $scope.processedSurveys = surveys.processed

    getSurveys()

    $scope.summonModal = (id) ->
      $http({ method: 'GET', url: '/system/one_survey', params: id:id}).success (data) ->
        $scope.userPrefs = data
        $modal.open({
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

  $scope.selectedPrefs = userPrefs.skills
  $scope.recommendedProducts = userPrefs.recommendations

  $http.get('/surveys/skills.json').success( (data) ->
    merged_skills = []
    merged_skills = merged_skills.concat.apply(merged_skills, data.skills)
    $scope.skills = merged_skills

    if $scope.selectedPrefs != null
      for preference in $scope.selectedPrefs
        if preference.other_skill
          preference.name = "Other Skill"
        else
          for skill in $scope.skills
            if preference.id == skill.key_name
              preference.name = skill.name

    console.log('Successfully loaded skills')
  ).error( ->
    console.log('Error loading skills')
  )

  $scope.cancel = ->
    $modalInstance.dismiss('cancel')




@SystemSurveysCtrl.$inject = ['$scope', '$http', '$resource', '$modal']
@SurveyModalCtrl.$inject = ['$scope', '$modalInstance', '$window', '$http', 'userPrefs']

