require! {
  fs
  http
  url
}
sut = require '../../storage/storage.s3'

describe 'Storage.S3', ->
  # Das kann schon mal länger als gewöhnlich dauern.
  #@timeout 3000

  beforeEach (done) ->
    done()

  afterEach (done)->
    done()

  describe 'putFile', ->
    afterEach (done) ->
      sut.removeFile 'pictures/testers.png', ->
        done()

    @it 'stores data as a file on aws s3', (done) ->
      data = readFixtureSync 'img2.png'
      <- sut.putFile 'pictures/testers.png', data
      url_should_exist sut.baseUrl+'pictures/testers.png', done

  describe 'removeFile', ->
    @it 'removes existing files', (done) ->
      fname = 'pictures/testers.png'
      data = readFixtureSync 'img2.png'
      <- sut.putFile fname, data
      <- url_should_exist sut.baseUrl+fname
      <- sut.removeFile fname
      url_should_not_exist sut.baseUrl+fname, done



# -----------------------------------------------
# Helpers
url_should_exist = (_url, done) ->
  u = url.parse(_url)
  options = { host: u.host, port: u.port || 80, path: u.path }

  http.get options, (res) ->
    res.statusCode.should.equal(200, 'File not found')
    done()
  .on 'error', (e) -> throw new Error e

url_should_not_exist = (_url, done) ->
  u = url.parse(_url)
  options = { host: u.host, port: u.port || 80, path: u.path }

  http.get options, (res) ->
    res.statusCode.should.not.equal(200, 'File found')
    done()
  .on 'error', (e) -> done()

# Helper
readFixtureSync = (name) ->
  fname = __dirname + '/../fixtures/' + name
  fs.readFileSync fname

