class Hotel < ApplicationRecord
  include Publishable
  mount_uploader :logo, ImageUploader

  validates :logo, presence: true, if: :new_record?
  has_many  :comments, as: :target, dependent: :destroy
  has_many :images, as: :imageable, dependent: :destroy, class_name: 'AdminImage'
  has_many  :hotel_rooms

  scope :user_visible, -> { where(published: true).order(id: :desc) }
  scope :search_keyword, ->(keyword) { where('title like ?', "%#{keyword}%") }

  def preview_logo
    return '' if logo&.url.nil?

    logo.url(:sm)
  end

  def total_comments
    comments_count + replies_count
  end
end
