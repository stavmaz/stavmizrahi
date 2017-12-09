express                       = require 'express'
HomeController                = require '../controllers/home'
SitemapController             = require '../controllers/sitemap'
TemplatesController           = require '../controllers/templates'

class Router
  module.exports = Router
  constructor: (@app)->
    @router = express.Router()

    @homeController = new HomeController @app
    @sitemapController = new SitemapController @app
    @templatesController = new TemplatesController @app

    @initRoutes()

    @app.use '/', @router

  initRoutes: ()->
    @router.get "/", @homeController.index
    # @router.get "/sitemap.xml", @sitemapController.get
    @router.get "/templates/:template.html", @templatesController.getTemplate
    @router.get "/:page", @homeController.getPageWithId
    @router.get "/:page/:id", @homeController.getPageWithId
    @router.get "/error", (req, res, next)-> err=new Error "Cannot do something"; err.status=507; next(err)
