class JoinConfirmation < ActiveRecord::Base
  belongs_to :user
  attr_accessible :activation_code, :user_id
end
