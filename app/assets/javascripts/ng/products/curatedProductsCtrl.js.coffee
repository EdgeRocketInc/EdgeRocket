EdgeRocket = angular.module('EdgeRocket', ['ui.bootstrap', 'ngGrid'])

EdgeRocket.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

# This controller is for managing curated (manually entered) products 
@CuratedProductsCtrl = ($scope, $http, $modal, $log) ->

  $scope.mediaTypes = [
    { value : 'blog', name : 'Article' }
    { value : 'book', name : 'Book' }
    { value : 'online', name : 'Online Course' }
    { value : 'video', name : 'Video' }
  ]
  # Accounts 
  $scope.allAccounts = [ ]

  $scope.newProduct = { 
    # will be filled out by clearEditForm call
  }

  # will set to index when editing an item
  # the value of index is not used at this time, it works as long as it's >= 0
  $scope.uiMode = { adding : false, editIndex : -1 }

  $scope.gridOptions = { 
    data : 'products',
    multiSelect : false,
    enableRowSelection: false,
    columnDefs : [
      { field : 'name', displayName : 'Item/Course Title'}, 
      { field : 'vendor.name', displayName : 'Provider', width : '20%', }, 
      { field : 'id', displayName : 'Edit', width : '8%', minWidth : '80', cellTemplate: 'cellActions.html' }
    ]
  }  

  $scope.serverError = null

  clearEditForm = ->
    $scope.newProduct.name = null
    $scope.newProduct.description = null
    $scope.newProduct.theVendor = null
    $scope.newProduct.authors = null
    $scope.newProduct.origin = null
    $scope.newProduct.price = null
    $scope.newProduct.price_free_class = 'unchecked'
    $scope.newProduct.keywords = null
    $scope.newProduct.school = null
    $scope.newProduct.theMediaType = null
    $scope.newProduct.theDuration = { hours : null, minutes : null }
    $scope.newProduct.thePlaylists = []
    $scope.newProduct.theAccount = []
    $scope.allAccounts = []
    $scope.serverError = null

  loadVendors =  ->
    $http.get('/vendors.json').success( (data) ->
      $scope.vendors = data
      console.log('Successfully loaded vendors')
    ).error( ->
      console.log('Error loading vendors')
    )

  loadProducts =  ->
    $http.get('/products/curated.json').success( (data) ->
      $scope.products = data
      console.log('Successfully loaded products')
      loadVendors()
    ).error( ->
      console.log('Error loading products')
    )

  loadPlaylists =  ->
    $http.get('/playlists.json').success( (data) ->
      $scope.allPlaylists = data
      console.log('Successfully loaded playlists')
    ).error( ->
      console.log('Error loading playlists')
    )

  loadUser =  ->
    $http.get('/users/current.json').success( (data) ->
      $scope.user = data
      console.log('Successfully loaded user')
    ).error( ->
      console.log('Error loading user')
    )

  # return viendor id based on the passed name
  findVendorId = (vendor_name) ->
    for v in $scope.vendors
      if v.name == vendor_name
        return v.id

  # converst duration display object to hours with fractions
  # will return null if hh==mm==0
  toDurationHours = (duration_obj) ->
    hours = null
    if duration_obj.hours > 0 || duration_obj.minutes > 0
      hours = if duration_obj.hours then duration_obj.hours else 0 
      hours += if duration_obj.minutes then (duration_obj.minutes / 60) else 0
    return hours

  # convert duration in hours with fraction to an object wtih hours and minutes
  toDurationObject = (duration_hours) ->
    hh = null
    mm = null   
    if duration_hours
      hh = Math.floor(duration_hours)
      mm = (duration_hours - hh) * 60
      mm = Math.round(mm)
    duration_obj = { hours : hh, minutes : mm }

  clearEditForm()
  loadProducts()
  loadPlaylists()
  loadUser()

  $scope.addProduct = () ->
    console.log('switching to adding mode')
    $scope.uiMode = { adding : true, editIndex : -1 }
    clearEditForm()
    # use the current user's account by default
    $scope.newProduct.theAccount = $scope.user.account
    # Include the Sysop's account in the list by default
    if $scope.user.best_role == 'sysop'
      $scope.allAccounts.push( $scope.user.account )

  # Add selected playlists to the array of playlist items
  addProductToPlaylist = (pl_items, selected_playlists) ->
    for pl in selected_playlists
      new_item = { playlist_id : pl.id }
      pl_items.push(new_item)

  $scope.createProduct = () ->
    console.log('Creating:' + $scope.newProduct.name)
    new_prd = { 
      id : null, 
      name : $scope.newProduct.name, 
      description : $scope.newProduct.description 
      vendor_id : findVendorId($scope.newProduct.theVendor)
      authors : $scope.newProduct.authors
      origin : $scope.newProduct.origin
      price : $scope.newProduct.price
      price_free : $scope.newProduct.price_free_class == 'check'
      keywords : $scope.newProduct.keywords
      school : $scope.newProduct.school
      media_type : if $scope.newProduct.theMediaType then $scope.newProduct.theMediaType.value else null
      duration : toDurationHours($scope.newProduct.theDuration)
      manual_entry : true
      playlist_items : [] # will populate below
      account_id : if $scope.newProduct.theAccount then $scope.newProduct.theAccount.id else null
    }
    addProductToPlaylist(new_prd.playlist_items, $scope.newProduct.thePlaylists)
    # POST and send a request
    $http.post('/products.json', new_prd).success( (data) ->
      console.log('Successfully created product')
      # use new product ID
      new_prd.id = data.product.id
      new_prd.vendor = { name : $scope.newProduct.theVendor }
      new_prd.account = $scope.newProduct.theAccount
      $scope.products.push(new_prd)
      $scope.uiMode = { adding : false, editIndex : -1 }
      clearEditForm()
    ).error( ->
      console.error('Failed to create product')
    )

  $scope.editProduct = (product_id) ->
    #debugger
    clearEditForm()    
    # find the record and switch to edit more
    for p,i in $scope.products
      if p.id == product_id
        $scope.uiMode = { adding : false, editIndex : i }
        $scope.newProduct.id = product_id
        $scope.newProduct.name = p.name
        $scope.newProduct.description = p.description
        $scope.newProduct.authors = p.authors
        $scope.newProduct.origin = p.origin
        $scope.newProduct.price = p.price
        $scope.newProduct.price_free_class = if p.price_free == true then 'check' else 'unchecked'
        $scope.newProduct.keywords = p.keywords
        $scope.newProduct.school = p.school
        $scope.newProduct.theDuration = toDurationObject(p.duration)

        # select the vendor
        $scope.newProduct.theVendor = if p.vendor then p.vendor.name else null

        # select the media_type
        $scope.newProduct.theMediaType = null
        for mt in $scope.mediaTypes
          if p.media_type == mt.value
            $scope.newProduct.theMediaType = mt
            break

        # select the playlists in which it's included
        if p.playlist_items != null && p.playlist_items != undefined
          for pl in $scope.allPlaylists
            for pl_item in p.playlist_items
              if pl_item.playlist_id == pl.id
                $scope.newProduct.thePlaylists.push(pl)

        # If sysop mode, deal with the product scope
        if $scope.user.best_role == 'sysop' 
          if p.account_id != null
            # if it belongs to a company add add that company and select it
            $scope.allAccounts.push(p.account)
            $scope.newProduct.theAccount = p.account
          else
            # if it's global (no company), add the current company, and select global
            $scope.allAccounts.push( $scope.user.account )
            $scope.newProduct.theAccount = null

        console.log('editing index=' + $scope.uiMode.editIndex + ' name:' + p.name)
        break

  # Update the product in DB and UI
  $scope.updateProduct = () ->
    # convert display structure to API payload
    updated_item = { 
      id : $scope.newProduct.id
      name : $scope.newProduct.name, 
      description : $scope.newProduct.description, 
      name : $scope.newProduct.name, 
      description : $scope.newProduct.description 
      vendor_id : findVendorId($scope.newProduct.theVendor)
      authors : $scope.newProduct.authors
      origin : $scope.newProduct.origin
      price : $scope.newProduct.price
      price_free : $scope.newProduct.price_free_class == 'check'
      keywords : $scope.newProduct.keywords
      school : $scope.newProduct.school
      media_type : if $scope.newProduct.theMediaType then $scope.newProduct.theMediaType.value else null
      duration : toDurationHours($scope.newProduct.theDuration)
      manual_entry : true
      playlist_items : [] # will populate below
      account_id : if $scope.newProduct.theAccount then $scope.newProduct.theAccount.id else null
    }
    addProductToPlaylist(updated_item.playlist_items, $scope.newProduct.thePlaylists)
    console.log('Updating: ' + updated_item.name)
    # POST and send a request
    $http.put('/products/' + updated_item.id + '.json', updated_item).success( (data) ->
      console.log('Successfully updated product')
      # find the product record and update it
      for p,i in $scope.products
        if p.id == updated_item.id
          p.name = updated_item.name
          p.description = updated_item.description
          p.vendor_id = updated_item.vendor_id
          p.vendor = { name : $scope.newProduct.theVendor }
          p.authors = updated_item.authors
          p.origin = updated_item.origin
          p.price = updated_item.price
          p.price_free = updated_item.price_free
          p.keywords = updated_item.keywords
          p.school = updated_item.school
          p.media_type = updated_item.media_type
          p.duration = updated_item.duration
          p.playlist_items = updated_item.playlist_items
          p.account_id = updated_item.account_id
          break
      # switch to non-editing mode
      $scope.uiMode = { adding : false, editIndex : -1 }
      clearEditForm()
    ).error( ->
      console.error('Failed to update product')
    )

  # Cancel edit and adding modes
  $scope.cancelEditingProduct = () ->
    console.log('cancel editing')
    $scope.uiMode = { adding : false, editIndex : -1 }

  $scope.removeProduct = (product_id) ->
    $http.delete('/products/' + product_id + '.json', null).success( (data) ->
      $scope.uiMode = { adding : false, editIndex : -1 }
      # find and remove record from internal array
      for p,i in $scope.products
        if p.id == product_id
          $scope.products.splice(i,1)
          break
      $scope.serverError = null
      console.log('Successfully removed product')
    ).error( ->
      $scope.serverError = 'Failed to remove an item because it is included in Playlists'
      console.error('Failed to remove product')
    )


  $scope.togglePriceFree = () ->
    if $scope.newProduct.price_free_class == 'check'
      $scope.newProduct.price_free_class = 'unchecked'
      $scope.newProduct.price_free = false
    else
      $scope.newProduct.price_free_class = 'check'
      $scope.newProduct.price_free = true

@CuratedProductsCtrl.$inject = ['$scope', '$http', '$modal', '$log']
