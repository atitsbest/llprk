(function(){
  'use strict';
  angular.module('AdminApp', ['app.filters', 'app.services', 'app.directives', 'app.controllers']).config(['$routeProvider'].concat(function($routeProvider){
    return $routeProvider.when('/products', {
      templateUrl: 'partials/admin/products/list.html',
      controller: 'ProductsCtrl'
    }).when('/products/:id', {
      templateUrl: 'partials/admin/products/form.html',
      controller: 'ProductsCtrl'
    }).when('/products/new', {
      templateUrl: 'partials/admin/products/form.html',
      controller: 'ProductNewCtrl'
    }).when('/view2', {
      templateUrl: 'partials/partial2.html',
      controller: 'MyCtrl2'
    }).otherwise({
      redirectTo: '/view1'
    });
  }));
  angular.module('ShopApp', ['app.controllers']).config(['$routeProvider'].concat(function($routeProvider){})).otherwise({
    redirectTo: '/'
  });
}).call(this);
