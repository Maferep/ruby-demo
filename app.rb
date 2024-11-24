require "cuba"
require "json"
require 'securerandom'
require "./state.rb"

Cuba.define do
  on get do
    on root do
      res.write "Hello world"
    end

    on "products" do
      res.write JSON.generate({"products" => $app.products})
    end
  end

  on post do
    on "login" do
      on param("user"), param("password") do |user, password|
        if user == nil
          res.status=411
          res.write("")
        end
        credential = $app.get_credential(user, password)
        if credential[0]=="token"
          res.headers['Set-Cookie'] = "id=" + credential[1].to_s
          res.write ""
        else
          res.status=411
          res.write("Not authorized")
        end
      end
      on true do
        res.status = 411
        res.write("Need user and password parameters")
      end
    end

    on "product" do
      on param("id"), param("name") do |id, name|
        $app.products.push({"id" => id, "name"=> name})
        res.write ""
      end
      on true do
        res.status = 500
        res.write("Need id and name parameters")
      end
    end
  end
end
