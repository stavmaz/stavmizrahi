async         = require 'async'
HomeController  = require '../controllers/home'

class Sitemap
  module.exports = Sitemap

  constructor: (@app)->
    @homeController = new HomeController @app

  get: (req, res, next)=>
    tasks=
      industries: async.apply(@homeController.getPages, 'industries')

    async.parallel tasks, (err, data)=>
      if err?
        return next err

      res.type 'xml'
      res.render 'sitemap', data
