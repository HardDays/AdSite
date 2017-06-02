class AddSubCategoryIdToCompany < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :sub_category_id, :integer
  end
end
