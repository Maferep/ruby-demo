class Authenticator
  def initialize(app, store)
    @app = app
    @store = store[:app]
  end

  def is_restricted(endpoint)
    return ((endpoint == "/product") or (endpoint == "/products"))
  end

  def call(env)
    if not is_restricted env["PATH_INFO"]
      return @app.call env
    end

    req = Rack::Request.new env
    token = req.cookies['id']
    if not token
      return [
        403,
        {'content-type' => 'text/plain'},
        [ 'Not Authorized' ]
      ]
    end

    user = @store.validate_token token
    if user.nil?
      return [
        403,
        {'content-type' => 'text/plain'}, # missing www header
        [ 'Not Authorized' ]
      ]
    end

    return @app.call env
  end
end
