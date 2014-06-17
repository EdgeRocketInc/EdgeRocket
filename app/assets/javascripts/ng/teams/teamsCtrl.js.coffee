EdgeRocket = angular.module('EdgeRocket', ['ui.bootstrap'])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@TeamsCtrl = ($scope, $http, $modal, $log) ->

  # TODO
  
@TeamsCtrl.$inject = ['$scope', '$http', '$modal', '$log']
