class Recommend < ApplicationRecord
  mount_uploader :image, ImageUploader
  validates :source_type, presence: true
  validates :source_id, presence: true
  scope :position_desc, -> { order(position: :desc) }

  def source
    @source ||= source_id && source_type.classify.safe_constantize.find_by(id: source_id)
  end

  def source_title
    return if source.nil?

    source.title
  end

  def source_image
    return if source.nil?

    return source.preview_logo if source_type == 'hotel'

    source.preview_image
  end
end