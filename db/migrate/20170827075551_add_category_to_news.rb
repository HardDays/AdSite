class AddCategoryToNews < ActiveRecord::Migration[5.1]
  def change
    add_column :news, :category, :string
  end
end
