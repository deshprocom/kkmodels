class JUser < ApplicationRecord
  belongs_to :user

  def delete_user
    Jmessage::User.delete_user(username)
    destroy
  end
end
