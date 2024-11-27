require "./store.rb"

class AppState
  def initialize(login_hash, sync = true, store = nil)
    @temp_unsafe_login = login_hash
    @db = store ? store 
    : Store_SQLite.from_filename("store.db")
    if sync
      sync_products()
    end
	end

  def request_products_external()
    res = HTTP.headers(:accept => "application/json").post("https://23f0013223494503b54c61e8bee1190c.api.mockbin.io")
    JSON.parse(res.to_s)
  end

  def sync_products()
    list = request_products_external()["data"]
    list.each do |hash|
      @db.add_product(hash["id"], hash["name"])
    end 
  end

  def validate_token(token)
    @db.validate_token(token)
  end

  def products
    @db.list_products
  end

  def add_product(id, name)
    @db.add_product(id, name)
  end

  # Create new session with random token
  def get_credential(user, password)
    credentials = @temp_unsafe_login.select {|key, credential| credential[:user] == user}.values
    if credentials.length == 0
      return ["nocred", nil]
    else
      cred = credentials[0]
      if cred[:password] == password
        token = SecureRandom.hex(10)
        # store token
        @db.add_token(cred[:user], token.to_s)
        return ["token", token]
      else
        return ["invalid", nil]
      end
    end
  end
end
