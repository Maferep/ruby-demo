require "cuba"
require "json"
require 'securerandom'
require "./state.rb"
require "./auth.rb"

class AuthAPI < Cuba; end

AuthAPI.use Authenticator

AuthAPI.define do
  on get do
    on "products" do
      res.write JSON.generate({"products" => $app.products.map{|id, name| {"id" => id, "name" => name}}})
    end
  end
  on post do
    on "product" do
      on root do
        on param("id"), param("name") do |id, name|
          $app.add_product(id, name)
          res.write ""
        end
        on true do
          res.status = 403
          res.write("Need id and name parameters")
        end
      end
    end
  end
end

Cuba.define do
  on get do
    on root do
      res.write "Hello world"
    end
    on true do
      run AuthAPI
    end
  end

  on post do
    on "login" do
      on param("user"), param("password") do |user, password|
        if user == nil
          res.status=403
          res.write("")
        end
        credential = $app.get_credential(user, password)
        if credential[0]=="token"
          res.headers['Set-Cookie'] = "id=" + credential[1].to_s
          res.write ""
        else
          res.status=403
          res.write("Not authorized")
        end
      end
      on true do
        res.status = 403
        res.write("Need user and password parameters")
      end
    end
    on true do
      run AuthAPI
    end
  end
end
