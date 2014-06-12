EdgeRocket = angular.module('EdgeRocket', ['ui.bootstrap'])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@PlaylistsCtrl = ($scope, $http, $modal, $log) ->

  $scope.newPlaylist = { title : '', description : '', mandatory : false, mandatory_class : 'unchecked'}
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
    console.log('Creating:' + $scope.newPlaylist.title+','+$scope.newPlaylist.description)
    new_pl = { id : null, title : $scope.newPlaylist.title, description : $scope.newPlaylist.description, mandatory : $scope.newPlaylist.mandatory}
    # POST and send a request
    $http.post('/playlists.json', new_pl).success( (data) ->
      console.log('Successfully created playlist')
      # use new playlist ID
      new_pl.id = data.id
      $scope.playlists.push(new_pl)
      $scope.newPlaylist.title = ''
      $scope.newPlaylist.description = ''
      $scope.newPlaylist.mandatory = false
      $scope.newPlaylist.mandatory_class = 'unchecked'

    ).error( ->
      console.error('Failed to add to playlist')
    )

  $scope.updatePlaylist = (playlist,index) ->
    updated_pl = { title : playlist.title, description : playlist.description, mandatory : playlist.mandatory}
    console.log('Updating:' + updated_pl.title+','+updated_pl.description)
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

  $scope.toggleMandatory = () ->
    if $scope.newPlaylist.mandatory_class == 'check'
      $scope.newPlaylist.mandatory_class = 'unchecked'
      $scope.newPlaylist.mandatory = false
    else
      $scope.newPlaylist.mandatory_class = 'check'
      $scope.newPlaylist.mandatory = true

  $scope.toggleMandatoryEdit = (playlist) ->
    if playlist.mandatory_class == 'check'
      playlist.mandatory_class = 'unchecked'
      playlist.mandatory = false
    else
      playlist.mandatory_class = 'check'
      playlist.mandatory = true

  $scope.editPlaylist = (playlist,index) ->
    $scope.editModeIndex = index
    if playlist.mandatory == false
      playlist.mandatory_class = 'unchecked'
    else
      playlist.mandatory_class = 'check'

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
