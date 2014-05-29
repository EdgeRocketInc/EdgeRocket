EdgeRocket = angular.module('EdgeRocket', ['ui.bootstrap'])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@PlaylistsCtrl = ($scope, $http, $modal, $log) ->

  $scope.newPlaylist = { title : '' }
  $scope.editModeIndex = -1 # will set to $index when editing a playlist in place
  $scope.playlistMode = true
  $scope.currentPlaylist = null # will set to the playlist for managing courses
  $scope.currentCourses = [] # will populate when managing courses

  loadPlaylists =  ->
    $http.get('/playlists.json').success( (data) ->
      $scope.playlists = data
      console.log('Successfully loaded playlists')
    ).error( ->
      console.log('Error loading playlists')
    )

  loadPlaylists()

  $scope.createPlaylist = ()->
    console.log('Creating:' + $scope.newPlaylist.title)
    new_pl = { id : null, title : $scope.newPlaylist.title }
    # POST and send a request
    $http.post('/playlists.json', new_pl).success( (data) ->
      console.log('Successfully created playlist')
      # use new playlist ID
      new_pl.id = data.id
      $scope.playlists.push(new_pl)
      $scope.newPlaylist.title = ''
    ).error( ->
      console.error('Failed to add to playlist')
    )

  $scope.updatePlaylist = (playlist,index) ->
    updated_pl = { title : playlist.title }
    console.log('Updating:' + updated_pl.title)
    # POST and send a request
    $http.put('/playlists/' + playlist.id + '.json', updated_pl).success( (data) ->
      console.log('Successfully updated playlist')
      # switch to non-editing mode
      $scope.editModeIndex = -1
    ).error( ->
      console.error('Failed to update playlist')
    )
  $scope.removePlaylist = (playlist,index) ->
    $http.delete('/playlists/' + playlist.id + '.json', null).success( (data) ->
      console.log('Successfully removed playlist')
      $scope.playlists.splice(index,1)
    ).error( ->
      console.error('Failed to remove playlist')
    )

  $scope.editPlaylist = (playlist,index) ->
    $scope.editModeIndex = index
    console.log('editing index=' + $scope.editModeIndex + ' title:' + playlist.title)

  $scope.cancelEditingPlaylist = () ->
    console.log('cancel editing')
    $scope.editModeIndex = -1

  $scope.manageCourses = (playlist,index) ->
    console.log('manage courses for ' + playlist.title)
    $http.get('/playlists/' + playlist.id + '/courses.json').success( (data) ->
      # switch to manage courses mode
      $scope.playlistMode = false 
      $scope.currentPlaylist = playlist
      $scope.currentCourses = data
      console.log('Successfully loaded user_home')
     ).error( ->
      console.log('Error loading user_home')
    )

  $scope.cancelManageCourses = () ->
    $scope.playlistMode = true # switch to playlist mode
    $scope.currentPlaylist = null
    $scope.currentCourses = []

  $scope.removeCourse = (course,index) ->
    $http.delete('/playlists/' + $scope.currentPlaylist.id + '/courses/' + course.id + '.json', null).success( (data) ->
      console.log('Successfully removed course from playlist')
      $scope.currentCourses.splice(index,1)
    ).error( ->
      console.error('Failed to remove course from playlist')
    )

@PlaylistsCtrl.$inject = ['$scope', '$http', '$modal', '$log']
