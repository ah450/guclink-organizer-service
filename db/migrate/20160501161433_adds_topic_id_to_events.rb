class AddsTopicIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :topic_id, :string
    Event.all.each do |e|
      e.gen_topic_id
      e.save!
    end
    change_column_null :events, :topic_id, false
  end
end
