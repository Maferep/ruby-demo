require "cuba"
require "json"
require 'securerandom'

$products = []
$temp_unsafe_login = [{user: "user2", password:"password2"}]

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
    on "login" do
      on param("user"), param("password") do |user, password|
        if user == nil
          res.status=411
          res.write("")
        end
        credentials = $temp_unsafe_login.select {|credential| credential[:user] == user}
        if credentials == []
          res.status=411
          res.write("Invalid credentials")
        else
          if credentials[0][:password] == password
            token = SecureRandom.base64(12)
            res.headers['Set-Cookie'] = "id=" + token.to_s
            res.write ""
          else
            res.status = 411
            res.write "Invalid credentials"
          end
        end
      end
      on true do
        res.status = 411
        res.write("Need user and password parameters")
      end
    end

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
