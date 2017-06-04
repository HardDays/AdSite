class RemoveTypeIdFromCompanies < ActiveRecord::Migration[5.1]
  def change
    remove_column :companies, :type_id, :integer #
  end
end
