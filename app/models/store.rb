class Store < ActiveRecord::Base
  attr_accessible :domain, :name

  belongs_to :owner,    :class_name => "User"
  has_many :products,   :dependent => :destroy
  has_many :categories, :dependent => :destroy
  has_many :orders,     :dependent => :destroy
  has_many :assets,     :dependent => :destroy

  validates :name,   :presence => true, :length => { :maximum => 30 }
  validates :domain, :presence => true, :length => { :maximum => 30 }, :uniqueness => true

  scope :opened, where( :open => 1)
  scope :closed, where( :open => 0)

  #todo methods below refactor to scopes

  def stylesheets
    self.assets.stylesheets
  end

  def javascripts
    self.assets.javascripts
  end

end
