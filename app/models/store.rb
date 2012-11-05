class Store < ActiveRecord::Base
  attr_accessible :domain, :name

  belongs_to :owner, :class_name => "User"
end
