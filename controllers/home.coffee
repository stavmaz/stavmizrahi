fs    = require 'fs'
fm    = require 'front-matter'
_     = require 'lodash'
async = require 'async'

class HomeController
  module.exports = HomeController

  constructor: (@app)->

  index : (req, res) ->
    res.render "home",
      title: "Home"

  getPage: (req, res, next)=>
    pageFile = "content/pages/#{req?.params?.page}.jade"
    fs.exists pageFile, (exists)=>
      unless exists
        return next()

      @app.render "../content/pages/#{req?.params?.page}", (err, html)=>
        if err?
          return next err
        res.send html

  _getPageProperties: (page, id, cb)=>
    postFilename = "content/pages/content/#{page}/#{id}"
    fs.readFile postFilename, encoding: 'utf8', (err, postFm)=>
      if err?
        return cb err
      try
          post = fm postFm
          post.attributes.id = id.replace ".md", ""
      catch err
        return cb err
      return cb null, post

  _getPageChildren: (page, id, cb)=>
    unless id is 'index'
      return cb null, []
    fs.readdir "content/pages/content/#{page}", (err, files)=>
      if err?
        return cb err
      files = _.without files, 'index.md'
      async.map files, async.apply(@_getPageProperties, page), cb

  getPages: (page, cb)=>
    @_getPageChildren page, 'index', cb


  getPageWithId: (req, res, next)=>
    id = req?.params?.id
    page = req?.params?.page
    
    if (!id)
      id = "index"

    postFilename = "content/pages/content/#{page}/#{id}.md"
    fs.exists postFilename, (exists)=>
      unless exists
        return next()

      fs.readFile postFilename, encoding: 'utf8', (err, postFm)=>
        if err?
          return next(err)

        try
          post = fm postFm
          post.attributes.id = id
        catch err
          return next(err)

        @_getPageChildren page, id, (err, children)=>
          if err?
            return next err

          post.attributes.children = children;

          pageFile = "content/pages/#{req?.params?.page}.jade"
          fs.exists pageFile, (exists)=>
            unless exists
              return next()

            @app.render "../content/pages/#{req?.params?.page}", post:post, (err, html)=>
              if err?
                return next()

              res.send html
