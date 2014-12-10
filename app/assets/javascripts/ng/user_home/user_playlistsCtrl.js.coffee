@PlaylistsCtrl = ($scope, $http, $modal, $sce, $window) ->

  $scope.playlistsExist = true # TODO make dynamic
  # TODO: move 4 arrays below into one array of structures $scope.plStyle = []
  $scope.isSubscribed = []
  $scope.glyphAction = []
  $scope.glyphTooltip = []
  # the true value is for the last row
  $scope.rowClass = { true:'course-last-row', false:'course-row' }

  loadPlaylists =  ->
    $http.get('/user_playlists.json').success( (data) ->
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


@PlaylistsCtrl.$inject = ['$scope', '$http', '$modal', '$sce', '$window']
@SubConfirmModalCtrl.$inject = ['$scope', '$modalInstance', '$window', '$http', 'pl_name']
@UnsubPromptModalCtrl.$inject = ['$scope', '$modalInstance', '$window', '$http', 'pl_name']
