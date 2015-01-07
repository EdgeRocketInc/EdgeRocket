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
  $scope.rankErrorMessage = ''
  $scope.rankSuccessMessage = ''

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

  $scope.gridOptions = { 
    data : 'playlists',
    multiSelect : false,
    enableRowSelection: false,
    columnDefs : [
      { field : 'title', displayName : 'Playlist'}, 
      { field : 'description', displayName : 'Description'}, 
      { field : 'mandatory', displayName : 'Mandatory', width : '8%', minWidth : '80', cellTemplate: 'cellMandatory.html' },
      { field : 'id', displayName : 'Content/Delete', width : '8%', minWidth : '80', cellTemplate: 'cellActions.html' }
    ]
  }  

  $scope.coursesGridOptions = { 
    data : 'currentCourses',
    multiSelect : false,
    sortInfo : { fields: ['rank'], directions: ['asc'] }
    enableCellSelection: false,
    enableRowSelection: false,
    enableCellEditOnFocus: true,
    columnDefs : [
      { field : 'rank', displayName : 'Rank',  width : '8%', enableCellEdit: true, cellClass : 'text-info' }, 
      { field : 'product.name', displayName : 'Name', enableCellEdit: false}, 
      { field : 'product_id', displayName : 'Delete', width : '8%', minWidth : '80', cellTemplate: 'cellCourseActions.html', enableCellEdit: false }
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
          $scope.currentCourses = data.courses
          console.log('Successfully loaded playlist items')
          break
     ).error( ->
      console.log('Error loading playlist items')
    )

  $scope.cancelManageCourses = () ->
    $scope.playlistMode = true # switch to playlist mode
    $scope.editModeIndex = -1
    $scope.addingMode = false
    $scope.currentPlaylist = null
    $scope.currentCourses = []

  $scope.removeCourse = (course_id) ->

    $scope.modal_params = {
      course_id: course_id
    }
    # prompt user to submit a comment
    modalInstance = $modal.open({
      templateUrl: 'promptItemModal.html',
      controller: PromptItemModalCtrl
      resolve:
        modal_params: () ->
          return $scope.modal_params
    })

    modalInstance.result.then (course_id) ->

      $http.delete('/playlists/' + $scope.currentPlaylist.id + '/courses/' + course_id + '.json', null).success( (data) ->
        console.log('Successfully removed course from playlist')
        # find and remove record from internal array
        for p,i in $scope.currentCourses
          if p.product_id == course_id
            $scope.currentCourses.splice(i,1)
            break
      ).error( ->
        console.error('Failed to remove course from playlist')
      )

  $scope.saveRanks = ->
    console.log('updating ranks')
    new_ranks = { ranks : [] }
    for c in $scope.currentCourses
      new_ranks.ranks.push({ id : c.id, rank : c.rank })
    $http.put('/playlist_items/ranks.json', new_ranks).success( (data) ->
      console.log('Successfully updated ranks')
      $scope.rankSuccessMessage = '* Successfully updated ranks'
      $scope.rankErrorMessage = ''
    ).error( ->
      console.error('Failed to update ranks')
      $scope.rankSuccessMessage = ''
      $scope.rankErrorMessage = '* Error updating ranks'
    )

# controller for modal window (promptItemModal)
@PromptItemModalCtrl = ($scope, $modalInstance, $window, $http, modal_params) ->
  console.log('Prompt modal ctrl')
  $scope.modal_params = modal_params

  $scope.proceed = () ->
    console.log('proceed with the action...')
    $modalInstance.close($scope.modal_params.course_id)

  $scope.cancel = ->
    $modalInstance.dismiss('cancel')

@PromptItemModalCtrl.$inject = ['$scope', '$modalInstance', '$window', '$http', 'modal_params'] 
@PlaylistsCtrl.$inject = ['$scope', '$http', '$modal', '$log']
