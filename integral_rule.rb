class IntegralRule < ApplicationRecord
  mount_uploader :icon, ImageUploader
  scope :position_asc, -> { order(position: :asc) }
  scope :position_desc, -> { order(position: :desc) }

  before_create do
    self.position = IntegralRule.position_desc.first&.position.to_i + 100000
  end

  def icon_path
    icon.url.presence || ''
  end
end
