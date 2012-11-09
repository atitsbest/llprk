require! 'fs'
require! 'should'
sut = require '../../services/resizer.im'

describe 'Resizer.ImageMagick', ->

  beforeEach (done) ->
    done()

  afterEach (done)->
    done()

  describe 'resizeInMemory', ->
    @it 'resizes an image in memory', (done) ->
      data = readFixtureSync 'img.png'
      resized <- sut.resizeInMemory data, 100, 100
      should.exist resized
      sut.im.identify {data:resized}, (err, features) ->
        throw new Error err if err
        features.width.should.be.below 101
        features.height.should.be.below 101
        done()



# Helper
readFixtureSync = (name) ->
  fname = __dirname + '/../fixtures/' + name
  fs.readFileSync fname
