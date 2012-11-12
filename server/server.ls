require! {
  mongoose
  auth: './middleware/auth'
}
categories = require('./domain/category')(mongoose)
products = require('./domain/product')(mongoose)
app = require('./app')(products, categories, auth)

port = process.env.port or 3321
app.listen port, ->
  console.log "Express server listening on port #{port} in #{app.settings.env} mode..."
