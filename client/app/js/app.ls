'use strict';

# Declare app level module which depends on filters, and services
angular.module 'AdminApp', <[dal]>
  .config ($routeProvider)->
    $routeProvider
      .when '/products',
        templateUrl: 'partials/admin/products/list.html'
        controller: ProductsCtrl
      .when '/products/new',
        templateUrl: 'partials/admin/products/form.html'
        controller: ProductNewCtrl
      .when '/products/:productId',
        templateUrl: 'partials/admin/products/form.html'
        controller: ProductEditCtrl
      .when '/categories',
        templateUrl: 'partials/admin/categories.html'
        controller: CategoriesCtrl
      .otherwise redirectTo: '/products'


angular.module 'ShopApp', <[]>
  .config ($routeProvider) ->

angular.module 'dal', <[ngResource]>
  .factory 'Product', ($resource) ->
    $resource '/api/products/:id', {}, {update: {method: 'PUT' }}
  .factory 'Category', ($resource) ->
    $resource '/api/categories/:id', {}, {update: {method: 'PUT' }}


ProductsCtrl = ($scope, Product) ->
  $scope.products = Product.query!


ProductNewCtrl = ($scope, Product, Category) ->
  $scope.categories = Category.query!

  $scope.save = ->
    $scope.product.category = $scope.product.category._id
    Product.save $scope.product, ->
      alert 'Gespeichert!'


ProductEditCtrl = ($scope, $routeParams, Product, Category) ->
  $scope.product = Product.query {id: $routeParams.productId}
  $scope.categories = Category.query!


CategoriesCtrl = ($scope, Category) ->
  $scope.categories = Category.query!

  $scope.insert = ->
    Category.save {name: $scope.new.name}, (category) ->
      $scope.new.name = ''
      $scope.categories = Category.query!
