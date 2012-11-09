/**
 * @class Category
 *
 * @param {Mongoose} _mongoose
 */
module.exports = function(_mongoose) {
  var mongoose = _mongoose || require('mongoose'),
      Schema = mongoose.Schema,
      categorySchema = new Schema({
        name:       { type: String, unique: true, required: true },
        displaytext:{ type: String }
      });

  var _model = mongoose.model('categories', categorySchema);

  /**
   * Alle Kategorien
   */
  var _findAll = function(fn) {
    _model.find(fn);
  };

  /**
   * Nach der Id.
   */
  var _findById = function(id, fn) {
    _model.findById(id, fn);
  };

  /**
   * Neues einfügen.
   */
  var _insert = function(name, text, fn) {
    var m = new _model({ name: name, displaytext: text });
    m.validate(function(err) {
      if (err) fn(err);
      else m.save(fn);
    });
  };

  return {
    schema: categorySchema,
    model: _model,
    findAll: _findAll,
    findById: _findById,
    insert: _insert
  };
};
