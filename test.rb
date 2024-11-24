require "cuba"
require "rack"
require "rack/test"
require "cuba/test"
require './app.rb'

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
  test "Submit" do
    post("/product?id=1&name=pizza")
    assert_equal "", last_response.body
    assert_equal 200, last_response.status
  end
end