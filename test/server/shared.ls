require! {
  sinon
  should
  request: 'supertest'
}

exports.shouldBehaveLikeGETSingle = (sutFn, domain, name) ->
  sut = null

  describe "GET: /api/#{name}:id", ->
    beforeEach ->
      sut := sutFn!

    afterEach ->
      domain.findAll.restore?()
      domain.findById.restore?()
      sut := null

    @it 'lists all in json', (done) ->
      stub = sinon.stub domain, 'findById'
                  .withArgs '17'
                  .callsArgWith 1, null, { test: 'es ist' }
      request(sut)
        .get "/api/#{name}/17"
        .end (_, res) ->
          res.should.have.status 200
          res.should.be.json
          res.text.should.include \"test": "es ist"
          stub.callCount.should.equal 1
          done!

    @it 'returns 404 when not found', (done) ->
      sinon.stub domain, 'findById'
           .withArgs '17'
           .callsArgWith 1, {}
      request sut
        .get "/api/#{name}/17"
        .expect 404, done


exports.shouldBehaveLikeGETList = (sutFn, domain, name) ->
  sut = null

  describe "GET: /api/#{name}", ->
    beforeEach ->
      sut := sutFn!

    afterEach ->
      sut := null

    @it 'lists all', (done) ->
      stub = sinon.stub domain, 'findAll'
                  .callsArgWith 0, null, []
      request sut
        .get "/api/#{name}"
        .end (_, res)->
          res.should.have.status 200
          res.should.be.json
          res.text.should.equal '[]'
          stub.callCount.should.equal 1
          done!
