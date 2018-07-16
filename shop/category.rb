module Shop
  class Category < Shop::Base
    has_many :products
    scope :position_desc, -> { unscope(:order).order(position: :desc) }

    validates :name, presence: true
    mount_uploader :image, ImageUploader

    acts_as_nested_set counter_cache: :children_count

    def self.roots_collection
      roots.collect { |c| [c.name, c.id] }
    end

    def preview_image
      return '' if image.url.nil?

      image.url(:sm)
    end
  end
end
