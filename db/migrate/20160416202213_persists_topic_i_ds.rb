class PersistsTopicIDs < ActiveRecord::Migration
  def change
    add_column :courses, :topic_id, :string
    change_column_null :courses, :topic_id, false
    add_column :schedule_slots, :topic_id, :string
    add_column :schedule_slots, :group_topic_id, :string
    change_column_null :schedule_slots, :topic_id, false
    change_column_null :schedule_slots, :group_topic_id, false
    add_index :courses, :topic_id
    add_index :schedule_slots, :topic_id
    add_index :schedule_slots, :group_topic_id
  end
end
