EdgeRocket = angular.module('EdgeRocket', ['ui.bootstrap'])

EdgeRocket.config(["$httpProvider", (provider) ->
	provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@HelpCtrl = ($scope, $http, $modal, $log) ->

@HelpCtrl.$inject = ['$scope', '$http', '$modal', '$log']
