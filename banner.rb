class Banner < ApplicationRecord
  mount_uploader :image, ImageUploader

  validates :source_type, presence: true
  validates :source_id, presence: true
  validates :image, presence: true, if: :new_record?

  def source
    @source ||= source_id && source_type.classify.safe_constantize.find(source_id)
  end
  
  def source_title
    return if source.nil?

    source[:name] || source[:title]
  end
end
