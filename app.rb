require "cuba"
require "json"

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
        puts $temp_unsafe_login[0][:user]
        credentials = $temp_unsafe_login.select {|credential| credential[:user] == user}
        if credentials == []
          puts "whoops"
          res.status=411
          res.write("Invalid credentials")
        else
          print credentials.class
          print credentials
          puts credentials[0][:password]
          puts password
          if credentials[0][:password] == password
            puts "good login"
            res.write ""
          else
            puts "bad login"
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
