require! {
  should
  sinon
  mongoose
  shared: './shared'
  request: 'supertest'
  auth: '../../server/middleware/auth'
}
products = require('../../server/domain/product')(mongoose)
categories = require('../../server/domain/category')(mongoose)
_createSut = ->
  require('../../server/app')(products, categories, auth)
sut = null

# Constants
const contentTypes = {
  json: 'application/json; charset=utf-8'
}


describe 'App', ->
  beforeEach ->
    sut := _createSut!

  afterEach ->
    sut = null

  describe 'Index', ->
    @it 'renders the start page', (done) ->
      request sut
        .get '/'
        .expect 200, done


  describe 'Admin', ->
    afterEach ->
      auth.restricted.restore?()

    @it 'redirects the login page if the user is not logged in', (done) ->
      request sut
        .get '/admin'
        .end (_, res) ->
          res.should.have.status 302
          res.header.location.should.equal '/admin/login'
          done!

    @it 'renders the start page', (done) ->
      authStub = sinon.stub auth, 'restricted'
                      .callsArg 2 # next()
      sut := _createSut!
      request sut
        .get '/admin'
        .end (_, res) ->
          res.should.have.status 200
          authStub.callCount.should.equal 1, 'restricted not called!'
          done!


    describe 'Login', ->
      @it 'renders the login page', (done) ->
        request sut
          .get '/admin/login'
          .expect 200, done

      @it 'logs user in', (done) ->
        request sut
          .post '/admin/login'
          .send { username: 'admin', password: 'test' }
          .end (req, res) ->
            res.should.have.status 302
            res.header.location.should.eql '/admin'
            done!


    describe 'Logout', ->
      afterEach ->
        auth.logout.restore?()

      @it 'logs off the current user', (done) ->
        authStub = sinon.stub auth, 'logout'
        sut := _createSut!
        request sut
          .get '/admin/logout'
          .end (_, res) ->
            res.should.have.status = 302
            res.header.location.should.eql '/admin'
            authStub.callCount.should.equal 1, 'logout not called!'
            done!


  describe 'Products', ->
    shared.shouldBehaveLikeGETList _createSut, products, 'products'
    shared.shouldBehaveLikeGETSingle _createSut, products, 'products'

    describe 'POST: /api/products', ->
      @it 'inserts a new item', (done) ->
        data = {
          name: 'test',
          descr: 'text',
          price: 9.99,
          category: 12 }
        stub = sinon.stub products, 'insert'
                    .withArgs data.name, data.descr, data.price, data.category, null
                    .callsArg 5
        request sut
          .post "/api/products"
          .send data
          .end (_, res) ->
            res.should.have.status 201
            stub.callCount.should.equal 1
            done!

  describe 'Kategorien', ->
    shared.shouldBehaveLikeGETList _createSut, categories, 'categories'
    shared.shouldBehaveLikeGETSingle _createSut, categories, 'categories'

    describe 'POST: /api/categories', ->
      @it 'inserts a new item', (done) ->
        data = { name: 'test', displaytext: 'text' }
        stub = sinon.stub categories, 'insert'
                    .withArgs data.name, data.displaytext
                    .callsArg 2
        request sut
          .post "/api/categories"
          .send data
          .end (_, res) ->
            res.should.have.status 201
            stub.callCount.should.equal 1
            done!

      @it 'handles server errors'


    describe 'PUT: /api/categories/:id' ->
      @it 'updates an existing item' (done) ->
        data = { name: 'test', displaytext: 'text' }
        stub = sinon.stub categories, 'update'
                    .withArgs '17',data
                    .callsArg 2
        request sut
          .put "/api/categories/17"
          .send data
          .end (_, res) ->
            res.should.have.status 204
            stub.callCount.should.equal 1
            done!
