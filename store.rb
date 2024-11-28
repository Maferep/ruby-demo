# frozen_string_literal: true

require 'sqlite3'

class Store_SQLite
  def self.from_filename(filename)
    db = SQLite3::Database.new filename
    Store_SQLite.new db
  end

  def self.from_memory
    db = SQLite3::Database.new ':memory:'
    Store_SQLite.new db
  end

  def initialize(db)
    @db = db
    @db.execute <<-SQL
      CREATE TABLE IF NOT EXISTS products (id, name);
    SQL
    @db.execute <<-SQL
      CREATE TABLE IF NOT EXISTS sessions (user TEXT, token TEXT, date_created TEXT);
    SQL
    @db.execute <<-SQL
      CREATE TABLE IF NOT EXISTS users (user, password);
    SQL
    @db.execute 'INSERT INTO users (user, password) VALUES (?,?);',
                %w[user2 password2]
  end

  def add_product(id, name)
    @db.execute(
      'INSERT INTO products (id, name) VALUES (?,?);',
      [id, name]
    )
  end

  # returns: [[id, name], [id, name], ...]
  def list_products
    stmt = @db.prepare 'SELECT * FROM products'
    result_set = stmt.execute
    result_set.map { |e| e }
  end

  def add_token(user, token)
    raise StandardError, 'null user or token' if !user || !token

    @db.execute(
      'INSERT INTO sessions (user, token, date_created) VALUES (?, ?, datetime(\'now\'));',
      [user, token.to_s.encode('UTF-8')]
    )

    stmt = @db.prepare 'SELECT * FROM sessions;'
    stmt.execute
  end

  def validate_token(token)
    result_set = @db.execute 'SELECT * FROM sessions;'
    result_set.map { |e| e }

    result_set = @db.execute 'SELECT user FROM sessions WHERE token=?;', [token.encode('UTF-8')]
    result_set = result_set.map { |e| e }

    result_set.length.positive? ? result_set[0][0] : nil
  end
end
