require "./store.rb"

class AppState
  def initialize(login_hash, store = nil)
    @temp_unsafe_login = login_hash
    @db = store ? store 
    : Store_SQLite.from_filename("store.db")
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

# initialize with default credentials from file
$app = AppState.new(JSON.parse(File.read("credentials/test_credentials.json")))


