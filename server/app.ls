/**
 * @class App
 *
 * @param _products Zugriff auf Produkte
 */
module.exports = (products) ->
  require! {
    express
    mongoose
  }
  throw new Error 'Parameter products must be provided!' unless products?


  const app = new express!

  app.configure ->
    # Mit der DB verbinden.
    mongoose.createConnection 'mongodb://localhost/llprk_test'


  app.get '/', (req, res) ->
    res.send 500

  app.get '/products', (req, res) ->
    err, ps <- products.findAll!
    if err? then res.statusCode = 500; res.json err
    else res.send ps

  app.get '/products/:id', (req, res) ->
    err, p <- products.findById req.params.id
    if p? then res.send p
    else res.send 404

  return app
