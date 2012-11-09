/**
 * @class App
 *
 * @param products Zugriff auf Produkte.
 * @param categories Zugriff auf die Kategorien.
 */
module.exports = (products, categories) ->
  require! {
    express
    mongoose
  }
  throw new Error 'Parameter products must be provided!' unless products?
  throw new Error 'Parameter categories must be provided!' unless categories?


  const app = new express!

  app.configure ->
    # Mit der DB verbinden.
    mongoose.connect 'mongodb://localhost/llprk_test', (err) ->
      console.error err if err


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


  app.get '/categories', (req, res) ->
    err, cs <- categories.findAll!
    if err? then res.statusCode = 500; res.json err
    else res.send cs


  return app
