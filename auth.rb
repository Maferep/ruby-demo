class Authenticator
  def initialize(app, store)
    @app = app
    @store = store[:app]
  end

  def is_restricted(endpoint)
    ((endpoint == '/product') or (endpoint == '/products'))
  end

  def call(env)
    return @app.call env unless is_restricted env['PATH_INFO']

    req = Rack::Request.new env
    token = req.cookies['id']

    unless token
      return [
        403,
        { 'content-type' => 'text/plain' },
        ['Not Authorized']
      ]
    end

    user = @store.validate_token token
    if user.nil?
      return [
        403,
        { 'content-type' => 'text/plain' }, # missing www header
        ['Not Authorized']
      ]
    end

    @app.call env
  end
end
