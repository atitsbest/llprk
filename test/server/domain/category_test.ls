require! {
  mongoose
  should
  helper: '../../helper'
}
helper.ensureMongooseConnection mongoose
sut = require('../../../server/domain/category')(mongoose)

describe 'Domain: Kategorie', ->
  # Die Kategorie in der DB. 
  current = null

  beforeEach (done) ->
    <-! sut.model.remove {}
    err, c <- sut.insert 'name', 'blahh balh'
    should.not.exist err
    should.exist c
    current := c
    done!

  afterEach (done)->
    sut.model.remove {}, -> done!


  @it 'lists all sut', (done)->
    err, cs <- sut.findAll!
    should.not.exist err
    cs.length.should.equal 1
    done!

  @it 'gets sut by id', (done) ->
    err, c <- sut.findById current._id
    should.not.exist err
    should.exist c
    done!


  describe 'Insert', ->
    @it 'inserts new category', (done) ->
      _, c <- sut.insert 'name1', 'blahh1'
      should.exist c
      c.name.should.equal 'name1'
      _, cs <- sut.findAll!
      cs.length.should.equal(2)
      done!

    @it 'needs a name', (done) ->
      err <- sut.insert null, 'blah1'
      should.exist err, 'Validation not triggered.'
      done!

    @it 'needs a uniqe name', (done) ->
      err <- sut.insert 'name', 'bbbbb'
      should.exist err, 'Validation not triggered.'
      done!


  describe 'Update', ->
    @it 'updates an existing category', (done) ->
      current.name.should.equal 'name'
      err <- sut.update current._id, {name: 'name1'}
      should.not.exist err
      _, c <- sut.findById current._id
      c.name.should.equal 'name1'
      done!
