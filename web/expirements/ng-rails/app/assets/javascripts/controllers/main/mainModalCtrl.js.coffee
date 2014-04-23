@ModalCtrl = ($scope, $modal, $log) ->
  $scope.open = ->
    modalInstance = $modal.open({
      templateUrl: '/myModalContent.html',
      controller: ModalInstanceCtrl
    })

@ModalInstanceCtrl = ($scope, $modalInstance) ->
  #alert($modalInstance)
  $scope.headerText = 'ABC'