EdgeRocket = angular.module('EdgeRocket', ['ui.bootstrap'])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@IndexCtrl = ($scope, $http, $modal) ->

  $scope.playlistsExist = true # TODO make dynamic
  $scope.isSubscribed = []
  $scope.btnSubscribedClass = []
  $scope.glyphSubscribed = []
  $scope.glyphAction = []

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
      # check if it's the first login
      if $scope.data.sign_in_count <= 1 && !$scope.data.user_preferences?
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
      resolve:
        course: () ->
          return $scope.course
    })

    modalInstance.result.then () ->
      # Create data object to POST and send a request
      data =
        education:
          id: 1
      $http.post('/users/preferences.json', data).success( (data) ->
        console.log('Successfully set preferences')
      ).error( ->
        console.error('Failed to set preferences')
      )

# controller for modal window
@SurveyModalCtrl = ($scope, $modalInstance, $window, $http) ->
  console.log('modal ctrl')
  $scope.education = [
    { id: 1, name: 'High School' },
    { id: 2, name: 'BS' },
    { id: 3, name: 'MS' },
    { id: 4, name: 'Ph.D.' },
    { id: 5, name: 'Other' },
  ]
  $scope.done = ->
    #alert('done')
    $modalInstance.close($scope.course)

@IndexCtrl.$inject = ['$scope', '$http', '$modal']
@SurveyModalCtrl.$inject = ['$scope', '$modalInstance', '$window', '$http']
