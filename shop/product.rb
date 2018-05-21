module Shop
  class Product < Shop::Base
    include Publishable
    # include Recommendable
    # include ProductCountable
    # include ProductVariable
    #
    # mount_uploader :icon, ProductUploader
    # belongs_to :category, optional: false
    # belongs_to :freight, optional: false
    # has_one :counter, class_name: 'ProductCounter'
    # has_many :option_types
    #
    # has_many  :images, as: :viewable, dependent: :destroy, class_name: 'ProductImage'
    #
    # validates :title, presence: true
    # validates :icon, presence: true, on: :create
    # attr_accessor :root_category
    # attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
    # enum product_type: { entity: 'entity', virtual: 'virtual' }
    #
    # scope :recommended, -> { where(recommended: true) }
    # scope :published, -> { where(published: true) }
    #
    # if ENV['CURRENT_PROJECT'] == 'dpcms'
    #   ransacker :by_root_category, formatter: proc { |v|
    #     Category.find(v).self_and_descendants.pluck(:id)
    #   } do |parent|
    #     parent.table[:category_id]
    #   end
    # end
    #
    # after_destroy do
    #   Category.decrement_counter(:products_count, category_id)
    # end
    #
    # before_save do
    #   self.description = ActionController::Base.helpers.strip_tags(description)
    # end
    #
    # after_save :update_count_to_category
    # def update_count_to_category
    #   return unless category_id_changed?
    #
    #   Category.increment_counter(:products_count, category_id)
    #   Category.decrement_counter(:products_count, category_id_was) unless category_id_was.nil?
    # end
    #
    # def self.in_category(category)
    #   where(category_id: category.self_and_descendants.pluck(:id))
    # end
    #
    # def preview_icon
    #   return '' if icon.url.nil?
    #
    #   icon.url(:sm)
    # end
    #
    # def md_icon
    #   return '' if icon.url.nil?
    #
    #   icon.url(:md)
    # end
    #
    # def freight_fee(province = nil, number = 1)
    #   freight.product_freight(province, number: number,
    #                           weight: master.weight,
    #                           volume: master.volume)
    # end
  end
end

