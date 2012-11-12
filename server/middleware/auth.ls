/**
 * Authentication
 */
Auth = ->
  settings = {
    loginUrl: '/login'
    successUrl: '/'
  }

  /**
   * Leitet Anfrage nur weiter, wenn der Benutzer
   * auch angemeldet ist.
   */
  _restricted = (req, res, next) ->
    if req.session.user then next!
    else
      req.session.error = 'Access denied!';
      console.error 'Access denied!'
      res.redirect settings.loginUrl

  /**
   * Meldet den Benutzer an.
   *
   * @param {Function} validateUser
   */
  _authenticate = (req, res, validateUser) ->
    user <- validateUser!
    if user
      req.session.regenerate ->
        req.session.user = user;
        res.redirect settings.successUrl
    else
      req.session.error = 'Fehler bei der Anmeldung!'
      res.redirect settings.loginUrl

  /**
   * Angemeldeten Benutzer abmelden.
   */
  _logout = (req)->
    delete req.session?.user

  {
    settings
    authenticate: _authenticate
    restricted: _restricted
    logout: _logout
  }

module.exports = Auth!
