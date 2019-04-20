class AddQuantityToRequestDrugs < ActiveRecord::Migration[5.2]
  def change
    add_column :request_drugs, :quantity, :integer
  end
end
