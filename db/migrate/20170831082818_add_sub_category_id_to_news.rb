class AddSubCategoryIdToNews < ActiveRecord::Migration[5.1]
  def change
    add_column :news, :sub_category_id, :integer
  end
end
