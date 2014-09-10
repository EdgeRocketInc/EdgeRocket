EdgeRocket = angular.module("EdgeRocket", ['ui.bootstrap', 'ngResource', 'ngGrid'])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@SystemSurveysCtrl = ($scope, $http, $resource, $modal) ->

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
          controller: SurveyModalCtrl
          size: 'lg'
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

@SystemSurveysCtrl.$inject = ['$scope', '$http', '$resource', '$modal']

# --- controller for modal window
@SurveyModalCtrl = ($scope, $modalInstance, $window, $http) ->
  console.log('modal ctrl')
  $scope.surveySaved = false # true when sruvey has been saved
  $scope.skills = [
    [ { id: 'marketing', name: 'Marketing' }
        { id: 'social_media', name: 'Social Media Marketing' }
        { id: 'seo', name: 'SEO/SEM' }
        # { id: 'copywriting', name: 'Copywriting' }
        { id: 'cs', name: 'Computer Science' }
        { id: 'computer_networking', name: 'Computer Networking' }
        # { id: 'data_centers', name: 'Data Centers' }
        { id: 'data_security', name: 'Data Security' }
        { id: 'data_science', name: 'Data Science' }
        { id: 'web_dev', name: 'Web Development' } ]
    [ { id: 'dbms', name: 'Databases' }
        { id: 'soft_dev_methods', name: 'Software Dev. Methodologies' }# name: 'Software Development Methodologies' }
        { id: 'management', name: 'Management' }
        { id: 'leadership', name: 'Leadership' }
        { id: 'communications', name: 'Communications' }
        { id: 'sales', name: 'Sales' }
        { id: 'hiring', name: 'Hiring & Interviewing' }
        { id: 'presentations', name: 'Effective Presentations' } ]
    [ { id: 'negotiation', name: 'Negotiation' }
        { id: 'strategy', name: 'Strategy' }
        { id: 'ops', name: 'Operations' }
        { id: 'pmp', name: 'Project Management' }
        # { id: 'accounting', name: 'Accounting' }
        { id: 'finance', name: 'Finance' }
        # { id: 'spreadsheets', name: 'Spreadsheets' }
        { id: 'ux', name: 'UX/UI' }
        { id: 'graphic_design', name: 'Graphic Design' }
        # { id: 'video_dev', name: 'Video Development' }
        { id: 'product_management', name: 'Product Management' } ]
  ]
  $scope.otherSkill = null

  $scope.done = () ->
    data = { skills: [] }
    for skillset in @skills
      for skill in skillset
        if skill.checked == true
          #console.log('skill ' + skill.id)
          data.skills.push( { id: skill.id } )
    if @otherSkill != null
      data.skills.push( {other_skill: @otherSkill} )
    # save right here
    # Create data object to POST and send a request
    $http.post('/users/preferences.json', data).success( (data) ->
      console.log('Successfully set preferences')
      $scope.surveySaved = true
    ).error( ->
      console.error('Failed to set preferences')
    )

  $scope.cancel = ->
    $modalInstance.dismiss('cancel')

