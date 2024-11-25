class Authenticator
  def initialize(app, store)
    @app = app
    @store = store[:app]
  end
  
  def is_restricted(endpoint)
    return ((endpoint == "/product") or (endpoint == "/products"))
  end

  def call(env)
    cookie = env["HTTP_COOKIE"]
    if is_restricted(env["PATH_INFO"])
      if cookie && cookie.length > 0
        session_id = cookie[3..]
        user = @store.validate_token(session_id)
        print user ? user : "NO USER FOUND"
        if user
          status, headers, response = @app.call(env)
        else
          status = 403
          headers = {'content-type' => 'text/plain'} # missing www header
          response =  ["Not Authorized"]
        end
      else
        status = 403
        headers = {'content-type' => 'text/plain'} # missing www header
        response =  ["Not Authorized"]
      end
    else
      status = 404
      headers = {'content-type' => 'text/plain'}
      response =  ["Not Found"]
    end
    [status, headers, response]
  end
end

