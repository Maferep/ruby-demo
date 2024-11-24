require "cuba"

ITEMS = ("A".."Z").to_a

Cuba.define do
  on get do
    on root do
      res.write "Hello world"
    end
  end

  on post do
    on "product" do
      on param("id"), param("name") do |id, name|
        res.write ""
      end
      on true do
        res.write("Need id and name parameters")
      end
    end
  end
end
