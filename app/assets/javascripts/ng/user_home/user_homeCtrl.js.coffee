EdgeRocket = angular.module('EdgeRocket', ['ui.bootstrap', 'ngSanitize'])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@IndexCtrl = ($scope, $http, $modal, $sce) ->

  $scope.playlistsExist = true # TODO make dynamic
  # TODO: move 4 arrays below into one array of structures $scope.plStyle = []
  $scope.isSubscribed = []
  $scope.glyphSubscribed = []
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
        # console.log(pl.id)
        if $scope.data.subscribed_playlists[pl.id]?
          $scope.isSubscribed[i] = true
          $scope.glyphAction[i] = 'check'
          $scope.glyphTooltip[i] = 'Uncheck to unsubscribe'
          $scope.glyphSubscribed[i] = 'ok-sign'
        else
          $scope.isSubscribed[i] = false
          $scope.glyphAction[i] = 'unchecked'
          $scope.glyphTooltip[i] = 'Check to subscribe'
          $scope.glyphSubscribed[i] = ''
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
      if $scope.options_json.survey && !$scope.user.user_preferences?
        console.log('Starting survey...')
        startSurvey()
    ).error( ->
      console.log('Error loading user')
    )

  loadUser()
  loadPlaylists()

  $scope.togglePlaylistSubsciption = (index) ->
    console.log('click index ' + index + ' subscirbed[i] = ' + $scope.isSubscribed[index] )
    if $scope.isSubscribed[index] == true
      $scope.isSubscribed[index] = false
      deleteSubscription($scope.data.playlists[index].id)
      console.log('changed to false' )
    else
      $scope.isSubscribed[index] = true
      createSubscription($scope.data.playlists[index].id)
      console.log('changed pl.id=' + $scope.data.playlists[index].id + ' to true' )
    # TODO this is crazy but I can't make it work otherwise
    $scope.glyphAction[index] = if $scope.glyphAction[index] == 'check' then 'unchecked' else 'check'
    $scope.glyphTooltip[index] = if $scope.glyphAction[index] == 'check' then 'Uncheck to unsubscribe' else 'Check to subscribe'
    $scope.glyphSubscribed[index] = if $scope.glyphSubscribed[index] == 'ok-sign' then '' else 'ok-sign'


  createSubscription = (playlistId) ->
    # Create data object to POST and send a request
    data =
      playlist_id: playlistId

    $http.post('/playlist_subscription.json', data).success( (data) ->
      console.log('Successfully subscribed to playlist')
    ).error( ->
      console.error('Failed to subscribe to playlist')
    )
    return true

  deleteSubscription = (playlistId) ->
    $http.delete('/playlist_subscription/' + playlistId + '.json').success( (data) ->
      console.log('Successfully unsubscribed to playlist')
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
    

# controller for modal window
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
    #debugger
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

@IndexCtrl.$inject = ['$scope', '$http', '$modal', '$sce']
@SurveyModalCtrl.$inject = ['$scope', '$modalInstance', '$window', '$http']
