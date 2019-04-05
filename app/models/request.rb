class Request < ApplicationRecord
  has_many :request_drugs, dependent: :delete_all
  has_many :drugs, through: :request_drugs

  validates :auction_number, presence: true
end
