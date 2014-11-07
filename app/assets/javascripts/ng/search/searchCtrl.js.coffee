EdgeRocket = angular.module('EdgeRocket', ['ui.bootstrap'])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

@SearchCtrl = ($scope, $http, $modal, $log, $filter) ->

  DISPLAY_ITEMS = 50 # keep in sync with back end controller
  $scope.items = []
  # for media type checkboxes
  $scope.mediaCheckboxes = [
    { class : 'check', label : 'Courses', media_type : 'online' }
    { class : 'check', label : 'Books', media_type : 'book' }
    { class : 'check', label : 'Articles', media_type : 'blog' }
    { class : 'check', label : 'Videos', media_type : 'video' }
  ]
  $scope.mediaAllSelected = true # all selected initially
  # for price type checkboxes
  $scope.priceCheckboxes = [
    { class : 'check', label : 'Free', price_type : '0' }
    { class : 'check', label : '< $50', price_type : 'lt50' }
    { class : 'check', label : '$50+', price_type : 'gte50' }
  ]
  $scope.priceAllSelected = true # all selected initially
  # for provider checkboxes
  $scope.providerCheckboxes = [] # will populate from vendors
  $scope.providerAllSelected = true # all selected initially
  $scope.vendors = null # list of vendors retrieved from DB
  # pagination & search state
  $scope.limitItems = DISPLAY_ITEMS
  $scope.totalItems = 0
  $scope.currentPage = 1
  $scope.searchLabel = 'Loading...'
  $scope.advancedSearch = false
  $scope.searchText = ''

  loadCoursePages = (page_number, parameterQuery) ->
    index_start = (page_number-1) * DISPLAY_ITEMS
    index_end = (page_number * DISPLAY_ITEMS) - 1
    range_page = index_start + '-' + index_end
    the_url = '/search.json'
    if parameterQuery != null
      the_url += parameterQuery
    $http.get(the_url, headers: {'Range': range_page, 'Range-Unit': 'items'} ).success( (data, status, headers, config) ->
      # the server may return literal null
      if data != 'null' && data != ''
        # Content-Range is provided in the header in the form 1-20/189, where 189 is the total number of items
        content_range = headers()['content-range']
        if content_range 
          content_range = content_range.match(/\/([0-9]+)/)
          $scope.totalItems = parseInt(content_range[1], 10)
        else
          $scope.totalItems = 0

        # massage data for displaying
        for item in data
          # add a display rating variable 
          item.display_rating = item.avg_rating * 5
          # add a formatted price 
          item.price_fmt = if item.price > 0 then $filter('currency')(item.price, '$') else 'Free'
        $scope.items = data
      else
        $scope.items = null
        $scope.totalItems = 0
      $scope.searchLabel = 'Search'
      #debugger
      console.log('Successfully loaded search data')
    ).error( ->
      console.log('Error loading search data')
    )

  # Builds a search filter to pass to the server
  # null (default) if all media types are enabled
  # otehrwise the format is ?inmedia=v1,v2&search=text
  buildSearchFilter = () ->
    result = null
    if $scope.mediaAllSelected == false
      # note that inmedia parameter may be passed without values
      result = '?inmedia='
      is_first = true
      for cbox in $scope.mediaCheckboxes
        if cbox.class == 'check'
          if is_first == true
            result += cbox.media_type
            is_first = false
          else
            result += ',' + cbox.media_type
    if $scope.priceAllSelected == false
      # note that price parameter may be passed without values
      result = if result==null then '?' else result + '&'
      result += 'price='
      is_first = true
      for cbox in $scope.priceCheckboxes
        if cbox.class == 'check'
          if is_first == true
            result += cbox.price_type
            is_first = false
          else
            result += ',' + cbox.price_type
    if $scope.providerAllSelected == false
      # note that providers parameter may be passed without values
      result = if result==null then '?' else result + '&'
      result += 'providers='
      is_first = true
      for cbox in $scope.providerCheckboxes
        if cbox.class == 'check'
          if is_first == true
            result += cbox.id
            is_first = false
          else
            result += ',' + cbox.id
    if $scope.searchText && $scope.searchText.length > 0
      result = if result==null then '?' else result + '&'
      result += 'criteria=' + encodeURIComponent($scope.searchText)
    result

  loadCourses =  ->
    # load the 1st page of data right away
    loadCoursePages($scope.currentPage, buildSearchFilter())


  loadVendors =  ->
    $http.get('/vendors.json').success( (data) ->
      $scope.vendors = data
      for v in $scope.vendors
        $scope.providerCheckboxes.push({ class: 'check', label: v.name, id: v.id})
      console.log('Successfully loaded vendors')
    ).error( ->
      console.log('Error loading vendors')
    )

  loadCourses()
  loadVendors()

  # Watch search and change search button when changed
  $scope.$watch('searchText', (newVal, oldVal) ->
    $scope.searchLabel = 'Update Results'
  )

  # modal window with course details
  $scope.openModal = (selectedCourse) ->
    $scope.course = selectedCourse
    modalInstance = $modal.open({
      templateUrl: 'searchModalDetails.html',
      controller: ModalInstanceCtrl
      resolve:
        course: () ->
          return $scope.course
    })

    modalInstance.result.then (crs) ->
      console.log('Adding course...' + crs.id)
      # Create data object to POST and send a request
      data =
        course_id: crs.id
        status: 'wish'
        assigned_by: 'Self'
      $http.post('/course_subscription.json', data).success( (data) ->
        console.log('Successfully created subscription')
      ).error( ->
        console.error('Failed to create new subscription')
      )

  # toggle all media type checkboxes, and filter the search result accordingly
  $scope.toggleMediaAll = (turn_on) ->
    if turn_on == false
      $scope.mediaAllSelected = false
      for cb in $scope.mediaCheckboxes
        cb.class = 'unchecked'
    else
      $scope.mediaAllSelected = true
      for cb in $scope.mediaCheckboxes
        cb.class = 'check'
    $scope.searchLabel = 'Update Results'

  # toggle single media type check box
  $scope.toggleMediaCbox = (cbox) ->
    if cbox.class == 'check' 
      $scope.mediaAllSelected = false
      cbox.class = 'unchecked' 
    else
      cbox.class = 'check' 
    $scope.searchLabel = 'Update Results'

  # toggle all price type checkboxes, and filter the search result accordingly
  $scope.togglePriceAll = (turn_on) ->
    if turn_on == false
      $scope.priceAllSelected = false
      for cb in $scope.priceCheckboxes
        cb.class = 'unchecked'
    else
      $scope.priceAllSelected = true
      for cb in $scope.priceCheckboxes
        cb.class = 'check'
    $scope.searchLabel = 'Update Results'

  # toggle single price type check box
  $scope.togglePriceCbox = (cbox) ->
    if cbox.class == 'check' 
      $scope.priceAllSelected = false
      cbox.class = 'unchecked' 
    else
      cbox.class = 'check' 
    $scope.searchLabel = 'Update Results'

  # toggle all provider type checkboxes, and filter the search result accordingly
  $scope.toggleProviderAll = (turn_on) ->
    if turn_on == false
      $scope.providerAllSelected = false
      for cb in $scope.providerCheckboxes
        cb.class = 'unchecked'
    else
      $scope.providerAllSelected = true
      for cb in $scope.providerCheckboxes
        cb.class = 'check'
    $scope.searchLabel = 'Update Results'

  # toggle single provider type check box
  $scope.toggleProviderCbox = (cbox) ->
    if cbox.class == 'check' 
      $scope.providerAllSelected = false
      cbox.class = 'unchecked' 
    else
      cbox.class = 'check' 
    $scope.searchLabel = 'Update Results'
    
  $scope.pageChanged = () ->
    #debugger
    console.log('go to page ' + $scope.currentPage)
    loadCoursePages($scope.currentPage, buildSearchFilter())

  $scope.doSearch = () ->
    $scope.currentPage = 1
    $scope.searchLabel = 'Searching...'
    loadCoursePages($scope.currentPage, buildSearchFilter())

  $scope.toggleSearchMode = () ->
    $scope.advancedSearch = !$scope.advancedSearch

# ------- controller for modal window --------------

@ModalInstanceCtrl = ($scope, $modalInstance, $window, $http, course) ->
  $scope.course = course
  $scope.alerts = []

  $http.get('/products/' + course.id + '.json').success( (data) ->
    $scope.course_description = data.product.description
    console.log('Successfully loaded product details')
  ).error( ->
    console.log('Error loading search product details')
  )

  adminOrAbove = ->
    $scope.user.best_role == 'admin' ||  $scope.user.best_role == 'Sysop' || $scope.user.best_role = 'SA'

  loadUser =  ->
    $http.get('/users/current.json').success( (data) ->
      $scope.user = data
      if adminOrAbove()
        $scope.user.admin_role = true
      console.log('Successfully loaded user')
    ).error( ->
      console.log('Error loading user')
    )

  loadPlaylists =  ->
    $http.get('/user_home.json').success( (data) ->
      $scope.pl_data = data
      console.log('Successfully loaded playlists')
    ).error( ->
      console.log('Error loading playlists')
    )

  loadUser()
  loadPlaylists()

  $scope.enroll = ->
    #alert('enroll')
    $modalInstance.close($scope.course)

  $scope.goto = ->
    $window.open($scope.course.origin)
    $modalInstance.dismiss('goto')

  $scope.cancel = ->
    $modalInstance.dismiss('cancel')

  $scope.addToPlaylist = (course, playlist) ->
    console.log('addToPlaylist course id=' + course.id + ' playlist=' + playlist.title)
    # POST and send a request
    data = {}
    $http.post('/playlists/' + playlist.id + '/courses/' + course.id + '.json', data).success( (data) ->
      console.log('Successfully added to playlist')
      $scope.alerts.push({ 
        type: 'success', 
        msg: '* Added to Playlist' 
      })
    ).error( ->
      console.error('Failed to add to playlist')
    )

@SearchCtrl.$inject = ['$scope', '$http', '$modal', '$log', '$filter']
@ModalInstanceCtrl.$inject = ['$scope', '$modalInstance', '$window', '$http', 'course']
