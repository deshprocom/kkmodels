class Info < ApplicationRecord
  include Publishable
  include Stickable
  mount_uploader :image, ImageUploader

  validates :image, presence: true, if: :new_record?
  belongs_to :info_type
  scope :search_keyword, ->(keyword) { where('title like ?', keyword) }

  after_initialize do
    self.date ||= Date.current
  end

  def preview_image
    return '' if image&.url.nil?

    image.url(:sm)
  end
end
