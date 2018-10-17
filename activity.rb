class Activity < ApplicationRecord
  mount_uploader :banner, ImageUploader

  after_initialize do
    self.begin_time ||= Date.current
    self.end_time ||= Date.current
  end
end
