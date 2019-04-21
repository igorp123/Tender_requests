class CustomerDrug < ApplicationRecord
  belongs_to :request
  has_many :dosages, dependent: :delete_all
end
