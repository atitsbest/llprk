(function(){
  'use strict';
  var ProductsCtrl, ProductNewCtrl, ProductEditCtrl, CategoriesCtrl;
  angular.module('AdminApp', ['dal']).config(function($routeProvider){
    return $routeProvider.when('/products', {
      templateUrl: 'partials/admin/products/list.html',
      controller: ProductsCtrl
    }).when('/products/new', {
      templateUrl: 'partials/admin/products/form.html',
      controller: ProductNewCtrl
    }).when('/products/:productId', {
      templateUrl: 'partials/admin/products/form.html',
      controller: ProductEditCtrl
    }).when('/categories', {
      templateUrl: 'partials/admin/categories.html',
      controller: CategoriesCtrl
    }).otherwise({
      redirectTo: '/products'
    });
  });
  angular.module('ShopApp', []).config(function($routeProvider){});
  angular.module('dal', ['ngResource']).factory('Product', function($resource){
    return $resource('/api/products/:id', {}, {
      update: {
        method: 'PUT'
      }
    });
  }).factory('Category', function($resource){
    return $resource('/api/categories/:id', {}, {
      update: {
        method: 'PUT'
      }
    });
  });
  ProductsCtrl = function($scope, Product){
    return $scope.products = Product.query();
  };
  ProductNewCtrl = function($scope, Product, Category){
    $scope.categories = Category.query();
    return $scope.save = function(){
      $scope.product.category = $scope.product.category._id;
      return Product.save($scope.product, function(){
        return alert('Gespeichert!');
      });
    };
  };
  ProductEditCtrl = function($scope, $routeParams, Product, Category){
    $scope.product = Product.query({
      id: $routeParams.productId
    });
    return $scope.categories = Category.query();
  };
  CategoriesCtrl = function($scope, Category){
    $scope.categories = Category.query();
    return $scope.insert = function(){
      return Category.save({
        name: $scope['new'].name
      }, function(category){
        $scope['new'].name = '';
        return $scope.categories = Category.query();
      });
    };
  };
}).call(this);
