
class Authenticator
  def initialize(app)
    @app = app
  end
  
  def call(env)
    cookie = env["HTTP_COOKIE"]
    if cookie.length > 0 
      session_id = cookie[2..]
      status, headers, response = @app.call(env)
    else
      status = 411
      headers = {'Content-Type' => 'text/plain'} # missing www header
      response =  ["Not Authorized"]
    end
    [status, headers, response]
  end
end

