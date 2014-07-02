EdgeRocket = angular.module('EdgeRocket', ['ui.bootstrap', 'angularCharts'])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@DashboardCtrl = ($scope, $http, $window) ->

  # CHARTS - activity

  $scope.activityChartData = {
    series : ['Completed', 'In Progress','Assigned'],
    data : [{
      x : "Learning items completed to date",
      y : [],
      tooltip : "Activity"
    }]
  }

  $scope.activityChartType = 'bar'

  $scope.activityConfig = {
    labels: false,
    title : "",
    legend : {
      display:true,
      position:'left'
    }
  }

  # CHARTS - users

  $scope.usersChartData = {
    series: ['Number of Users'],
    data : []
  }

  $scope.usersChartType = 'pie'

  $scope.usersConfig = {
    labels: false,
    title : "",
    legend : {
      display:true,
      position:'left'
    }
  }
  pushActivityValue = (data, state) ->
    y = if data.activityData[state] == null or data.activityData[state] == undefined then 0 else data.activityData[state]
    $scope.activityChartData.data[0].y.push(y)

  loadActivity =  ->
    $http.get('/dashboard.json').success( (data) ->
      pushActivityValue(data, 'compl')
      pushActivityValue(data, 'wip')
      pushActivityValue(data, 'reg')
      for g in data.coursesPerUserData
        piece = { 
          x : g.number_of_courses + ' courses', 
          y : g.number_of_users 
        }
        $scope.usersChartData.data.push(piece) 
      $scope.options_json = angular.fromJson(data.account.options)
      console.log('Successfully loaded dashboards')
     ).error( ->
      console.log('Error loading user_home')
    )

  loadActivity()

  $scope.manageUsers = ->
    $window.location.href = "/employees"

  # CHARTS - topics

  $scope.topicsChartData = {
    series: ['Completed', 'In Progress'],
    data : [{
      x : "Marketing",
      y: [3, 2],
      tooltip:"this is tooltip"
    },
    {
      x : "Coding",
      y: [4, 10]
    },
    {
      x : "Business",
      y: [4, 3]
    },
    {
      x : "Design",
      y: [1, 5]
    },
    {
      x : "Finance",
      y: [2, 1]
    },
    {
      x : "Technical",
      y: [2, 3]
    },
    {
      x : "Other",
      y: [7, 11]
    }]

  }

  $scope.topicsChartType = 'bar'

  $scope.topicsConfig = {
    labels: false,
    title : "",
    legend : {
      display:true,
      position:'left'
    }
  }

  # CHARTS - dept

  $scope.deptChartData = {
    series: ['Completed', 'In Progress'],
    data : [{
      x : "Marketing",
      y: [3, 5],
      tooltip:"this is tooltip"
    },
    {
      x : "Engineering",
      y: [4, 10]
    },
    {
      x : "Support",
      y: [1, 4]
    },
    {
      x : "Sales",
      y: [3, 12]
    },
    {
      x : "Other",
      y: [2, 1]
    }]
  }

  $scope.deptChartType = 'bar'

  $scope.deptConfig = {
    labels: false,
    title : "",
    legend : {
      display:true,
      position:'left'
    }
  }

@DashboardCtrl.$inject = ['$scope', '$http', '$window']
