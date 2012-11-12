(function(){
  'use strict';
  /* Controllers */
  angular.module('app.controllers', []).controller('ProductsCtrl', function($scope, Product){
    return $scope.products = Product.query();
  }).controller('MyCtrl2', function(){}).controller('ProductNewCtrl', function($scope){
    return $scope.headerText = function(){
      return 'Produkt';
    };
  });
}).call(this);
