@CompanyCtrl = ($scope, $http, $modal, $log) ->

	$scope.account = null
	$scope.status = { done: false, textClass: null, message: null }

	loadData =  ->
		$http.get('/account.json').success( (data) ->
			$scope.account = data.account
			console.log('Account: ' + $scope.account.company_name)
		).error( ->
			console.log('Error loading account')
		)

	loadData()

	$scope.updateAccount = () ->
		console.log('Updating: ' + $scope.account.company_name)
		# POST and send a request
		$http.put('/account/' + $scope.account.id + '.json', $scope.account).success( (data) ->
			console.log('Successfully updated account')
			$scope.status = { done: true, textClass: 'success', message: 'Updated successfully' }
		).error( ->
			console.error('Failed to update user')
			$scope.status = { done: true, textClass: 'danger', message: 'Error' }
		)

@CompanyCtrl.$inject = ['$scope', '$http', '$modal', '$log']
