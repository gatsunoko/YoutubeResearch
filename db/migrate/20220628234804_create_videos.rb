class CreateVideos < ActiveRecord::Migration[7.0]
  def change
    create_table :videos do |t|
      t.string :title
      t.string :url
      t.string :time
      t.datetime :posted_date
      t.text :description
      t.integer :view_count
      t.string :channel_id
      t.string :channel_name
      t.string :channel_url
      t.string :channel_icon
      t.string :channel_create_date
      t.string :channel_member_count
      t.float :view_rate
      t.boolean :protection, null: false, default: false

      t.timestamps
    end
  end
end
