'use strict';

angular.module('app.services', ['ngResource'])
  .value('version', '0.1')
  .factory('Product', function($resource) {
    return $resource(
      'http://localhost:port/products/:id', {port: ':3321'});
  });
