EdgeRocket = angular.module('EdgeRocket', ['ui.bootstrap'])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@PlaylistsCtrl = ($scope, $http, $modal, $log) ->

  $scope.newPlaylist = ''

  loadPlaylists =  ->
    $http.get('/playlists.json').success( (data) ->
      $scope.playlists = data
      console.log('Successfully loaded playlists')
    ).error( ->
      console.log('Error loading playlists')
    )

  loadPlaylists()

  $scope.addNewPlaylist = ->
    console.log($scope.newPlaylist)
    new_pl = { id : null, title : $scope.newPlaylist }
    # POST and send a request
    $http.post('/playlists.json', new_pl).success( (data) ->
      console.log('Successfully created playlist')
      # use new playlist ID
      new_pl.id = data.id
      $scope.playlists.push(new_pl)
      $scope.newPlaylist = ''
    ).error( ->
      console.error('Failed to add to playlist')
    )

  $scope.removePlaylist = (playlist,index) ->
    $http.delete('/playlists/' + playlist.id + '.json', null).success( (data) ->
      console.log('Successfully removed playlist')
      $scope.playlists.splice(index,1)
    ).error( ->
      console.error('Failed to remove playlist')
    )

@PlaylistsCtrl.$inject = ['$scope', '$http', '$modal', '$log']
