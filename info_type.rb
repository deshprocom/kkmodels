class InfoType < ApplicationRecord
  has_many :infos, -> { order(id: :desc) }
  has_many :published_infos,
           -> { where(published: true).order(id: :desc) },
           class_name: 'Info'
end
