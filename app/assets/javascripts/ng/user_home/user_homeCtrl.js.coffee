EdgeRocket = angular.module('EdgeRocket', ['ui.bootstrap', 'ngSanitize'])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@IndexCtrl = ($scope, $http, $modal, $sce, $window) ->

  $scope.search = { text : '' }

  loadUser =  ->
    $http.get('/users/current.json').success( (data) ->
      $scope.user = data
      console.log('Successfully loaded user')
      # check if the option is enabled and it's the first login
      $scope.options_json = angular.fromJson($scope.user.account.options)
      # if sruvey flag is enabled for this company and user hasn't save survey yet, then start a survey
      # later we may also present it on the first login only - $scope.user.sign_in_count <= 1
      if $scope.options_json.survey && !$scope.user.user_preferences
        console.log('Starting survey...')
        startSurvey()
    ).error( ->
      console.log('Error loading user')
    )

  loadUser()

  startSurvey = () ->
    modalInstance = $modal.open({
      templateUrl: 'userSurvey.html',
      controller: SurveyModalCtrl
      size: 'lg'
    })

    modalInstance.result.then (ed_id) ->
      console.log('result ' + ed_id)

  $scope.companyOverview = () ->
    $scope.company_overview = if $scope.user then $scope.user.account['overview'] else ''
    $sce.trustAsHtml($scope.company_overview)

  $scope.gotoSearch = (text) ->
    encoded_text = encodeURIComponent(text)
    $window.location.href = "/search?criteria=" + encoded_text    

# --- controller for modal window
@SurveyModalCtrl = ($scope, $modalInstance, $window, $http) ->
  console.log('modal ctrl')
  $scope.surveySaved = false # true when survey has been saved
  $scope.showSubmit = true # true to show submit button initially, change to false as soon as clicked
  $scope.skills = [] # will get from the back end side
  $scope.otherSkill = null
  $http.get('/surveys/skills.json').success( (data) ->
    $scope.skills = data.skills
    console.log('Successfully loaded skills')
  ).error( ->
    console.log('Error loading skills')
  )

  $scope.done = () ->
    $scope.showSubmit = false # disable submit button to prevent double clicks
    data = { skills: [] }
    for skillset in @skills
      for skill in skillset
        if skill.checked == true
          #console.log('skill ' + skill.id )
          data.skills.push( { id: skill.key_name } )
    if @otherSkill != null
      data.skills.push( {other_skill: @otherSkill} )
    # save right here
    # Create data object to POST and send a request
    $http.post('/users/preferences.json', data).success( (data) ->
      console.log('Successfully set preferences')
      $scope.surveySaved = true
    ).error( ->
      console.error('Failed to set preferences')
      # set this falg to true even if there is an error so that users can proceed and not get stuck on the screen
      # TODO consider error reporting to the user
      $scope.surveySaved = true
    )

  $scope.cancel = ->
    $modalInstance.dismiss('cancel')

@IndexCtrl.$inject = ['$scope', '$http', '$modal', '$sce', '$window']
@SurveyModalCtrl.$inject = ['$scope', '$modalInstance', '$window', '$http']
