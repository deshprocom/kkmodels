module Shop
  class Image < Shop::Base
    mount_uploader :image, ShopImageUploader
    belongs_to :imageable, polymorphic: true
    attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

    scope :position_asc, -> { order(position: :asc) }
    def preview
      return '' if image.url.nil?

      image.url(:md)
    end

    def original
      return '' if image.url.nil?

      image.url
    end
  end
end

