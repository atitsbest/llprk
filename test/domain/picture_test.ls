require! {
  mongoose
  resizer_nil: '../../services/resizer.nil'
  storage_nil: '../../storage/storage.nil'
  fs
  url
  http
  sinon
  should
}
sut = require('../../domain/picture')(mongoose, storage_nil, resizer_nil)
#mongoose.connect 'mongodb://localhost/llprk_test'

describe 'Picture', ->
  current = null

  beforeEach (done) ->
    <- sut.model.remove {}
    err, p <- sut.insert []
    should.not.exist err
    should.exist p
    current := p
    done!

  afterEach (done)->
    sut.model.remove {}, -> done!

  @it 'lists all pictures', (done) ->
    err, ps <- sut.findAll!
    should.not.exist err
    ps.length.should.equal 1
    done!

  @it 'gets picture by id', (done) ->
    p <- sut.findById current._id
    should.exist p
    done!

  describe 'Insert', ->
    @afterEach ->
      resizer_nil.resizeInMemory.restore?()
      storage_nil.putFile.restore?()

    @it 'inserts new picture', (done) ->
      # Act
      p <- sut.insert []
      # Assert
      err, ps <- sut.findAll!
      should.not.exist err
      ps.length.should.equal 2
      done!

    @it 'saves the original picture', sinon.test ->
      # Arrange
      storageSpy = sinon.spy(storage_nil, "putFile")
      # Act
      <- sut.insert []
      # Assert
      storageSpy.args[0][0].should.match /picture\/.*_o.png/

    @it 'saves a thumbnail', sinon.test ->
      # Arrange
      storageSpy = sinon.spy(storage_nil, "putFile")
      resizerSpy = sinon.spy(resizer_nil, "resizeInMemory")
      # Act
      <- sut.insert []
      # Assert
      storageSpy.args[2][0].should.match /picture\/.*_t.png/
      resizerSpy.args[1][1].should.equal 100
      resizerSpy.args[1][2].should.equal 100

    @it 'saves the resized picture', sinon.test ->
      # Arrange
      storageSpy = sinon.spy(storage_nil, "putFile")
      resizerSpy = sinon.spy(resizer_nil, "resizeInMemory")
      # Act
      <- sut.insert []
      # Assert
      storageSpy.args[1][0].should.match /picture\/.*.png/
      resizerSpy.args[0][1].should.equal 400
      resizerSpy.args[0][2].should.equal 400


  describe 'Remove', ->
    @afterEach ->
      #storage_nil.removeFile.restore?()

    @it 'removes the picture from the db', (done) ->
      # Arrange
      err, ps <- sut.findAll!
      should.not.exist err
      ps.length.should.equal 1
      # Act
      err <-! sut.removeById current.id
      # Assert
      should.not.exist err
      err, ps <- sut.findAll!
      should.not.exist err
      ps.length.should.equal 0
      done!

    @it 'removes the saved pictures (media)', sinon.test ->
      # Arrange
      storageSpy = sinon.spy(storage_nil, "removeFile")
      # Act
      err <-! sut.removeById current.id
      # Assert
      should.not.exist err
      storageSpy.callCount.should.equal 3
      storageSpy.args[0][0].should.equal "picture/#{current.id}_o.png"
      storageSpy.args[1][0].should.equal "picture/#{current.id}.png"
      storageSpy.args[2][0].should.equal "picture/#{current.id}_t.png"

    @it 'does not remove the picture if it is used by a product'



# Helper
readFixtureSync = (name) ->
  fname = __dirname + '/../fixtures/' + name
  fs.readFileSync fname

