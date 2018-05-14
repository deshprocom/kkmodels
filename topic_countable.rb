module TopicCountable
  extend ActiveSupport::Concern
  included { after_create :create_counter }
end
