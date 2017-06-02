class AddCategoryIdToCompany < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :category_id, :integer
  end
end
