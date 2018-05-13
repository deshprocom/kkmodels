class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  if ENV['CURRENT_PROJECT'] == 'kkcms'
    devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
  end
end
