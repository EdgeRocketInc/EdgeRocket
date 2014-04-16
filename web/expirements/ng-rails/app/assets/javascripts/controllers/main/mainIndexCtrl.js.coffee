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

  # CHARTS


  $scope.chartData = {
    series: ['Sales', 'Income', 'Expense', 'Laptops', 'Keyboards'],
    data : [{
      x : "Sales",
      y: [100,500, 0],
      tooltip:"this is tooltip"
    },
    {
      x : "Not Sales",
      y: [300, 100, 100]
    },
    {
      x : "Tax",
      y: [351]
    },
    {
      x : "Not Tax",
      y: [54, 0, 879]
    }]     
  }

  $scope.chartType = 'bar'

  $scope.config = {
    labels: false,
    title : "Not Products",
    legend : {
      display:true,
      position:'left'
    }
  }

  $scope.config1 = {
    labels: false,
    title : "Products",
    legend : {
      display:true,
      position:'right'
    }
  }
