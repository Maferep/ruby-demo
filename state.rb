class AppState
  def initialize()
		@products = []
    @temp_unsafe_login = {"user2": {user: "user2", password:"password2", token:nil}}
	end
  def products
    @products
  end
  # dfsdfdsf
  def get_credential(user, password) # create new session with random 
    credentials = @temp_unsafe_login.select {|key, credential| credential[:user] == user}.values
    if credentials.length == 0
      return ["nocred", nil]
    else
      cred = credentials[0]
      if cred[:password] == password
        token = SecureRandom.base64(12)
        # store token
        cred[:token] = token
        return ["token", token]
      else
        return ["invalid", nil]
      end
    end
  end
end

$app = AppState.new


