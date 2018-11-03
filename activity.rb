class Activity < ApplicationRecord
  mount_uploader :banner, ImageUploader
  include Publishable

  validates :banner, presence: true, if: :new_record?

  scope :published, -> { where(published: true) }

  enum activity_type: { normal: 'normal', wheel: 'wheel' }

  after_initialize do
    self.begin_time ||= Date.current
    self.end_time ||= Date.current
  end

  def preview_image
    return '' if banner&.url.nil?

    banner.url(:md)
  end

  # 活动的状态 报名中，进行中，已结束，已满员，已取消
  def activity_status
    if canceled
      'canceled'
    elsif begin_time > Time.zone.now
      'no_start'
    elsif Time.zone.now > end_time
      'finished'
    else
      'doing'
    end
  end

  def total_views
    page_views + view_increment
  end

  def increase_page_views
    increment!(:page_views)
  end
end
