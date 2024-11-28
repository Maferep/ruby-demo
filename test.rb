# frozen_string_literal: true

require 'cuba'
require 'rack'
require 'rack/test'
require 'cuba/test'
require './app'
require './test_app'

TEST_TOKEN = 'GiFgRpYXJnhXMGd'

setup do
  Cuba.reset!
  test_store = Store_SQLite.from_memory
  test_store.add_token('user2', TEST_TOKEN)
  $app = AppState.new({ 'user2' => { 'user' => 'user2', 'password' => 'password2' } }, false, test_store)
  define_apis
  Cuba.use Authenticator, app: $app
end

scope do
  test 'Homepage' do
    get '/'
    assert_equal 'Hello world', last_response.body
  end
end

scope do
  test 'Unauthorized GET' do
    set_cookie('')
    get('/products')
    assert_equal 403, last_response.status
  end
end

scope do
  test 'Unauthorized' do
    set_cookie('')
    post('/product', { 'id' => '1', 'name' => 'pizza' })
    assert_equal 403, last_response.status
  end
end

scope do
  test 'Authorized Submit' do
    set_cookie("id=#{TEST_TOKEN}")
    post('/product', { 'id' => '1', 'name' => 'pizza' })
    assert_equal '', last_response.body
    assert_equal 200, last_response.status
  end
end

scope do
  test 'Authorized Submit with additional cookies' do
    set_cookie('unrelated_cookie=abcde')
    set_cookie("id=#{TEST_TOKEN}")
    post('/product', { 'id' => '1', 'name' => 'pizza' })
    assert_equal '', last_response.body
    assert_equal 200, last_response.status
  end
end

scope do
  test 'Incorrect Endpoint' do
    set_cookie("id=#{TEST_TOKEN}")
    post('/product/bad-endpoint', { 'id' => '6', 'name' => 'wrong' })
    assert_equal 404, last_response.status
  end
end

scope do
  test 'Invalid Query Params' do
    set_cookie("id=#{TEST_TOKEN}")
    post('/product', { 'invalid' => '6' })
    assert_equal 403, last_response.status
  end
end

scope do
  test 'Create and get product' do
    set_cookie("id=#{TEST_TOKEN}")
    get 'products'
    assert_equal 200, last_response.status
    assert_equal '{"products":[]}', last_response.body
    post('/product', { 'id' => 10, 'name' => 'coffee' })
    assert_equal 200, last_response.status
    assert_equal '', last_response.body

    get 'products'
    assert_equal 200, last_response.status
    assert_equal '{"products":[{"id":"10","name":"coffee"}]}', last_response.body
  end
end

scope do
  test 'Login' do
    post('login', { 'user' => 'bad_user', 'password' => 'bad_password' })
    assert_equal 403, last_response.status
  end
end

scope do
  test 'Login' do
    post('login', { 'user' => 'user2', 'password' => 'password2' })
    set_cookie(last_response.headers['set-cookie'])
    get 'products'

    assert_equal 200, last_response.status
    assert_equal '{"products":[]}', last_response.body
  end
end
