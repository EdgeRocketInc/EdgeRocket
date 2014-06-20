upload = angular.module("EdgeRocket", ['ui.bootstrap'])

# Directive
# ---------
upload.directive "fileChange", ->
  linker = ($scope, element) ->

    # onChange, push the files to $scope.files.
    element.bind "change", (event) ->
      files = event.target.files
      $scope.$apply ->
        i = 0
        length = files.length

        while i < length
          $scope.files.push files[i]
          i++
  restrict: "A"
  link: linker

# Factory
# -------
upload.factory "uploadService", [ "$rootScope", ($rootScope) ->
  send: (file) ->
    reader = undefined
    if typeof FileReader isnt "undefined" and file.type.match "image.*"
      reader = new FileReader()
      reader.onload = (event) ->
        onImageLoaded event, null

    reader.readAsDataURL file
    data = new FormData()
    xhr = new XMLHttpRequest()

    onImageLoaded = (event, li) ->

      dummyImage = document.getElementById("Photo")

      unless dummyImage
        dummyImage = document.createElement("img")
        dummyImage.setAttribute("id", "Photo")
        dummyImage.src = event.target.result
      else
        dummyImage.src = event.target.result

  # When the request starts.
    xhr.onloadstart = ->
      console.log "Factory: upload started: ", file.name
      $rootScope.$emit "upload:loadstart", xhr


    # When the request has failed.
    xhr.onerror = (e) ->
      $rootScope.$emit "upload:error", e


    # Send to server, where we can then access it with $_FILES['file].
    data.append "file", file, file.name
    xhr.open "POST", "upload"
    xhr.send data
]

# Controller
# ----------
upload.controller "UploadCtrl", [ "$scope", "$rootScope", "uploadService","$http", ($scope, $rootScope, uploadService, $http) ->
  # 'files' is an array of JavaScript 'File' objects.
  $scope.files = []
  $scope.$watch "files", ((newValue, oldValue) ->

    # Only act when our property has changed.
    unless newValue is oldValue
      console.log "Controller: $scope.files changed. Start upload."
      length = $scope.files.length

      if length > 0
        # Hand file off to uploadService.
        console.log "=================>", $scope.files[length-1].name
        uploadService.send $scope.files[length-1]
  ), true
  $rootScope.$on "upload:loadstart", ->
    console.log "Controller: on `loadstart`"

  $rootScope.$on "upload:error", ->
    console.log "Controller: on `error`"
]
