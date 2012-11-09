require! mongoose
products = require('../domain/product')(mongoose)
app = require('./app')(products)

port = process.env.port or 3321
app.listen port
console.log "Listening von port #{port}..."

