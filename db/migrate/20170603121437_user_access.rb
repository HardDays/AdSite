class UserAccess < ActiveRecord::Migration[5.1]
  def change
  	create_table :accesses_users, id: false do |t|
      t.belongs_to :user, index: true
      t.belongs_to :access, index: true
    end
  end
end
