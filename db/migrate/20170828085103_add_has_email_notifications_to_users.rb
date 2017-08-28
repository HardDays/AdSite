class AddHasEmailNotificationsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :has_email_notifications, :boolean
  end
end
