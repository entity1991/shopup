class Question < ActiveRecord::Base
  attr_accessible :content, :type

  validates :content, :type, :presence => true

  belongs_to :user
end
