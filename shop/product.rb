module Shop
  class Product < Shop::Base
    include Publishable
    include Recommendable
    include ProductVariable

    belongs_to :category, optional: false
    has_many :option_types
    has_many  :images, as: :imageable, dependent: :destroy, class_name: Image

    validates :title, presence: true
    attr_accessor :root_category

    scope :recommended, -> { where(recommended: true) }
    scope :published, -> { where(published: true) }

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

    def self.in_category(category)
      where(category_id: category.self_and_descendants.pluck(:id))
    end

    def preview_icon
      images.first&.preview.to_s
    end
  end
end

