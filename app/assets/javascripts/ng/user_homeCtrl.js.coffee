@IndexCtrl = ($scope, $http) ->

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
     ).error( ->       
      console.log('Error loading user_home')
    )
       
  loadPlaylists()  

  $scope.togglePlaylistSubsciption = (index) ->
    if $scope.isSubscribed[index] == true
      $scope.isSubscribed[index] = false
      $scope.glyphAction[index] = 'remove-sign red'
      $scope.glyphSubscribed[index] = 'ok-sign'
    else      
      $scope.isSubscribed[index] = true
      $scope.glyphAction[index] = 'plus-sign green'
      $scope.glyphSubscribed[index] = ''

 

