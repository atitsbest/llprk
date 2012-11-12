'use strict';

/* Controllers */

angular.module 'app.controllers', []
  .controller 'ProductsCtrl', ($scope) ->
    $scope.products = [1,2,3,4]

  .controller 'MyCtrl2', ->

  .controller 'ProductNewCtrl' ($scope) ->
    $scope.headerText = -> 'Produkt'

