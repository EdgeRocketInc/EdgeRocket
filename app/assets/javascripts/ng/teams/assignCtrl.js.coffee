EdgeRocket = angular.module('EdgeRocket', ['ui.bootstrap', 'ngActivityIndicator'])

EdgeRocket.config(["$httpProvider", (provider) ->
	provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@AssignCtrl = ($scope, $http, $modal, $log, $activityIndicator) ->

	#$scope.loading = true
	$scope.users = []	
	$scope.products = []
	$scope.selectedPair = { userEmail : null, productName : null }
	$scope.enrolled = false
	$scope.showAlert = false
	$scope.disableSave = false # disable while processing requests
	$scope.sendEmail = 'check'

	loadAllData =  ->
		$http.get('/employees.json').success( (data) ->
			$scope.users = data.users
			console.log('Successfully loaded users')
			loadProducts()
		).error( ->
			console.log('Error loading users')
			$activityIndicator.stopAnimating()
		)

	# Load products for lookup
	loadProducts =  ->
		$http.get('/products.json').success( (data) ->
			$scope.products = data
			$activityIndicator.stopAnimating()
			console.log('Successfully loaded products')
		).error( ->
			console.log('Error loading search products')
			$activityIndicator.stopAnimating()
		)

	$activityIndicator.startAnimating()
	loadAllData()

	$scope.assignCourse = ->
		if $scope.selectedPair.userEmail != null && $scope.selectedPair.productName != null
			data =
				course_name: $scope.selectedPair.productName
				user_email: $scope.selectedPair.userEmail
				status: 'reg'
				assigned_by: 'Manager'
				send_email: if $scope.sendEmail == 'check' then true else false
			$scope.disableSave = true
			$http.post('/course_subscription.json', data).success( (data) ->
				console.log('Successfully created subscription')
				$scope.enrolled = true
				$scope.showAlert = true
				$scope.disableSave = false
			).error( ->
				console.error('Failed to create new subscription')
				$scope.disableSave = false
			)
		else
			console.error('User or product not selected')

	$scope.toggleEmail = () ->
	    if $scope.sendEmail == 'check'
	      $scope.sendEmail = 'unchecked'
	    else
	      $scope.sendEmail = 'check'

@AssignCtrl.$inject = ['$scope', '$http', '$modal', '$log', '$activityIndicator']
