EdgeRocket = angular.module('EdgeRocket', ['ui.bootstrap', 'ngSanitize'])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@IndexCtrl = ($scope, $http, $modal, $sce, $window) ->

  $scope.playlistsExist = true # TODO make dynamic
  # TODO: move 4 arrays below into one array of structures $scope.plStyle = []
  $scope.isSubscribed = []
  $scope.glyphAction = []
  $scope.glyphTooltip = []
  # discussions
  $scope.discussions = []
  $scope.newDiscussion = { title : '', actor_name : 'me', gplus : false }
  # the true value is for the last row
  $scope.rowClass = { true:'course-last-row', false:'course-row' }

  loadPlaylists =  ->
    $http.get('/user_home.json').success( (data) ->
      $scope.data = data
      console.log('Successfully loaded user_home')
      for pl, i in $scope.data.playlists
        days_old = (Date.now() - Date.parse(pl.updated_at)) / _MS_PER_DAY
        pl.isNew = days_old < _DAYS_OLD
        # console.log(pl.id)
        if $scope.data.subscribed_playlists[pl.id]?
          $scope.isSubscribed[i] = true
          $scope.glyphAction[i] = 'check'
          $scope.glyphTooltip[i] = 'Uncheck to unsubscribe'
        else
          $scope.isSubscribed[i] = false
          $scope.glyphAction[i] = 'unchecked'
          $scope.glyphTooltip[i] = 'Check to subscribe'
    ).error( ->
      console.log('Error loading user_home')
    )

  loadUser =  ->
    $http.get('/users/current.json').success( (data) ->
      $scope.user = data
      console.log('Successfully loaded user')
      # check if the option is enabled and it's the first login
      $scope.options_json = angular.fromJson($scope.user.account.options)
      if $scope.options_json.discussions
        # set checkbox for G+
        $scope.options_json.gbox_class = if $scope.options_json.discussions == 'gplus' then 'check' else null
        loadDiscussions()
      # if sruvey flag is enabled for this company and user hasn't save survey yet, then start a survey
      # later we may also present it on the first login only - $scope.user.sign_in_count <= 1
      if $scope.options_json.survey && !$scope.user.user_preferences
        console.log('Starting survey...')
        startSurvey()
    ).error( ->
      console.log('Error loading user')
    )

  loadUser()
  loadPlaylists()

  $scope.togglePlaylistSubsciption = (index) ->
    console.log('click index ' + index + ' subscirbed[i] = ' + $scope.isSubscribed[index] )
    #debugger
    if $scope.isSubscribed[index] == true
      # open modal prompt
      promptModalInstance = $modal.open({
        templateUrl: 'unsubPromptModal.html'
        controller: UnsubPromptModalCtrl
        resolve:
          pl_name: () ->
            return $scope.data.playlists[index].title
      })
      promptModalInstance.result.then (ed_id) ->
        console.log('prompt' + ed_id)
        deleteSubscription($scope.data.playlists[index].id, index)
    else
      # when subscribing, we subscribe first and then just let the user know
      createSubscription($scope.data.playlists[index].id, index)

      console.log('changed pl.id=' + $scope.data.playlists[index].id + ' to true' )
      # open modal confirmation
      confirmModalInstance = $modal.open({
        templateUrl: 'subConfirmModal.html'
        controller: SubConfirmModalCtrl
        resolve:
          pl_name: () ->
            return $scope.data.playlists[index].title
      })
      confirmModalInstance.result.then (ed_id) ->
        console.log('confirm ' + ed_id)
        $window.location.href = '/my_courses'


  createSubscription = (playlistId, index) ->
    # Create data object to POST and send a request
    data =
      playlist_id: playlistId

    $http.post('/playlist_subscription.json', data).success( (data) ->
      console.log('Successfully subscribed to playlist')
      $scope.isSubscribed[index] = true
      $scope.glyphAction[index] = 'check'
      $scope.glyphTooltip[index] = 'Uncheck to unsubscribe'
    ).error( ->
      console.error('Failed to subscribe to playlist')
    )
    return true

  deleteSubscription = (playlistId, index) ->
    $http.delete('/playlist_subscription/' + playlistId + '.json').success( (data) ->
      console.log('Successfully unsubscribed to playlist')
      $scope.isSubscribed[index] = false
      $scope.glyphAction[index] = 'unchecked'
      $scope.glyphTooltip[index] = 'Check to subscribe'
    ).error( ->
      console.error('Failed to unsubscribe to playlist')
    )
    return true

  startSurvey = () ->
    modalInstance = $modal.open({
      templateUrl: 'userSurvey.html',
      controller: SurveyModalCtrl
      size: 'lg'
    })

    modalInstance.result.then (ed_id) ->
      console.log('result ' + ed_id)

  loadDiscussions = () ->
    $http.get('/discussions.json').success( (data) ->
      console.log('loading discussions ... ')
      $scope.discussions = data.discussions
    ).error( ->
      console.log('Error loading discussions')
    )

  $scope.createDiscussion = () ->
    # Create data object to POST and send a request
    console.log('new title=' + $scope.newDiscussion.title)
    # Pass G+ flag if it's checked
    $scope.newDiscussion.gplus = ($scope.options_json.gbox_class == 'check')
    data = $scope.newDiscussion

    $http.post('/discussions.json', data).success( (data) ->
      saved_discussion = { 
        title : $scope.newDiscussion.title, 
        user : { email : '<me>' }
      }
      $scope.discussions.splice(0,0,saved_discussion)
      $scope.newDiscussion.title = ''
      console.log('Successfully created discussion')
    ).error( ->
      console.error('Failed to create discussion')
    )
    return true

  $scope.toggleGBox = () ->
    if $scope.options_json.gbox_class == 'check'
      $scope.options_json.gbox_class = 'unchecked'
    else
      $scope.options_json.gbox_class = 'check'

  $scope.companyOverview = () ->
    $scope.company_overview = if $scope.user then $scope.user.account['overview'] else ''
    $sce.trustAsHtml($scope.company_overview)
    

# --- controller for modal window
@SurveyModalCtrl = ($scope, $modalInstance, $window, $http) ->
  console.log('modal ctrl')
  $scope.surveySaved = false # true when survey has been saved
  $scope.skills = [] # will get from the back end side
  $scope.otherSkill = null
  $http.get('/surveys/skills.json').success( (data) ->
    $scope.skills = data.skills
    console.log('Successfully loaded skills')
  ).error( ->
    console.log('Error loading skills')
  )

  $scope.done = () ->
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


# --- controller for modal window
@SubConfirmModalCtrl = ($scope, $modalInstance, $window, $http, pl_name) ->
  console.log('modal sub confirm ctrl')
  #debugger
  $scope.thePlaylistName = pl_name

  $scope.go_to_my = () ->
    $modalInstance.close('goto')

  $scope.cancel = ->
    $modalInstance.dismiss('cancel')


# --- controller for modal window
@UnsubPromptModalCtrl = ($scope, $modalInstance, $window, $http, pl_name) ->
  console.log('modal unsub prompt ctrl')
  #debugger
  $scope.thePlaylistName = pl_name

  $scope.proceed = () ->
    $modalInstance.close('proceed')

  $scope.cancel = ->
    $modalInstance.dismiss('cancel')


@IndexCtrl.$inject = ['$scope', '$http', '$modal', '$sce', '$window']
@SurveyModalCtrl.$inject = ['$scope', '$modalInstance', '$window', '$http']
@SubConfirmModalCtrl.$inject = ['$scope', '$modalInstance', '$window', '$http', 'pl_name']
@UnsubPromptModalCtrl.$inject = ['$scope', '$modalInstance', '$window', '$http', 'pl_name']
