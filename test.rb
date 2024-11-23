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
