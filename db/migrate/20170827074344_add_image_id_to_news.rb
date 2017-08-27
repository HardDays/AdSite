class AddImageIdToNews < ActiveRecord::Migration[5.1]
  def change
    add_column :news, :image_id, :integer
  end
end
