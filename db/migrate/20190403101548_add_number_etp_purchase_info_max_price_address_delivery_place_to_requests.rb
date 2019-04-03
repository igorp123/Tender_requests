class AddNumberEtpPurchaseInfoMaxPriceAddressDeliveryPlaceToRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :requests, :number, :string
    add_column :requests, :etp, :string
    add_column :requests, :purchase_info, :string
    add_column :requests, :max_price, :string
    add_column :requests, :delivery_place, :string
    add_column :requests, :delivery_time, :string
    add_column :requests, :exp_date, :string
  end
end
