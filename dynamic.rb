class Dynamic < ApplicationRecord
  belongs_to :user
  belongs_to :target, polymorphic: true

  def view_visible?
    if option_type.in?(%w[comment reply])
      target.present? && target.target.present?
    else
      target.present?
    end
  end
end
