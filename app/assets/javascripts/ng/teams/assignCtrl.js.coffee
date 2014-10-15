EdgeRocket = angular.module('EdgeRocket', ['ui.bootstrap'])

EdgeRocket.config(["$httpProvider", (provider) ->
	provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@AssignCtrl = ($scope, $http, $modal, $log) ->

	$scope.users = null
	$scope.products = null
	$scope.selectedPair = { userEmail : null, productName : null }
	$scope.enrolled = false
	$scope.showAlert = false

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

	$scope.assignCourse = ->
		if $scope.selectedPair.userEmail != null && $scope.selectedPair.productName != null
			data =
				course_name: $scope.selectedPair.productName
				user_email: $scope.selectedPair.userEmail
				status: 'reg'
				assigned_by: 'Manager'
			$http.post('/course_subscription.json', data).success( (data) ->
				console.log('Successfully created subscription')
				$scope.enrolled = true
				$scope.showAlert = true
			).error( ->
				console.error('Failed to create new subscription')
			)
		else
			console.error('User or product not selected')

@AssignCtrl.$inject = ['$scope', '$http', '$modal', '$log']
