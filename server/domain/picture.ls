/*jslint node:true*/
/**
 * @class Picture
 *
 * @param {Mongoose} _mongoose
 * @param {Storage} _storage
 * @param {Resizer} _resizer
 */
module.exports = (_mongoose, _storage, _resizer) ->
  'use strict';

  mongoose = _mongoose or require('mongoose')
  storage = _storage or require('../storage/storage.s3')
  resizer = _resizer or require('../services/resizer.im')
  Schema = mongoose.Schema
  uuid = require('node-uuid')

  pictureSchema = new Schema({
    id:     { type: String, unique: true, required: true },
    text:   { type: String }
  });

  pictureSchema.methods = {
    url: ->
      storage.baseUrl + 'pictures/' + this.id + '.png';
    thumbnailUrl: ->
      storage.baseUrl + 'pictures/' + this.id + '_t.png';
  }

  _model = mongoose.model('pictures', pictureSchema)

  /**
   * Alle Kategorien
   */
  _findAll = (fn) ->
    _model.find fn

  /**
   * Nach der Id.
   */
  _findById = (id, fn) ->
    _model.findById id, (err, p) ->
      throw err if err
      fn p


  /**
   * Neues einfügen.
   */
  _insert = (data, fn) ->
    id = uuid.v1();

    resized <-! resizer.resizeInMemory data, 400, 400
    thumb <-! resizer.resizeInMemory data, 100, 100
    <-! storage.putFile "picture/#{id}_o.png", data
    <-! storage.putFile "picture/#{id}.png", resized
    <-! storage.putFile "picture/#{id}_t.png", thumb

    m = new _model { id, text: '' }
    err <- m.validate!
    if err then fn err
    else
      m.save (err, nm) ->
        if err then fn err else fn err, nm

  /**
   * Bestehendes Bild löschen.
   */
  _removeById = (id, fn) ->
    err <- _model.remove {id: id}
    if err then fn err
    else
      <-! storage.removeFile "picture/#{id}_o.png"
      <-! storage.removeFile "picture/#{id}.png"
      <-! storage.removeFile "picture/#{id}_t.png"
      fn!

  {
    schema: pictureSchema,
    model: _model,
    findAll: _findAll,
    findById: _findById,
    insert: _insert,
    removeById: _removeById
  }
