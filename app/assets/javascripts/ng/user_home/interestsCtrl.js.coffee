@InterestsCtrl = ($scope, $http, $modal, $sce, $window) ->

  $scope.interests = [
    { name : 'Communication Skills', img_url : '/assets/ic_forum_grey600_48dp.png' }
    { name : 'Data Science', img_url : '/assets/ic_storage_grey600_48dp.png' }
    { name : 'Effective Presentations', img_url : '/assets/ic_camera_roll_grey600_48dp.png' }
    { name : 'Finance', img_url : '/assets/ic_account_balance_grey600_48dp.png' }
    { name : 'Leadership & Management', img_url : '/assets/ic_people_grey600_48dp.png' }
    { name : 'Digital Marketing', img_url : '/assets/ic_people_grey600_48dp.png' }
    { name : 'Operations', img_url : '/assets/ic_people_grey600_48dp.png' }
    { name : 'Project Management', img_url : '/assets/ic_people_grey600_48dp.png' }
    { name : 'Sales', img_url : '/assets/ic_people_grey600_48dp.png' }
    { name : 'Software Engineering', img_url : '/assets/ic_people_grey600_48dp.png' }
    { name : 'UX/UI & Design', img_url : '/assets/ic_people_grey600_48dp.png' }
    { name : 'Web Development', img_url : '/assets/ic_people_grey600_48dp.png' }

  ]

@InterestsCtrl.$inject = ['$scope', '$http', '$modal', '$sce', '$window']
