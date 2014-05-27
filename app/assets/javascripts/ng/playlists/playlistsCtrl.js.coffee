EdgeRocket = angular.module('EdgeRocket', ['ui.bootstrap'])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@PlaylistsCtrl = ($scope, $http, $modal, $log) ->

  loadPlaylists =  ->
    $http.get('/playlists.json').success( (data) ->
      $scope.playlists = data
      console.log('Successfully loaded playlists')
    ).error( ->
      console.log('Error loading playlists')
    )

  loadPlaylists()

@PlaylistsCtrl.$inject = ['$scope', '$http', '$modal', '$log']
