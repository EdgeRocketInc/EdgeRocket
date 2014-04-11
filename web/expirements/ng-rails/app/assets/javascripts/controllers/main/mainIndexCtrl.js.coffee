@IndexCtrl = ($scope) ->
  $scope.data = 
    posts: [{title: 'My first post', contents: 'Lorem ipsum dolor sit amet'}, 
    {title: 'A walk down memory lane', contents: 'consectetur adipiscing elit'}]

  $scope.fsize = '12px'

  $scope.myToggle = ($event) ->
    $scope.fsize = if $scope.fsize == '12px' then '16px' else '12px'
 
