class AddVideoDetailColumn2 < ActiveRecord::Migration[7.0]
  def change
    add_column :videos, :detail, :text
  end
end
