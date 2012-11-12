/**
 * Mongoose Connection für Tests öffnen.
 * Ist schon eine Connection vorhanden, 
 * dann nicht erneut öffnen.
 *
 * @param {Mongoose} mongoose Das Modul.
 */
module.exports.ensureMongooseConnection = (mongoose) ->
  mongoose.connection.on 'connected', ->
    #console.log 'CONNECTION OPENED'

  mongoose.connection.on 'disconnected', ->
    console.log 'CONNECTION CLOSED'

  if mongoose.connection.readyState not in [1 2]
    mongoose.connect 'mongodb://localhost/llprk_test', (err) ->
      console.error err if err
