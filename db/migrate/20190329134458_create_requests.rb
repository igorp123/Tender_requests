class CreateRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :requests do |t|
      t.string :auction_number
      t.string :customer

      t.timestamps
    end
  end
end
