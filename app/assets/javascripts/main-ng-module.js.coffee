EdgeRocket = angular.module('EdgeRocket', ['ui.bootstrap', 'ngSanitize', 'ngResource', 'ngGrid', 'ngActivityIndicator', 'angularCharts', 'ngMaterial'])

EdgeRocket.config(['$controllerProvider', ($controllerProvider) ->
  $controllerProvider.allowGlobals()
])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

EdgeRocket.config(["$mdThemingProvider", (provider) ->
  # will use the colors from default theme for any color not defined.
  provider.theme('default').primaryColor('orange').accentColor('deep-purple')
])
