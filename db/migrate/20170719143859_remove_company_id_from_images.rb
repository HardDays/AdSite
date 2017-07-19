class RemoveCompanyIdFromImages < ActiveRecord::Migration[5.1]
  def change
    remove_column :images, :company_id, :integer
  end
end
