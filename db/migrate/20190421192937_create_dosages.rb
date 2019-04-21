class CreateDosages < ActiveRecord::Migration[5.2]
  def change
    create_table :dosages do |t|
      t.string :form
      t.string :valve
      t.string :unit
      t.references :customer_drug, foreign_key: true

      t.timestamps
    end
  end
end
