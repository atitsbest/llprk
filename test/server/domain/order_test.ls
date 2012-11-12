require! {
  mongoose
  should
  prelude: 'prelude-ls'
  productFixture: '../fixtures/products'
  helper: '../../helper'
}
helper.ensureMongooseConnection mongoose
categories = require('../../../server/domain/category')(mongoose)
products = require('../../../server/domain/product')(mongoose)
sut = require('../../../server/domain/order')(mongoose)

describe 'Order', ->
  # Die Kategorie in der DB. 
  current = null

  beforeEach (done) ->
    <-! products.model.remove {}
    <-! categories.model.remove {}
    <-! sut.model.remove {}

    _, cat <- categories.insert 'C1', ''
    _, p <- products.insert 'P1','descr',1.99,cat._id,[]
    productFixture.valid[0].products = [p._id]
    err, c <- sut.insert productFixture.valid[0]
    should.not.exist err
    should.exist c
    current := c
    done!

  afterEach (done)->
    <-! products.model.remove {}
    <-! categories.model.remove {}
    sut.model.remove {}, -> done!


  @it 'lists all orders', (done)->
    err, cs <- sut.findAll!
    should.not.exist err
    cs.length.should.equal 1
    done!

  @it 'gets order by id', (done) ->
    err, c <- sut.findById current._id
    should.not.exist err
    should.exist c
    done!

  @it 'calculates the total of all products and shipping costs'


  describe 'Insert', ->
    @it 'inserts new orders', (done) ->
      _, os <- sut.findAll!
      os.length.should.equal 1
      # Act
      err, o <- sut.insert productFixture.valid[0]
      # Assert
      should.not.exist err
      _, os <- sut.findAll!
      os.length.should.equal 2
      done!

    @it 'generates increasing ordernumbers', (done)->
      # Arrange
      pid = current.products[0]
      err, o1 <- sut.insert productFixture.valid[0]
      should.not.exist err
      # Act
      err, o2 <- sut.insert productFixture.valid[0]
      should.not.exist err
      # Assert
      o2.number.should.be.above o1.number
      done!

    @it 'rejects incomplete orders', (done) ->
      # Arrange
      keys = prelude.keys productFixture.invalid
      c = 0
      for key in keys
        fixture = productFixture.invalid[key]
        fixture.products = current.products
        err, o <- sut.insert fixture
        should.exist err, "Validierung zog nicht für: #{key}"
        c+=1
        done! if c == keys.length


  describe 'Shipment', ->
    @it 'changes the shipping status', (done) ->
      # Arrange
      current.isShipped.should.be.false
      # Act
      err, o <- current.setShipped true
      # Assert
      should.not.exist err
      o.isShipped.should.be.true
      # Act
      err, o <- current.setShipped false
      # Assert
      should.not.exist err
      o.isShipped.should.be.false
      done!


  describe 'Payment', ->
    @it 'changes the payment status', (done) ->
      # Arrange
      current.isPaid.should.be.false
      # Act
      err, o <- current.setPaid true
      # Assert
      should.not.exist err
      o.isPaid.should.be.true
      # Act
      err, o <- current.setPaid false
      # Assert
      should.not.exist err
      o.isPaid.should.be.false
      done!
