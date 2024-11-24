require "cuba"
require "rack"
require "rack/test"
require "cuba/test"
require './app.rb'

setup do
  $app = AppState.new
end

scope do
  test "Homepage" do
    get "/"
    assert_equal "Hello world", last_response.body
  end
end

scope do
  test "Submit" do
    post("/product?invalidquery=123")
    assert_equal 500, last_response.status
  end
end


scope do
  test "Invalid Submit" do
    post("/product?id=1&name=pizza")
    assert_equal "", last_response.body
    assert_equal 200, last_response.status
  end
end


scope do
  test "Create and get product" do
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
    assert_equal 411, last_response.status
  end
end

scope do
  test "Login" do
    post "login?user=user2&password=password2"
    assert_equal 200, last_response.status
    assert_equal "id=", last_response.headers["set-cookie"][..2]
  end
end