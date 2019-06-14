class Dosage < ApplicationRecord
  belongs_to :customer_drug

  #belongs_to :requests
end
