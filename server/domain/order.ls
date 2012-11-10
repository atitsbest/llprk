/**
 * @class Order
 *
 * @param {Mongoose} _mongoose
 */
module.exports = (_mongoose) ->
  'use strict';

  mongoose = _mongoose or require('mongoose')
  Schema = mongoose.Schema
  uuid = require('node-uuid')

  counterSchema = new Schema {
    _id:      String
    counter:  Number
  }

  countrySchema = new Schema {
    _id:    String # at, de, ...
    name:   String
  }

  orderSchema = new Schema {
    _createdAt:     { type: Date, default: Date.now }
    number:         { type: String, unique: true, required: true }
    products:       [{ type: Schema.ObjectId, ref: 'products', required: true }]
    addresses:      [{
      salutation:   { type: String }
      firstName:    { type: String, required: true }
      lastName:     { type: String, required: true }
      street1:      { type: String, require: true }
      street2:      String
      zip:          { type: String, required: true }
      city:         { type: String, required: true }
      email:        { type: String, lowercase: true } # E-Mail-Adressen sind immer lowercase.
      country:      { type: String, required: true, lowercase: true }
    }]
    shippingCost:   { type: Number }
    isPaid:         { type: Boolean, default: false }
    isShipped:      { type: Boolean, default: false }
    comment:        { type: String }
  }

  orderSchema.path('addresses').validate (v) ->
    v?.length >= 1
  , 'Keine Adresse angegeben!'

  orderSchema.methods = {
    setShipped: (val, fn) ->
      @isShipped = (val == true)
      @.save fn

    setPaid: (val, fn) ->
      @isPaid = (val == true)
      @.save fn

    /**
     * Gesamtpreis = Preis aller Produkte + Versandkosten.
     */
    totalPrice: ->
      result = map (.price), @.products |> (+)
      result + @.shippingCost
  }

  _countrymodel = mongoose.model('countries', countrySchema)
  _countermodel = mongoose.model('counters', counterSchema)
  _model = mongoose.model('orders', orderSchema)

  /**
   * Liefert die nächste Auftragsnummer.
   */
  _getNextOrderNumber = (fn) ->
    err, c <- _countermodel.findByIdAndUpdate("ordernumber", {$inc: {counter: 1} }, { upsert: true })
    if err then fn err
    else fn(err, c.counter)

  /**
   * Alle
   */
  _findAll = (fn) -> _model.find fn

  /**
   * Nach der Id.
   * @param {ObjectId} id
   */
  _findById = (id, fn) -> _model.findById id, fn

  /**
   * Neues einfügen.
   * @param {object} data Alle Properties die gesetzt werden sollen.
   */
  _insert = (data, fn) ->
    m = new _model data
    err, orderNumber <- _getNextOrderNumber!
    if err then fn err
    else
      # Auftragsnummer zuweisen.
      m.number = orderNumber
      # Validieren...
      err <- m.validate!
      if err then fn err
      else
        # Speichern...
        err, o <- m.save!
        if err then fn err
        else _findById o._id, fn


  {
    schema: orderSchema
    model: _model
    findAll: _findAll
    findById: _findById
    insert: _insert
  }
