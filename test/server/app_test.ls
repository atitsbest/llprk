require! {
  should
  sinon
  mongoose
  request: 'supertest'
}
products = require('../../domain/product')(mongoose)
categories = require('../../domain/category')(mongoose)
sut = require('../../server/app')(products, categories)

# Constants
const contentTypes = {
  json: 'application/json; charset=utf-8'
}


describe 'App', ->

  describe 'Products', ->
    afterEach ->
      products.findAll.restore?()
      products.findById.restore?()


    describe 'GET: /products', ->

      @it 'lists all products', (done) ->
        stub = sinon.stub products, 'findAll'
                    .callsArgWith 0, null, []
        request sut
          .get '/products'
          .end (_, res)->
            res.should.have.status 200
            res.should.be.json
            res.text.should.equal '[]'
            stub.callCount.should.equal 1
            done!


    describe 'GET: /products:id', ->

      @it 'lists all products in json', (done) ->
        stub = sinon.stub products, 'findById'
                    .withArgs '17'
                    .callsArgWith 1, null, { test: 'es ist' }
        request(sut)
          .get '/products/17'
          .end (_, res) ->
            res.should.have.status 200
            res.should.be.json
            res.text.should.include \"test": "es ist"
            stub.callCount.should.equal 1
            done!

      @it 'liefert 404 für ein nicht gefundenes Produkt', (done) ->
        sinon.stub products, 'findById'
             .withArgs '17'
             .callsArgWith 1, {}
        request sut
          .get '/products/17'
          .end (_, res) ->
            res.should.have.status 404
            done!


  describe 'Kategorien', ->
    afterEach ->
      categories.findAll.restore?()
      categories.findById.restore?()


    describe 'GET: /categories', ->

      @it 'lists all categories', (done) ->
        stub = sinon.stub categories, 'findAll'
                    .callsArgWith 0, null, []
        request sut
          .get '/categories'
          .end (_, res)->
            res.should.have.status 200
            res.should.be.json
            res.text.should.equal '[]'
            stub.callCount.should.equal 1
            done!


