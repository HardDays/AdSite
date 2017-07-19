class ImgChange < ActiveRecord::Migration[5.1]
  def change
    add_column(:companies, :image_id, :integer)
    remove_column :companies, :logo_file_name
    remove_column :companies, :logo_content_type
    remove_column :companies, :logo_updated_at
    remove_column :companies, :logo_file_size
  end
end
