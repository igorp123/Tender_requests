class CreateCustomerDrugs < ActiveRecord::Migration[5.2]
  def change
    create_table :customer_drugs do |t|
      t.string :mnn
      t.string :quantity
      t.string :dosage_form
      t.string :price
      t.string :cost
      t.references :request, foreign_key: true

      t.timestamps
    end
  end
end
