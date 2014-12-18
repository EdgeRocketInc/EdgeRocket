@IndexCtrl = ($scope, $http, $modal, $sce, $window) ->

  $scope.search = { text : '' }

  loadUser =  ->
    $http.get('/users/current.json').success( (data) ->
      $scope.user = data
      console.log('Successfully loaded user')
      # check if the option is enabled and it's the first login
      $scope.options_json = angular.fromJson($scope.user.account.options)
    ).error( ->
      console.log('Error loading user')
    )

  loadUser()

  $scope.companyOverview = () ->
    $scope.company_overview = if $scope.user then $scope.user.account['overview'] else ''
    $sce.trustAsHtml($scope.company_overview)

  $scope.gotoSearch = (text) ->
    encoded_text = encodeURIComponent(text)
    $window.location.href = "/search?criteria=" + encoded_text    

@IndexCtrl.$inject = ['$scope', '$http', '$modal', '$sce', '$window']
