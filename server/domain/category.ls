/**
 * @class Category
 *
 * @param {Mongoose} _mongoose
 */
module.exports = (_mongoose) ->
  mongoose = _mongoose || require('mongoose')
  Schema = mongoose.Schema
  categorySchema = new Schema {
    name:       { type: String, unique: true, required: true }
    displaytext:{ type: String }
  }

  _model = mongoose.model 'categories', categorySchema

  /**
   * Alle Kategorien
   */
  _findAll = (fn) -> _model.find fn

  /**
   * Nach der Id.
   */
  _findById = (id, fn) -> _model.findById id, fn

  /**
   * Neues einfügen.
   */
  _insert = (name, text, fn) ->
    m = new _model { name: name, displaytext: text }
    m.validate (err) ->
      if err then fn err
      else m.save fn

  /**
   * Bestehende Kategorie ändern.
   */
  _update = (id, data, fn) ->
    delete data._id
    _model.findByIdAndUpdate id, data, fn

  {
    schema: categorySchema
    model: _model
    findAll: _findAll
    findById: _findById
    insert: _insert
    update: _update
  }
