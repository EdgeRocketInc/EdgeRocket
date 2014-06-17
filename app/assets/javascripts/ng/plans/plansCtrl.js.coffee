EdgeRocket = angular.module('EdgeRocket', ['ui.bootstrap'])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@PlansCtrl = ($scope, $http, $modal, $log) ->


@PlansCtrl.$inject = ['$scope', '$http', '$modal', '$log']
