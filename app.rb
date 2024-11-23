require "cuba"

ITEMS = ("A".."Z").to_a

Cuba.define do
  on default do
    res.write "Hello world"
  end
end
