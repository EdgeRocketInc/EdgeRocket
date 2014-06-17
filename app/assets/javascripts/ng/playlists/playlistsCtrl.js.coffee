EdgeRocket = angular.module('EdgeRocket', ['ui.bootstrap', 'ngGrid'])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@PlaylistsCtrl = ($scope, $http, $modal, $log) ->

  $scope.newPlaylist = { 
    title : '', 
    description : '', 
    mandatory : false, 
    mandatory_class : 'unchecked'
  }
  # will set to index when editing a playlist in place
  # the value of index is not used at this time, it works as long as it's >= 0
  $scope.editModeIndex = -1 
  $scope.addingMode = false
  $scope.playlistMode = true
  $scope.currentPlaylist = null # will set to the playlist for managing courses
  $scope.currentCourses = [] # will populate when managing courses
  $scope.playlists = null

  $scope.editPlaylist = (playlist_id) ->
    # find the user record and switch to edit more
    for p,i in $scope.playlists
      if p.id == playlist_id
        $scope.addingMode = false
        $scope.editModeIndex = i
        $scope.newPlaylist.id = playlist_id
        $scope.newPlaylist.title = p.title
        $scope.newPlaylist.description = p.description
        $scope.newPlaylist.mandatory_class = if p.mandatory then 'check' else 'unchecked'
        console.log('editing index=' + $scope.editModeIndex + ' title:' + p.title)
        break

  # This method is called before a grid is selected
  $scope.beforeSelect = (rowItem) ->
    false

  $scope.gridOptions = { 
    data : 'playlists',
    multiSelect : false,
    beforeSelectionChange : $scope.beforeSelect
    columnDefs : [
      { field : 'title', displayName : 'Playlist'}, 
      { field : 'description', displayName : 'Description'}, 
      { field : 'mandatory', displayName : 'Mandatory', width : '8%', minWidth : '80', cellTemplate: 'cellMandatory.html' },
      { field : 'id', displayName : 'Content/Delete', width : '8%', minWidth : '80', cellTemplate: 'cellActions.html' }
    ]
  }  

  $scope.clearEditForm = ->
    $scope.newPlaylist.title = ''
    $scope.newPlaylist.description = ''
    $scope.newPlaylist.mandatory_class = 'unchecked'

  loadPlaylists =  ->
    $http.get('/playlists.json').success( (data) ->
      $scope.playlists = data
      console.log('Successfully loaded playlists')
    ).error( ->
      console.log('Error loading playlists')
    )

  loadPlaylists()

  $scope.addPlaylist = () ->
    console.log('switching to adding mode')
    $scope.addingMode = true
    $scope.editModeIndex = -1
    $scope.clearEditForm()

  $scope.createPlaylist = () ->
    console.log('Creating:' + $scope.newPlaylist.title+','+$scope.newPlaylist.description)
    new_pl = { id : null, title : $scope.newPlaylist.title, description : $scope.newPlaylist.description, mandatory : $scope.newPlaylist.mandatory}
    # POST and send a request
    $http.post('/playlists.json', new_pl).success( (data) ->
      console.log('Successfully created playlist')
      # use new playlist ID
      new_pl.id = data.id
      $scope.playlists.push(new_pl)
      $scope.editModeIndex = -1
      $scope.addingMode = false
      $scope.clearEditForm()
    ).error( ->
      console.error('Failed to add to playlist')
    )

  # Update the playlist in DB and UI
  $scope.updatePlaylist = () ->
    # convert display structure to API payload
    updated_pl = { 
      id : $scope.newPlaylist.id
      title : $scope.newPlaylist.title, 
      description : $scope.newPlaylist.description, 
      mandatory : if $scope.newPlaylist.mandatory_class == 'check' then true else false
    }
    console.log('Updating: ' + updated_pl.title)
    # POST and send a request
    $http.put('/playlists/' + updated_pl.id + '.json', updated_pl).success( (data) ->
      console.log('Successfully updated playlist')
      # find the playlist record and update it
      for p,i in $scope.playlists
        if p.id == updated_pl.id
          p.title = $scope.newPlaylist.title
          p.description = $scope.newPlaylist.description
          p.mandatory = updated_pl.mandatory
          console.log('editing index=' + $scope.editModeIndex + ' title:' + p.title)
          break
      # switch to non-editing mode
      $scope.editModeIndex = -1
      $scope.addingMode = false
      $scope.clearEditForm()
    ).error( ->
      console.error('Failed to update playlist')
    )

  $scope.removePlaylist = (playlist_id) ->
    $http.delete('/playlists/' + playlist_id + '.json', null).success( (data) ->
      console.log('Successfully removed playlist')
      $scope.editModeIndex = -1
      $scope.addingMode = false
      # find and remove record from internal array
      for p,i in $scope.playlists
        if p.id == playlist_id
          $scope.playlists.splice(i,1)
          break
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

  # Cancel edit and adding modes
  $scope.cancelEditingPlaylist = () ->
    console.log('cancel editing')
    $scope.editModeIndex = -1
    $scope.addingMode = false

  $scope.manageCourses = (playlist_id) ->
    console.log('manage courses for ' + playlist_id)
    $http.get('/playlists/' + playlist_id + '/courses.json').success( (data) ->
      # switch to manage courses mode
      for p,i in $scope.playlists
        if p.id == playlist_id
          $scope.currentPlaylist = p
          $scope.playlistMode = false 
          $scope.addingMode = false
          $scope.editModeIndex = -1
          $scope.currentCourses = data
          console.log('Successfully loaded user_home')
          break
     ).error( ->
      console.log('Error loading user_home')
    )

  $scope.cancelManageCourses = () ->
    $scope.playlistMode = true # switch to playlist mode
    $scope.editModeIndex = -1
    $scope.addingMode = false
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
