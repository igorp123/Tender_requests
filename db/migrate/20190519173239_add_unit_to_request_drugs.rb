class AddUnitToRequestDrugs < ActiveRecord::Migration[5.2]
  def change
    add_column :request_drugs, :unit, :string
  end
end
