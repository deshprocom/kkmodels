module Shop
  class Image < Shop::Base
    mount_uploader :image, ShopImageUploader
    belongs_to :imageable, polymorphic: true, optional: true
    attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

    scope :position_asc, -> { order(position: :asc) }
    def preview
      image.url(:md)
    end

    def large
      image.url(:lg)
    end

    def original
      image.url
    end
  end
end

