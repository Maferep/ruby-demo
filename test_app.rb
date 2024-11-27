require "cuba"
require "rack"
require "rack/test"
require "cuba/test"
require './state.rb'
require "http"

scope do
  test "Homepage" do
    test_store = Store_SQLite.from_memory
    app = AppState.new({}, test_store)
    res = app.request_products_external()
    assert_equal JSON.parse(res.to_s), {
      "data" => [
        {
          "id" => 1,
          "name"=> "Apple"
        },
        {
          "id"=> 2,
          "name"=> "Banana"
        }
      ]
    }
  end
end
