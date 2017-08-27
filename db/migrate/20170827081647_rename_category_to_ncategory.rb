class RenameCategoryToNcategory < ActiveRecord::Migration[5.1]
  def change
    rename_column :news, :category, :ncategory
  end
end
