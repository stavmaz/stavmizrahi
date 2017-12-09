path        = require 'path'
express     = require 'express'
staticCache = require 'express-static-cache'
consts      = require '../config/consts'

staticPath = path.join(__dirname, "../assets/public")

module.exports = ()->
  if process.env.CACHE_TEMPLATES is 'true'
    console.log '✔ Initializing cached static middleware'
    return staticCache staticPath,
      maxAge: consts.WEEK
  console.log '✔ Initializing non-cached static middleware'
  return express.static(staticPath)
