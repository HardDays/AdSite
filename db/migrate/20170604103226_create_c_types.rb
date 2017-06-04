class CreateCTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :c_types do |t|
      t.string :name

      t.timestamps
      #
    end
  end
end
