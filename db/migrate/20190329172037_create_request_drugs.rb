class CreateRequestDrugs < ActiveRecord::Migration[5.2]
  def change
    create_table :request_drugs do |t|
      t.references :request, foreign_key: true
      t.references :drug, foreign_key: true

      t.timestamps
    end
  end
end
