class Activity < ApplicationRecord
  mount_uploader :banner, ImageUploader
  include Publishable

  validates :banner, presence: true, if: :new_record?

  scope :published, -> { where(published: true) }

  after_initialize do
    self.begin_time ||= Date.current
    self.end_time ||= Date.current
  end

  def preview_image
    return '' if banner&.url.nil?

    banner.url(:md)
  end
end
