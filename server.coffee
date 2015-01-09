express = require 'express'
path = require 'path'
browserify = require 'browserify-middleware'
browserify.settings 'transform', ['coffeeify','jadeify']
browserify.settings 'extensions', ['.coffee']

app = express()
app.set 'views', __dirname
app.set 'view engine', 'jade'

PouchDB = require 'pouchdb'
app.use '/db', require('express-pouchdb') PouchDB.defaults
  prefix: path.join(__dirname, 'pouch-data/')

app.use '/app.js', browserify './public/app.coffee'
app.use require('less-middleware')(path.join __dirname, 'public')
app.use express.static path.join(__dirname, 'public')

app.get '/', (req, res) -> res.render 'index'

# Custom routes go in the next section.

#============ START ROUTES ================#

#============= END ROUTES =================#

# 404 if we haven't matched yet.
app.use (req, res) ->
  res.status(404).send('Not found')

if require.main is module
  app.listen process.env.PORT or 3000
else
  module.exports = app
