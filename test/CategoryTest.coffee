mongoose = require 'mongoose'
categories = require('../domain/category')(mongoose)
should = require 'should'
mongoose.connect 'mongodb://localhost/llprk_test'

describe 'Category', ->
  # Die Kategorie in der DB. 
  current = null

  beforeEach (done) ->
    categories.model.remove {}, ->
      categories.insert 'name', 'blahh balh', (c) ->
        current = c
        done()
      , (e) -> throw e

  afterEach (done)->
    categories.model.remove {}, -> done()
  

  it 'lists all categories', (done)->
    categories.findAll (cs) ->
      cs.length.should.equal(1)
      done()

  it 'gets categories by id', (done) ->
    categories.findById current._id, (c) ->
      should.exist(c)
      done()

  describe 'Insert', ->
    it 'inserts new category', (done) ->
      categories.insert 'name1', 'blahh1', (c)->
        should.exist c
        c.name.should.equal 'name1'
        categories.findAll (cs) ->
          cs.length.should.equal(2)
          done()
      , (e) -> throw e
    
    it 'needs a name', (done) ->
      categories.insert null, 'blah1',
        () -> throw new Error "Success Funktion triggerd."
      , (e) -> done()

    it 'needs a uniqe name', (done) ->
      categories.insert 'name', 'bbbbb',
        (p) -> throw new Error "Success Funktion triggered."
      , (e) -> done()
