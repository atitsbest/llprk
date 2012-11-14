/**
 * @class App
 *
 * @param products Zugriff auf Produkte.
 * @param categories Zugriff auf die Kategorien.
 */
module.exports = (products, categories, auth) ->
  require! {
    express
    mongoose
  }
  throw new Error 'Parameter products must be provided!' unless products?
  throw new Error 'Parameter categories must be provided!' unless categories?
  throw new Error 'Parameter auth must be provided!' unless auth?


  const app = new express!


  app.configure ->
    # Mit der DB verbinden.
    if mongoose.connection?
      mongoose.connect 'mongodb://localhost/llprk_test', (err) ->
        console.error err if err

    auth.settings.loginUrl = '/admin/login'
    auth.settings.successUrl = '/admin'

    app.set 'views', __dirname+'/../client/app'
    app.set 'view engine', 'jade'
    app.use express.cookieParser 'pssst, super geheim'
    app.use express.session!
    app.use express.bodyParser!
    app.use express.static __dirname+'/../client/app'
    app.locals.pretty = true # Schönes HTML von Jade.

  app.configure 'development', ->
    app.use express.errorHandler { dumpExceptions: true, showStack: true }

  app.configure 'production', ->
    app.use express.errorHandler!


  app.get '/', (req, res) ->
    res.render 'index.jade'

  app.get '/admin', auth.restricted, (req, res) ->
    res.render 'admin.jade'

  app.get '/admin/login', (req, res) ->
    res.render 'login.jade'

  app.get '/admin/logout', (req, res) ->
    auth.logout req
    res.redirect '/admin'

  app.post '/admin/login', (req, res) ->
    auth.authenticate req, res, (done) ->
      done(req.body.username == 'admin' and
           req.body.password == 'test')


  app.get '/api/products', (req, res) ->
    err, ps <- products.findAll!
    if err? then res.statusCode = 500; res.json err
    else res.send ps

  app.get '/api/products/:id', (req, res) ->
    err, p <- products.findById req.params.id
    if p? then res.send p
    else res.send 404
  
  app.post '/api/products', (req, res) ->
    b = req.body
    err, p <- products.insert b.name, b.descr, b.price, b.category, null
    if err? then res.statusCode = 500; res.json err
    else res.statusCode = 201; res.send p


  app.get '/api/categories', (req, res) ->
    err, cs <- categories.findAll!
    if err? then res.statusCode = 500; res.json err
    else res.send cs

  app.get '/api/categories/:id', (req, res) ->
    err, c <- categories.findById req.params.id
    if c? then res.send c
    else res.send 404

  app.post '/api/categories', (req, res) ->
    err, c <- categories.insert req.body.name, req.body.displaytext
    if err? then res.statusCode = 500; res.json err
    else res.statusCode = 201; res.send c

  app.put '/api/categories/:id', (req, res) ->
    err, c <- categories.update req.params.id, req.body
    if err? then res.statusCode = 500; res.json err
    else res.statusCode = 204; res.send c

  return app
