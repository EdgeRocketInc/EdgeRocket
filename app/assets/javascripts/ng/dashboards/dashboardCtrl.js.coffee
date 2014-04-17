EdgeRocket = angular.module('EdgeRocket', ['angularCharts'])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@DashboardCtrl = ($scope, $http) ->

  # CHARTS

  $scope.chartData = {
    series: ['Completed', 'In Progress'],
    data : [{
      x : "Jan",
      y: [3, 5],
      tooltip:"this is tooltip"
    },
    {
      x : "Feb",
      y: [4, 10]
    },
    {
      x : "Mar",
      y: [2, 11]
    },
    {
      x : "Apr",
      y: [2, 1]
    }]     
  }

  $scope.chartType = 'bar'

  $scope.config = {
    labels: false,
    title : "",
    legend : {
      display:true,
      position:'left'
    }
  }

  $scope.config1 = {
    labels: false,
    title : "Products",
    legend : {
      display:true,
      position:'right'
    }
  }

@DashboardCtrl.$inject = ['$scope', '$http']
