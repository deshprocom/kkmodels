module TopicCountable
  extend ActiveSupport::Concern
  included { after_create :create_topic_counter }

  def increase_page_views
    counter.increment!(:page_views)
  end
end