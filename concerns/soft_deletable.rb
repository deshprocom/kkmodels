module SoftDeletable
  extend ActiveSupport::Concern
  included do
    default_scope { where('deleted_at IS NULL') }
  end

  def soft_delete
    update(deleted_at: Time.current)
  end
end

