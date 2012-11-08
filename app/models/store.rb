class Store < ActiveRecord::Base
  attr_accessible :domain, :name

  belongs_to :owner, :class_name => "User"
  has_many :products, :dependent => :destroy
  has_many :categories, :dependent => :destroy

  validates :name,   :presence => true, :length => { :maximum => 15 }
  validates :domain, :presence => true, :length => { :maximum => 15 }, :uniqueness => true

end
