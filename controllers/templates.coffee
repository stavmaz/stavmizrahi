fs = require 'fs'

class TemplatesController
  module.exports = TemplatesController

  constructor: (@app)->

  getTemplate: (req, res, next)=>
    fs.exists "assets/public/templates/#{req.params.template}.jade", (exists)=>
      unless exists?
        return next()
      @app.render "../assets/public/templates/#{req.params.template}", req.query, (err, html)=>
      	if err?
      	  return next err
        res.send html
