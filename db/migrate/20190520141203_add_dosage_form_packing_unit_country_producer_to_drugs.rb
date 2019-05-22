class AddDosageFormPackingUnitCountryProducerToDrugs < ActiveRecord::Migration[5.2]
  def change
    add_column :drugs, :dosage_form, :string
    add_column :drugs, :packing, :string
    add_column :drugs, :unit, :string
    add_column :drugs, :producer, :string
    add_reference :drugs, :country, foreign_key: true
  end
end
