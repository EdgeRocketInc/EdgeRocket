EdgeRocket = angular.module('EdgeRocket', ['ui.bootstrap'])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@AssignCtrl = ($scope, $http, $modal, $log) ->

  $scope.users = null
  $scope.products = null

  loadUsers =  ->
    $http.get('/employees.json').success( (data) ->
      $scope.users = data.users
      console.log('Successfully loaded users')
    ).error( ->
      console.log('Error loading users')
    )

  # Load products for lookup
  loadProducts =  ->
    $http.get('/products.json').success( (data) ->
      $scope.products = data
      console.log('Successfully loaded products')
    ).error( ->
      console.log('Error loading search products')
    )

  loadUsers()
  loadProducts()

@AssignCtrl.$inject = ['$scope', '$http', '$modal', '$log']
