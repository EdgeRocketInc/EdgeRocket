EdgeRocket = angular.module('EdgeRocket', ['ui.bootstrap'])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@IndexCtrl = ($scope, $http, $modal) ->

  $scope.playlistsExist = true # TODO make dynamic
  # TODO: move 4 arrays below into one array of structures $scope.plStyle = []
  $scope.isSubscribed = []
  $scope.btnSubscribedClass = []
  $scope.glyphSubscribed = []
  $scope.glyphAction = []
  # discussions
  $scope.discussions = []
  $scope.newDiscussion = { title : '', actor_name : 'me' }

  loadPlaylists =  ->
    $http.get('/user_home.json').success( (data) ->
      $scope.data = data
      console.log('Successfully loaded user_home')
      for pl, i in $scope.data.playlists
        # console.log(pl.id)
        if $scope.data.subscribed_playlists[pl.id]?
          $scope.isSubscribed[i] = true
          $scope.btnSubscribedClass[i] = 'btn-default'
          $scope.glyphAction[i] = 'remove-sign red'
          $scope.glyphSubscribed[i] = 'ok-sign'
        else
          $scope.isSubscribed[i] = false
          $scope.btnSubscribedClass[i] = 'btn-default'
          $scope.glyphAction[i] = 'plus-sign green'
          $scope.glyphSubscribed[i] = ''
      # check if the option is enabled and it's the first login
      $scope.options_json = angular.fromJson($scope.data.account.options)
      if $scope.options_json.discussions
        loadDiscussions()
      if $scope.options_json.survey && $scope.data.sign_in_count <= 1 && !$scope.data.user_preferences?
        console.log('Starting survey...')
        startSurvey()
    ).error( ->
      console.log('Error loading user_home')
    )

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
    $scope.glyphAction[index] = if $scope.glyphAction[index] == 'remove-sign red' then 'plus-sign green' else 'remove-sign red'
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
    })

    modalInstance.result.then (ed_id) ->
      console.log('result ' + ed_id)
      # Create data object to POST and send a request
      data =
        education:
          id: ed_id
      $http.post('/users/preferences.json', data).success( (data) ->
        console.log('Successfully set preferences')
      ).error( ->
        console.error('Failed to set preferences')
      )

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


# controller for modal window
@SurveyModalCtrl = ($scope, $modalInstance, $window, $http) ->
  console.log('modal ctrl')
  $scope.education = [
    { id: 'high', name: 'High School' },
    { id: 'bs', name: 'BS' },
    { id: 'ms', name: 'MS' },
    { id: 'phd', name: 'Ph.D.' },
    { id: 'etc', name: 'Other' },
  ]
  $scope.selected = ''

  $scope.done = (s) ->
    console.log('selected = ' + s)
    $modalInstance.close(s)

@IndexCtrl.$inject = ['$scope', '$http', '$modal']
@SurveyModalCtrl.$inject = ['$scope', '$modalInstance', '$window', '$http']
