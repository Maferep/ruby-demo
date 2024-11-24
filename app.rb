require "cuba"
require "json"

$products = []

Cuba.define do
  on get do
    on root do
      res.write "Hello world"
    end

    on "products" do
      res.write JSON.generate({"products" => $products})
    end
  end

  on post do
    on "product" do
      on param("id"), param("name") do |id, name|
        $products.push({"id" => id, "name"=> name})
        res.write ""
      end
      on true do
        res.status = 500
        res.write("Need id and name parameters")
      end
    end
  end
end
