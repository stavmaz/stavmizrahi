#!/usr/bin/env coffee
errorHandler          = require './lib/errorHandlingMiddleware'
express               = require 'express'
compression           = require 'compression'
favicon               = require 'serve-favicon'
staticMiddleware      = require './lib/staticMiddleware'
moment                = require 'moment'
path                  = require 'path'
expressValidator      = require 'express-validator'
connectAssets         = require 'connect-assets'
http                  = require 'http'
secrets               = require './config/secrets'
consts                = require './config/consts'
marked                = require 'marked'
moment                = require 'moment'

require 'coffee-script'

initServer = (app)->
  server = http.createServer app
  server.listen secrets.PORT
  console.log "✔ Express server listening on port %d", secrets.PORT
  return server

configureApp = (app)->
  #Initialize passport middleware
  # app.set "port", secrets.PORT
  # app.set "views", path.join(__dirname, "views")

  app.set "view engine", "pug"
  app.locals.moment = moment

  if process.env.CACHE_TEMPLATES is 'true'
    console.log "✔ Cache is on"
    app.set "view cache", true

  app.use compression()
  app.use connectAssets(
    paths: [
      "assets/public/css"
      "assets/public/js"
    ]
    helperContext: app.locals
    build: true
    compress: true
    fingerprinting: true
  )

  app.use favicon(__dirname + '/assets/public/favicon.png')
  app.use expressValidator()
  app.use staticMiddleware()
  app.locals.md = marked

initRoutes = (app)->
  new (require './routes/routes') app

initErrorHandlers = (app)->
  app.use (req, res) ->
    res.status 404
    res.render "404"
    return

  app.use errorHandler


initApp = (x)->
  console.log '✔ Starting ' + x
  app = express()
  console.log '✔ Express app created'

  configureApp app
  console.log '✔ Express middlewares added'

  initRoutes app
  console.log '✔ Express routes initialized'

  # initErrorHandlers app
  # console.log '✔ Error handlers initialized'

  return app


app = initApp "stavmizrahi"
server = initServer app