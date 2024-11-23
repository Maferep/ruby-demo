require "cuba"
require "mote"
require "cuba/contrib"

Cuba.plugin Cuba::Mote

ITEMS = ("A".."Z").to_a

Cuba.define do
  def mote_vars(content)
    { content: content }
  end

  on default do
    res.write "JELLO"
  end
end

run Cuba