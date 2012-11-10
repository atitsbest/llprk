require! {
  should
  sinon
  mongoose
  shared: './shared'
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
    shared.shouldBehaveLikeGETList sut, products, 'products'
    shared.shouldBehaveLikeGETSingle sut, products, 'products'

  describe 'Kategorien', ->
    shared.shouldBehaveLikeGETList sut, categories, 'categories'
    shared.shouldBehaveLikeGETSingle sut, categories, 'categories'

    describe 'POST: /categories', ->
      @it 'inserts a new item', (done) ->
        data = { name: 'test', displaytext: 'text' }
        stub = sinon.stub categories, 'insert'
                    .withArgs data.name, data.displaytext
                    .callsArg 2
        request sut
          .post "/categories"
          .send data
          .end (_, res) ->
            res.should.have.status 201
            stub.callCount.should.equal 1
            done!

      @it 'handles server errors'


    describe 'PUT: /categories/:id' ->
      @it 'updates an existing item' (done) ->
        data = { name: 'test', displaytext: 'text' }
        stub = sinon.stub categories, 'update'
                    .withArgs '17',data
                    .callsArg 2
        request sut
          .put "/categories/17"
          .send data
          .end (_, res) ->
            res.should.have.status 204
            stub.callCount.should.equal 1
            done!
