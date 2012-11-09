require! mongoose
products = require('../domain/product')(mongoose)
categories = require('../domain/category')(mongoose)
app = require('./app')(products, categories)

port = process.env.port or 3321
app.listen port
console.log "Listening von port #{port}..."

