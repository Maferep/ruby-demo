
class Authenticator
  def initialize(app)
    @app = app
  end
  
  def is_restricted(endpoint)
    return ((endpoint == "/product") or (endpoint == "/products"))
  end

  def call(env)
    cookie = env["HTTP_COOKIE"]
    if is_restricted(env["PATH_INFO"])
      if cookie.length > 0
        session_id = cookie[2..]
        status, headers, response = @app.call(env)
      else
        status = 403
        headers = {'Content-Type' => 'text/plain'} # missing www header
        response =  ["Not Authorized"]
      end
    else
      status = 404
      headers = {'Content-Type' => 'text/plain'} # missing www header
      response =  ["Not Found"]
    end
    [status, headers, response]
  end
end

