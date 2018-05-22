module Shop
  class Image < Shop::Base
    mount_uploader :image, ShopImageUploader
    belongs_to :imageable, polymorphic: true
    attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

    scope :position_asc, -> { order(position: :asc) }
    def preview
      image.url(:md).to_s
    end

    def large
      image.url(:lg).to_s
    end

    def original
      image.url.to_s
    end
  end
end

