module Shop
  class Product < Shop::Base
    include Publishable
    include Recommendable
    include ProductVariable
    include ProductCountable

    belongs_to :category, optional: false
    belongs_to :shipping
    belongs_to :merchant, optional: true
    has_many :option_types
    has_many :order_items
    has_many  :images, -> { order(position: :asc) },
              as: :imageable,
              dependent: :destroy,
              class_name: 'Image'
    has_one :counter, class_name: 'ProductCounter', dependent: :destroy
    has_one :one_yuan_buy

    validates :title, presence: true
    attr_accessor :root_category

    enum product_type: { entity: 'entity', virtual: 'virtual' }

    scope :recommended, -> { where(recommended: true) }
    scope :published, -> { where(published: true) }
    scope :search_keyword, ->(keyword) { where('title like ?', "%#{keyword}%") }
    scope :position_desc, -> { order(position: :desc) }

    if ENV['CURRENT_PROJECT'] == 'kkcms'
      ransacker :by_root_category, formatter: proc { |v|
        Category.find(v).self_and_descendants.pluck(:id)
      } do |parent|
        parent.table[:category_id]
      end
    end

    after_destroy do
      Category.decrement_counter(:products_count, category_id)
    end

    after_save :update_count_to_category
    def update_count_to_category
      return unless category_id_changed?

      Category.increment_counter(:products_count, category_id)
      Category.decrement_counter(:products_count, category_id_was) unless category_id_was.nil?
    end

    def self.in_category(category_id)
      where(category_id: Category.find(category_id).self_and_descendants.pluck(:id))
    end

    def preview_icon
      images.first&.preview.to_s
    end
  end
end

