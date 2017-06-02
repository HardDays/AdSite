class RemoveCategoryIdFromCompany < ActiveRecord::Migration[5.1]
  def change
    remove_column :companies, :category_id, :integer
  end
end
