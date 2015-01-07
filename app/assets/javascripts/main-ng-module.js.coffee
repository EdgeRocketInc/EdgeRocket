EdgeRocket = angular.module('EdgeRocket', ['ui.bootstrap', 'ngSanitize', 'ngResource', 'ngGrid', 'ngActivityIndicator', 'angularCharts', 'ngMaterial'])

EdgeRocket.config(['$controllerProvider', ($controllerProvider) ->
  $controllerProvider.allowGlobals()
])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])
