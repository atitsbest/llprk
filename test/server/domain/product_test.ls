require! {
  mongoose
  resizer_nil: '../../../server/services/resizer.nil'
  storage_nil: '../../../server/storage/storage.nil'
  fs
  url
  http
  sinon
  should
}
categories = require('../../../server/domain/category')(mongoose)
pictures = require('../../../server/domain/picture')(mongoose, storage_nil, resizer_nil)
sut = require('../../../server/domain/product')(mongoose)
#mongoose.createconnect 'mongodb://localhost/llprk_test'

describe 'Product', ->
  # Das Produkt in der DB.
  currentProduct = null
  currentCategory = null
  currentImage = null

  beforeEach (done) ->
    <-! sut.model.remove {}
    <- !categories.model.remove {}
    _, c <- categories.insert 'n', 'dt'
    currentCategory := c
    err, p <- sut.insert 'test', 'blahh', 9.99, c._id, []
    should.not.exist err
    currentProduct := p
    done!

  afterEach (done)->
    <-! sut.model.remove {}
    categories.model.remove {}, -> done!


  @it 'lists all products', (done)->
    err, ps <- sut.findAll!
    ps.length.should.equal 1
    done!

  @it 'gets product by id', (done) ->
    err, p <- sut.findById currentProduct._id
    should.not.exist err
    should.exist p
    done!

  @it 'increments the viewcount by one', (done) ->
    oldCount = currentProduct.viewcount
    <-! sut.incViewcount currentProduct._id
    err, p <- sut.findById currentProduct._id
    should.not.exist err
    p.viewcount.should.equal(oldCount + 1)
    done!


  describe 'Insert', ->
    @it 'inserts new product', (done) ->
      err, p <- sut.insert 'name1', 'blahh1', 12.95, currentCategory, []
      should.not.exist err
      should.exist p
      p.name.should.equal 'name1'
      p.category.name.should.equal 'n'
      _, ps <- sut.findAll!
      ps.length.should.equal 2
      done!

    @it 'needs a name', (done) ->
      err <- sut.insert null, 'blah1', 1.99, currentCategory, []
      should.exist err
      done!

    @it 'needs a price', (done) ->
      err <- sut.insert 'name', 'blah1', -1, currentCategory, []
      should.exist err
      done!

    @it 'needs a category', (done) ->
      err <- sut.insert 'name', 'blah1', 0.99, undefined, []
      should.exist err
      done!

    @it 'saves references to the pictures', (done) ->
      # Arrange
      err, pic <- pictures.insert []
      should.not.exist err
      should.exist pic
      # Act
      err, p <- sut.insert 'test', 'test', 0.99, currentCategory, [pic._id]
      # Assert
      should.not.exist err
      p.pictures.length.should.equal 1
      pic._id.should.eql p.pictures[0]
      done!

