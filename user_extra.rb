class UserExtra < ApplicationRecord
  include SoftDeletable

  belongs_to :user, optional: true
  enum status: { init: 'init', pending: 'pending', 'passed': 'passed', 'failed': 'failed' }

  scope :certs, ->(type) { where(cert_type: type) }

  def default!
    update(default: true)
  end
end