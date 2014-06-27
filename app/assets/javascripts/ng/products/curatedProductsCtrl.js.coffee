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

  $scope.newProduct = { 
    # will be fille out by clearEditForm call
  }

  # will set to index when editing an item
  # the value of index is not used at this time, it works as long as it's >= 0
  $scope.editModeIndex = -1 
  $scope.addingMode = false

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

  $scope.addProduct = () ->
    console.log('switching to adding mode')
    $scope.addingMode = true
    $scope.editModeIndex = -1
    clearEditForm()

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
    }
    # POST and send a request
    $http.post('/products.json', new_prd).success( (data) ->
      console.log('Successfully created product')
      # use new product ID
      new_prd.id = data.product.id
      new_prd.vendor = { name : $scope.newProduct.theVendor }
      $scope.products.push(new_prd)
      $scope.editModeIndex = -1
      $scope.addingMode = false
      clearEditForm()
    ).error( ->
      console.error('Failed to create product')
    )

  $scope.editProduct = (product_id) ->
    # find the record and switch to edit more
    for p,i in $scope.products
      if p.id == product_id
        $scope.addingMode = false
        $scope.editModeIndex = i
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

        console.log('editing index=' + $scope.editModeIndex + ' name:' + p.name)
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
    }
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
          break
      # switch to non-editing mode
      $scope.editModeIndex = -1
      $scope.addingMode = false
      clearEditForm()
    ).error( ->
      console.error('Failed to update product')
    )

  # Cancel edit and adding modes
  $scope.cancelEditingProduct = () ->
    console.log('cancel editing')
    $scope.editModeIndex = -1
    $scope.addingMode = false

  $scope.removeProduct = (product_id) ->
    $http.delete('/products/' + product_id + '.json', null).success( (data) ->
      console.log('Successfully removed product')
      $scope.editModeIndex = -1
      $scope.addingMode = false
      # find and remove record from internal array
      for p,i in $scope.products
        if p.id == product_id
          $scope.products.splice(i,1)
          break
    ).error( ->
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
