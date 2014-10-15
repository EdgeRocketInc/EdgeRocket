EdgeRocket = angular.module("EdgeRocket", ['ui.bootstrap'])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@SystemAnalyticsCtrl = ($scope) ->


  $scope.runQuery = () ->
    client = new Keen {
      projectId: $('#analytics_chart').data('project-id')
      readKey: $('#analytics_chart').data('read-key')
    };

    #$scope.getTable(query)
    console.log(client)

    Keen.ready ->

      query = new Keen.Query('count', {
        eventCollection: 'ui_actions',
        timeframe: 'this_' + $scope.analyticsHours + '_hours'
        groupBy: 'user_email'
      })

      client.draw(query, document.getElementById('analytics_chart'), {
        title: 'Custom chart title'
      })


  $scope.getTable = (client) ->
     $scope.analyticsSearches




@SystemAnalyticsCtrl.$inject = ['$scope']