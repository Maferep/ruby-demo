require "cuba"
require "rack"
require "rack/test"
require "cuba/test"
require './app.rb'

setup do
  test_store = Store_SQLite.from_memory
  test_store.add_token("user2", "GiFgRpYXJnhXMGd")
  $app = AppState.new(test_store)
  AuthAPI.use Authenticator, app: $app
end

scope do
  test "Homepage" do
    get "/"
    assert_equal "Hello world", last_response.body
  end
end

scope do
  test "Unauthorized" do
    set_cookie("")
    post("/product?id=1&name=pizza")
    assert_equal 403, last_response.status
  end
end

scope do
  test "Authorized Submit" do
    set_cookie("id=GiFgRpYXJnhXMGd")
    post("/product?id=1&name=pizza",{})
    assert_equal "", last_response.body
    assert_equal 200, last_response.status
  end
end

scope do
  test "Incorrect Endpoint" do
    set_cookie("id=GiFgRpYXJnhXMGd")
    post("/product/productsdfsdfsdfs?id=6&name=wrong")
    assert_equal 404, last_response.status
  end
end

scope do
  test "Invalid Query Params" do
    set_cookie("id=GiFgRpYXJnhXMGd")
    post("/product?invalidquery=GiFgRpYXJnhXMGd")
    assert_equal 403, last_response.status
  end
end


scope do
  test "Create and get product" do
    set_cookie("id=GiFgRpYXJnhXMGd")
    get "products"
    assert_equal 200, last_response.status
    assert_equal "{\"products\":[]}", last_response.body
    # assert_equal "{\"products\":[]}", last_response.body

    post("/product?id=10&name=coffee")
    assert_equal 200, last_response.status
    assert_equal "", last_response.body

    get "products"
    assert_equal 200, last_response.status
    assert_equal "{\"products\":[{\"id\":\"10\",\"name\":\"coffee\"}]}", last_response.body
  end
end

scope do
  test "Login" do
    post "login?user=user&password=password"
    assert_equal 403, last_response.status
  end
end

scope do
  test "Login" do
    post "login?user=user2&password=password2"
    assert_equal 200, last_response.status
    assert_equal "id=", last_response.headers["set-cookie"][..2]
  end
end