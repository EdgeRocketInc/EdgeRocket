EdgeRocket = angular.module("EdgeRocket", ['ui.bootstrap'])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@SystemAnalyticsCtrl = ($scope) ->
  $scope.setClient = () ->
    $scope.client = new Keen {
      projectId: $('#analytics_chart').data('project-id')
      readKey: $('#analytics_chart').data('read-key')
    };

  $scope.searchesTable = {
    data: 'tableData',
    columnDefs: [
      {field: 'search_criteria', displayName: 'Search Criteria'},
      {field: 'keen.timestamp', displayName: 'Timestamp'},
      {field: 'keen.created_at', displayName: 'Created At'},
      {field: 'action', displayName: 'Action'},
      {field: 'search_items_count', displayName: 'Search Items Count'},
      {field: 'method', displayName: 'Method'},
      {field: 'user_email', displayName: 'User Email'}
    ]
    enableRowSelection: false
  }

  $scope.runQuery = () ->

    $scope.setClient()

    $scope.getTable()

    Keen.ready ->
      query = new Keen.Query('count', {
        eventCollection: 'ui_actions',
        timeframe: 'this_' + $scope.analyticsHours + '_hours'
        groupBy: 'user_email'
      })

      $scope.client.draw(query, document.getElementById('analytics_chart'), {
        title: 'Ui Actions'
      })


  $scope.getTable = () ->
    query = new Keen.Query('extraction', {
      eventCollection: 'ui_actions'
      timeframe: 'this_' + $scope.analyticsHours + '_hours'
      groupBy: 'user_email'
      action: 'search'
      filters: [
        {
          "property_name": "action"
          "operator": "eq"
          "property_value": "search"
        },
        {
          "property_name": "request_format"
          "operator": "eq"
          "property_value": "json"
        },
        {
          "property_name": "search_items_count"
          "operator": "lt"
          "property_value": $scope.analyticsSearches
        }
      ]
    })

    $scope.client.run(query, (response) ->
      $scope.tableData = response.result
      $scope.updateTable()
      $scope.$apply()
    )

  $scope.updateTable = () ->
    console.log($scope.tableData)

    $scope.searchesTable = {
      data: 'tableData',
      columnDefs: [
        {field: 'search_criteria', displayName: 'Search Criteria'},
        {field: 'keen.timestamp', displayName: 'Timestamp'},
        {field: 'keen.created_at', displayName: 'Created At'},
        {field: 'action', displayName: 'Action'},
        {field: 'search_items_count', displayName: 'Search Items Count'},
        {field: 'method', displayName: 'Method'},
        {field: 'user_email', displayName: 'User Email'}
      ]
      enableRowSelection: false
    }

@SystemAnalyticsCtrl.$inject = ['$scope']