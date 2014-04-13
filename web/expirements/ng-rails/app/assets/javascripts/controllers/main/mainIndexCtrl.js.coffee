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

  $scope.fsize = '12px'

  $scope.myToggle = () ->
    $scope.btnToggle = if $scope.btnToggle == 'True' then 'False' else 'True'
 
