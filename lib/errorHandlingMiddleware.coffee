statuses = require 'statuses'

OPTIONAL_ERROR_PROPERTIES = [
  'code', 'name', 'type'
]

module.exports = errorHandler = (err, req, res, next)->
  status = err.status || err.statusCode || 500;

  if (status<400)
    status = 500

  if (status>=500)
    console.error err.stack
    err.message = "Internal error"
  body =
    status: status
    message: err.message || statuses[status]

  for property in OPTIONAL_ERROR_PROPERTIES
    if err[property]?
      body[property] = err[property]

  return sendResponse body, req, res

sendResponse = (body, req, res)->
  accepts = req.accepts ['html', 'json']
  if accepts is 'json'
    return sendJsonResponse body, req, res

  sendHtmlResponse body, req, res

sendJsonResponse = (body, req, res)->
  res.status(body.status).json body

sendHtmlResponse = (body, req, res)->
  res.status(body.status).render 'error', {error:body}
