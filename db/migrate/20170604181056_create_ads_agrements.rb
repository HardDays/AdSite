class CreateAdsAgrements < ActiveRecord::Migration[5.1]
  def change
    create_table :ads_agrements do |t|
      t.integer :ad_id
      t.integer :agrement_id
    end
  end
end
