class Hotel < ApplicationRecord
  include Publishable
  has_many :images, as: :imageable, dependent: :destroy, class_name: 'AdminImage'

  mount_uploader :logo, ImageUploader

  scope :user_visible, ->  { where(published: true).order(id: :desc) }
  scope :search_keyword, -> (keyword) { where('title like ?', keyword) }

  def preview_logo
    return '' if logo&.url.nil?

    logo.url(:sm)
  end
end
