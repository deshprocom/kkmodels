module TopicCountable
  extend ActiveSupport::Concern
  included { after_create :create_topic_counter }

  def increase_page_views
    topic_counter.increment!(:page_views)
  end

  def increase_view_increment(by)
    topic_counter.increment!(:view_increment, by)
  end
end
