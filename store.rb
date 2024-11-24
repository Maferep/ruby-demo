require 'sqlite3'

class Store_SQLite

  def Store_SQLite.from_filename(filename)
    db = SQLite3::Database.new filename
    return Store_SQLite.new db
  end

  def Store_SQLite.from_memory
    db = SQLite3::Database.new ":memory:"
    return Store_SQLite.new db
  end

  def initialize(db)
    @db = db
    @db.execute <<-SQL
      CREATE TABLE IF NOT EXISTS products (id, name);
    SQL
    @db.execute <<-SQL
      CREATE TABLE IF NOT EXISTS sessions (user, token, date_created);
    SQL
    @db.execute <<-SQL
      CREATE TABLE IF NOT EXISTS users (user, password);
    SQL
    @db.execute 'INSERT INTO users (user, password) VALUES (?,?);',
      ["user2", "password2"]
  end

  def add_product(id, name)
    @db.execute(
      'INSERT INTO products (id, name) VALUES (?,?);',
      [ id, name ]
    )
  end

  # returns: [[id, name], [id, name], ...]
  def list_products
    stmt = @db.prepare "SELECT * FROM products"
    result_set = stmt.execute
    return result_set.map{|hash| hash}
  end

  def add_token(user, token)
    @db.execute(
      'INSERT INTO sessions (user, token, date_created) VALUES (?, ?, datetime(\'now\'));',
      [ user, token ]
    )
  end

end