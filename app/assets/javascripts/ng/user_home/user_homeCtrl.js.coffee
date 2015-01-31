@IndexCtrl = ($scope, $http, $modal, $sce, $window, $filter) ->

  $scope.search = { text : '' }
  $scope.courseMessageDismissed = false # will be true when message is dismissed
  $scope.theRows = [] # a range of rows such as 0..3
  $scope.courses = [] # master array of courses
  $scope.myCourses = [] # a filtered copy of master array of courses
  $scope.showCourses = 'all' # course status filter
  $scope.showPlaylist = null # show courses in playlist only
  $scope.requiredOnly = false # show required courses only
  # playlists
  $scope.myPlaylists = []
  $scope.subsciptionsEditMode = false
  $scope.checkedPlaylistsCount = 0 # count of checked playslits in subscribtion panel
  # interests
  $scope.myInterests = []
  $scope.interestsEditMode = false
  $scope.checkedInterestsCount = 0 # count of checked playslits in subscribtion panel

  loadUser =  ->
    $http.get('/users/current.json').success( (data) ->
      $scope.user = data
      console.log('Successfully loaded user')
      # check if the option is enabled and it's the first login
      $scope.options_json = angular.fromJson($scope.user.account.options)
      loadSkills()
    ).error( ->
      console.log('Error loading user')
    )

  # return true if course c is in playlist p
  isCourseInPlaylist = (c,p) ->
    if c==null || p==null
      # for safety 
      return true
    else
      # short, but probably not the most efficient
      result = (item for item in p.playlist_items when item.product_id is c.product_id)
      return result.length > 0

  # add media type glyph and text to the course object
  addViewAttributes = (crs) ->
    mediaTypes = {
      'video': {
        'glyph' : 'glyphicon-facetime-video',
        'text' : 'Video'
      }
      'online': {
        'glyph' : 'glyphicon-cloud',
        'text' : 'Online Course'
      }
      'book': {
        'glyph' : 'glyphicon-book',
        'text' : 'Book'
      }
      'blog': {
        'glyph' : 'glyphicon-bookmark',
        'text' : 'Article'
      }
    }
    crs.mediaType = mediaTypes[crs.product.media_type]
    crs.price_fmt = if crs.product.price > 0 then $filter('currency')(crs.product.price, '$') else 'Free'
    crs.css_elevate = 'md-whiteframe-z1'

  # if a parameter is null, it means use currently stored value 
  applyFilters = (includeStatus, playlist) ->
    console.log('Apply Filters')    
    apply_status = if includeStatus==null then $scope.showCourses else includeStatus
    apply_playlist = if playlist==null then $scope.showPlaylist else playlist
    $scope.myCourses = []
    for crs in $scope.courses
      if $scope.requiredOnly==false || ($scope.requiredOnly==true && crs.assigned_by=='Manager')
        if (apply_status=='all' || crs.status==apply_status) && (apply_playlist==null || isCourseInPlaylist(crs,apply_playlist))
          if crs.assigned_by=='Manager'
            crs.css_header='tile-required'
          else if crs.status=='compl'
            crs.css_header='tile-completed'
          else 
            crs.css_header=null
          addViewAttributes(crs)
          $scope.myCourses.push(crs)
    # TODO: number of columns should be a const
    num_rows = Math.ceil($scope.myCourses.length / 3) 
    $scope.theRows = [0..num_rows-1]
    $scope.showCourses = apply_status
    $scope.showPlaylist = apply_playlist 

  $scope.filterMyCourses = (includeStatus) ->
    applyFilters(includeStatus, null)

  loadMyCourses =  ->
    $http.get('/my_courses/flat.json').success( (data) ->
      $scope.courses = data.courses
      $scope.filterMyCourses('all')
      console.log('Successfully loaded courses')
    ).error( ->
      console.log('Error loading courses')
    )

  loadMyPlaylists =  ->
    $http.get('/user_playlists.json').success( (data) ->
      $scope.myPlaylists = data.playlists
      for pl in $scope.myPlaylists
        pl.subscribed = if data.subscribed_playlists[pl.id]==true then true else false
      console.log('Successfully loaded playlists')
    ).error( ->
      console.log('Error loading playlists')
    )

  loadSkills = ->
    $http.get('/surveys/skills.json').success( (data) ->
      $scope.myInterests = data.skills
      current_skills = []
      if !!$scope.user.user_preferences
        user_skills = angular.fromJson($scope.user.user_preferences).skills
        if user_skills && user_skills!=null
          current_skills = user_skills
      for skill in $scope.myInterests
        result = (item for item in current_skills when item.id is skill.key_name)
        if result && result.length > 0
          # should always be true, but this is for sanity
          skill.subscribed = (result[0].id==skill.key_name)
        else
          skill.subscribed = false
      console.log('Successfully loaded skills')
    ).error( ->
      console.log('Error loading skills')
    )

  loadUser()
  loadMyCourses()
  loadMyPlaylists()

  $scope.dismissNewCourseMessage = ->
    # reset the user flag
    $http.patch('/employees/' + $scope.user.id + '/field.json', null).success( (data) ->
      console.log('Successfully reset new courses')
    ).error( ->
      console.error('Failed to reset new courses')
    )
    # change client side flag anyway
    $scope.courseMessageDismissed = true

  $scope.tileHeaderClick = (course) ->
    course.tileDetail = !course.tileDetail
    course.css_elevate = if course.tileDetail==true then 'md-whiteframe-z2' else 'md-whiteframe-z1'

  $scope.changeStatus = (course, newStatus) ->
    # Create data object to PUT and send a request
    data =
      status: newStatus
    $http.put('/course_subscription/' + course.id + '.json', data).success( (result_data) ->
      course.status = newStatus
      course.needRefresh = true
      console.log('Successfully updated subscription')
    ).error( ->
      console.error('Failed to update subscription')
    )

  $scope.reloadCards = (course) ->
    course.needRefresh = false
    loadMyCourses()

  $scope.clickRequiredOnly = ->
    loadMyCourses()

  $scope.onHeaderEnter = (course) ->
    #console.log('hover enter')
    course.css_hover = 'tile-hover'

  $scope.onHeaderLeave = (course) ->
    course.css_hover = ''
    #console.log('hover exit')

  # --- PLAYLIST SUBSCRIPTIONS

  deleteSubscription = (playlist) ->
    $http.delete('/playlist_subscription/' + playlist.id + '/' + playlist.cascadeDelete + '.json').success( (data) ->
      if playlist.cascadeDelete==true
        # reload courses if cascade delete was used
        loadMyCourses()
      playlist.subscribed = false
      console.log('Successfully unsubscribed to playlist')
    ).error( ->
      console.error('Failed to unsubscribe to playlist')
    )
    return true

  createSubscription = (playlists, doneCallback) ->
    # Create data object to POST and send a request
    data = 
      playlist_ids: []

    for pl in playlists
      if pl.checked == true
        data.playlist_ids.push(pl.id)

    $http.post('/playlist_subscription.json', data).success( (data) ->
      console.log('Successfully subscribed to playlists')
      # mark playlists as subscribed
      for pl in playlists
        if pl.checked == true
          pl.subscribed = true
      doneCallback()
    ).error( ->
      console.error('Failed to subscribe to playlists')
    )
    return true

  $scope.editSubscriptions = ->
    for pl in $scope.myPlaylists
      pl.checked = false
    $scope.checkedPlaylistsCount = 0
    $scope.subsciptionsEditMode = true

  $scope.doneSubscriptions = ->
    # open modal prompt
    promptModalInstance = $modal.open({
      templateUrl: 'subscribePromptModal.html'
      controller: plSubscribeModalCtrl
      resolve:
        subscribePlaylists: () ->
          return $scope.myPlaylists
    })
    promptModalInstance.result.then (plSub) ->
      #debugger
      createSubscription(plSub, doneCallback = ->
        #console.log('cancel edit mode')
        $scope.subsciptionsEditMode = false
        # reload courses because they might have changed
        loadMyCourses()
        loadUser()
      )

  $scope.cancelEditSubscriptions = ->
     $scope.subsciptionsEditMode = false

  $scope.playlistUnsubscribe = (playlist) ->
    # open modal prompt
    promptModalInstance = $modal.open({
      templateUrl: 'unsubPromptModal.html'
      controller: plUnsubModalCtrl
      resolve:
        pl: () ->
          return playlist
    })
    #debugger
    promptModalInstance.result.then (plUnsub) ->
      console.log('prompt ' + plUnsub.id + ', cascade ' + plUnsub.cascadeDelete )
      deleteSubscription(plUnsub)

  $scope.clickSubscribe = (pl) ->
    if pl.checked == true
      $scope.checkedPlaylistsCount = if $scope.checkedPlaylistsCount > 0 then $scope.checkedPlaylistsCount-1 else 0
    else
      $scope.checkedPlaylistsCount = $scope.checkedPlaylistsCount+1

  $scope.clickPlaylist = (pl) ->
    if $scope.showPlaylist==null
      # no playlits filter yet, set it
      pl.css_class = 'list-on'
    else if $scope.showPlaylist == pl
      # the same playlist is clicked, then deselect
      pl.css_class = ''
      pl = null
      $scope.showPlaylist = null
    else
      # new playlist filter
      $scope.showPlaylist.css_class = ''
      pl.css_class = 'list-on'
    # filter courses to show this playlist's content only
    applyFilters(null, pl)

  # --- INTERESTS

  $scope.editInterests = ->
    for skill in $scope.myInterests
      skill.checked = false
    $scope.checkedInterestsCount = 0
    $scope.interestsEditMode = true

  $scope.doneInterests = ->
    data = { skills: [] }
    for skill in $scope.myInterests
      # sending new and resending existing skills
      if skill.checked==true || skill.subscribed==true
        #console.log('skill ' + skill.id )
        data.skills.push( { id: skill.key_name } )
    if data.skills.length > 0 
      # Update preferences/survey
      $http.patch('/users/preferences.json', data).success( (data) ->
        console.log('Successfully set preferences')
        # mark interests as subscribed
        for skill in $scope.myInterests
          if skill.checked == true
            skill.subscribed = true
        loadUser()
        loadMyCourses()
        $scope.interestsEditMode = false
      ).error( ->
        console.error('Failed to set preferences')
      )

  $scope.cancelEditInterests = ->
     $scope.interestsEditMode = false

  $scope.clickSkill = (skill) ->
    if skill.checked == true
      $scope.checkedInterestsCount = if $scope.checkedInterestsCount > 0 then $scope.checkedInterestsCount-1 else 0
    else
      $scope.checkedInterestsCount = $scope.checkedInterestsCount+1

  $scope.interestUnsubscribe = (skillToRemove) ->
    skillToRemove.subscribed = false    
    skillToRemove.checked = false
    data = { skills: [] }
    for skill in $scope.myInterests
      # resending existing skills
      if skill.checked==true || skill.subscribed==true
        data.skills.push( { id: skill.key_name } )
    # Update preferences/survey
    $http.patch('/users/preferences.json', data).success( (data) ->
      console.log('Successfully set preferences')
      loadUser()
      loadMyCourses()
    ).error( ->
      console.error('Failed to set preferences')
    )

# --- controller for modal window
@plUnsubModalCtrl = ($scope, $modalInstance, $window, $http, pl) ->
  console.log('modal unsub prompt ctrl')
  #debugger
  $scope.thePlaylist = pl
  $scope.thePlaylist.cascadeDelete = false # cascade delete courses in the playlist

  $scope.proceed = () ->
    console.log('modal unsub proceed')
    $modalInstance.close($scope.thePlaylist)

  $scope.cancel = ->
    console.log('modal unsub cancel')
    $modalInstance.dismiss('cancel')

# --- controller for modal window
@plSubscribeModalCtrl = ($scope, $modalInstance, $window, $http, subscribePlaylists) ->
  console.log('modal sub prompt ctrl')
  #debugger
  $scope.thePlaylists = subscribePlaylists

  $scope.proceed = () ->
    $modalInstance.close($scope.thePlaylists)

  $scope.cancel = ->
    $modalInstance.dismiss('cancel')

@IndexCtrl.$inject = ['$scope', '$http', '$modal', '$sce', '$window', '$filter']
@plUnsubModalCtrl.$inject = ['$scope', '$modalInstance', '$window', '$http', 'pl']
@plSubscribeModalCtrl.$inject = ['$scope', '$modalInstance', '$window', '$http', 'subscribePlaylists']
