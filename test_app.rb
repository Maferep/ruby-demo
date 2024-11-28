require 'cuba'
require 'rack'
require 'rack/test'
require 'cuba/test'
require './state'

scope do
  test 'Request products' do
    test_store = Store_SQLite.from_memory
    app = AppState.new({}, false, test_store)
    res = app.request_products_external
    assert_equal res, {
      'data' => [
        {
          'id' => 1,
          'name' => 'Apple'
        },
        {
          'id' => 2,
          'name' => 'Banana'
        }
      ]
    }
  end
  test 'Sync products' do
    test_store = Store_SQLite.from_memory
    app = AppState.new({}, false, test_store)
    app.sync_products
    list = app.products
    assert_equal list, [[1, 'Apple'], [2, 'Banana']]
  end
end
