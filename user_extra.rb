class UserExtra < ApplicationRecord
  include SoftDeletable
  mount_uploader :image, ImageUploader

  belongs_to :user, optional: true
  enum status: { init: 'init', pending: 'pending', 'passed': 'passed', 'failed': 'failed' }

  scope :certs, ->(type) { where(cert_type: type) }

  def default!
    update(default: true)
  end

  def image_path
    return '' if image.url.nil?

    image.url
  end
end