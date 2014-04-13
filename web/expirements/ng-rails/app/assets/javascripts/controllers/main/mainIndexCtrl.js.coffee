@IndexCtrl = ($scope, $location, $http) ->
  $scope.data = 
    posts: [{title: 'Loading posts...', contents: ''}]
  $scope.btnToggle = 'True'

  loadPosts = ->
    $http.get('/posts.json').success( (data) ->
      $scope.data.posts = data
      console.log('successfull loaded posts')
    ).error( ->
      console.log('error loading posts')
    )

  loadPosts()

  $scope.viewPost = (postId) ->
    $location.url('/post/'+postId)

  $scope.myToggle = () ->
    $scope.btnToggle = if $scope.btnToggle == 'True' then 'False' else 'True'
 
  # from real app
  $scope.data.playlists = [{id: 101, title: 'pl1', description: 'desc1'}, {id: 102, title: 'pl2', description: 'desc2'}]
  $scope.isSubscribed = [true, false]
  $scope.glyphAction = ['remove-sign','plus-sing']
  $scope.glyphAction2 = 'remove-sign'

  $scope.togglePlaylistSubsciption = (index) ->
    console.log('click index ' + index + ' subscirbed[i] = ' + $scope.isSubscribed[index] )
    $scope.glyphAction[index] = if $scope.glyphAction[index] == 'remove-sign' then 'plus-sign' else 'remove sign'

  $scope.togglePlaylistSubsciption2 = () ->
    $scope.glyphAction2 = if $scope.glyphAction2 == 'remove-sign' then 'plus-sign' else 'remove-sign'

