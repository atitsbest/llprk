mongoose = require 'mongoose'
categories = require('../../domain/category')(mongoose)
pictures = require('../../domain/picture')(mongoose)
products = require('../../domain/product')(mongoose)
should = require 'should'
#mongoose.createconnect 'mongodb://localhost/llprk_test'

describe 'Product', ->
  # Das Produkt in der DB.
  currentProduct = null
  currentCategory = null
  currentImage = null

  beforeEach (done) ->
    products.model.remove {}, ->
      categories.model.remove {}, ->
        categories.insert 'n', 'dt', (c) ->
          currentCategory = c
          products.insert 'test', 'blahh', 9.99, c._id, (p) ->
            currentProduct = p
            done()
        , (e) -> throw e

  afterEach (done)->
    products.model.remove {}, ->
      categories.model.remove {}, -> done()
  

  it 'lists all products', (done)->
    products.findAll (ps) ->
      ps.length.should.equal(1)
      done()

  it 'gets products by id', (done) ->
    products.findById currentProduct._id, (p) ->
      should.exist(p)
      done()

  it 'increments the viewcount by one', (done) ->
    oldCount = currentProduct.viewcount
    products.incViewcount currentProduct._id, ->
      products.findById currentProduct._id, (p) ->
        p.viewcount.should.equal(oldCount + 1)
        done()

  describe 'Insert', ->
    it 'inserts new products', (done) ->
      products.insert 'name1', 'blahh1', 12.95, currentCategory, (p)->
        should.exist p
        p.name.should.equal 'name1'
        p.category.name.should.equal 'n'
        products.findAll (ps) ->
          ps.length.should.equal(2)
          done()
      , (e) -> throw e

    it 'needs a name', (done) ->
      products.insert null, 'blah1', 1.99, currentCategory,
        (p) -> throw new Error "Success Funktion triggerd."
      , (err) -> done()
      
    it 'needs a price', (done) ->
      products.insert 'name', 'blah1', -1, currentCategory,
        (p) -> throw new Error "Success Funktion triggerd."
      , (err) -> done()

    it 'needs a category', (done) ->
      products.insert 'name', 'blah1', 0.99, null,
        (p) -> throw new Error "Success Funktion triggerd."
      , (err) -> done()

    
