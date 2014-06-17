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
    fileList = document.getElementById("file-list")
    li = document.createElement("div")
    div = document.createElement("div")
    reader = undefined
    if typeof FileReader isnt "undefined" and file.type.match "image.*"
      reader = new FileReader()
      reader.onload = (event) ->
        onImageLoaded event, li

    reader.readAsDataURL file
    fileList.appendChild li
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

      MAX_WIDTH = 200
      MAX_HEIGHT = 150
      tempW = dummyImage.width
      tempH = dummyImage.height
      if tempW > tempH
        if tempW > MAX_WIDTH
          tempH = tempH*MAX_WIDTH / tempW
          tempW = MAX_WIDTH
        else
          if tempH > MAX_HEIGHT
            tempW = tempW*MAX_HEIGHT / tempH
            tempH = MAX_HEIGHT

      console.log "Width: ", tempW
      console.log "Height: ", tempH

      dummyImage.width=tempW
      dummyImage.height=tempH
      li.appendChild dummyImage


  # When the request starts.
    xhr.onloadstart = ->
      console.log "Factory: upload started: ", file.name
      $rootScope.$emit "upload:loadstart", xhr


    # When the request has failed.
    xhr.onerror = (e) ->
      $rootScope.$emit "upload:error", e


    # Send to server, where we can then access it with $_FILES['file].
    data.append "file", file, file.name
    xhr.open "POST", "profile/upload"
    xhr.send data
]

# Controller
# ----------
upload.controller "ProfileCtrl", [ "$scope", "$rootScope", "uploadService","$http", ($scope, $rootScope, uploadService, $http) ->
  loadData =  ->
  $http.get('/users/current.json').success( (data) ->
    $scope.user = data
    console.log('Original User'+$scope.user.id)

    if $scope.user.best_role == 'admin' ||  $scope.user.best_role == 'SA'
      $scope.user.admin_role = true
    console.log('Successfully loaded user')
   ).error( ->
    console.log('Error loading user')
    )

  console.log('Data'+$scope.user)

  $http.get('/profile/' + $scope.user.id + '.json').success( (data) ->
    $scope.profile = data
    console.log('Successfully loaded profile')
  ).error( ->
    console.log('Error loading profile')
  )

  loadData()

  $scope.updateProfile = (user, profile) ->
    updated_u = {
      first_name : user.first_name,
      last_name : user.last_name
    }
    console.log('Updating:' + updated_u.first_name+','+updated_u.last_name)
    # POST and send a request
    $http.put('/employees/' + user.id + '.json', updated_u).success( (data) ->
      console.log('Successfully updated user')
      # switch to non-editing mode
    ).error( ->
      console.error('Failed to update user')
    )

    console.log('Creating/Updating profile:' + $scope.profile.title)
    new_p = {
      title : $scope.profile.title,
      employee_id : $scope.profile.employee_id,
      user_id : user.id
    }
    # POST and send a request
    $http.post('/profile.json', new_p).success( (data) ->
      console.log('Successfully created profile')
      # use new user ID
    ).error( ->
      console.error('Failed to createe/update profile')
    )

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
