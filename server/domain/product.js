/**
 * @class Product
 *
 * @param {Mongoose} _mongoose
 */
module.exports = function(_mongoose) {
  var mongoose = _mongoose || require('mongoose'),
      Schema = mongoose.Schema,
      productSchema = new Schema({
        name:       { type: String, required: true },
        descr:      String,
        price:      { type: Number, required: true, min: 0.00 },
        category:   { type: Schema.Types.ObjectId, ref: 'categories', required: true },
        pictures:   [{ type: Schema.Types.ObjectId, ref: 'pictures' }],
        viewcount:  { type: Number, default: 0 },
        published:  { type: Boolean, default: false }
      });

  var _model = mongoose.model('products', productSchema);

  /**
   * Alle Produkte
   */
  var _findAll = function(fn) {
    _model.find(fn);
  };

  /**
   * Produkt nach der Id.
   */
  var _findById = function(id, fn) {
    _model.findById(id)
          .populate('category')
          .exec(function(err, p) {
      if (err) fn(err);
      else fn(err, p);
    });
  };

  /**
   * Neues Produkt einfügen.
   */
  var _insert = function(name, descr, price, categoryId, pictures, fn) {
    var m = new _model({
      name: name,
      descr: descr,
      price: price,
      category: categoryId,
      pictures: pictures
    });
    
    m.validate(function(err) {
      if (err) fn(err);
      else {
        m.save(function(err, p) {
          if (err) fn(err);
          else _findById(p._id, fn);
        });
      }
    });
  };

  /**
   * Viewcounter um 1 erhöhen.
   */
  var _incViewcount = function (id, success, fail) {
    _model.update({_id: id}, {'$inc': {viewcount: 1}}, function(err) {
      if (err && fail) fail(err);
      success();
    });
  };

  return {
    schema: productSchema,
    model: _model,
    findAll: _findAll,
    findById: _findById,
    insert: _insert,
    incViewcount: _incViewcount
  };
};
