class Request < ApplicationRecord
  has_many :request_drugs, dependent: :delete_all
  has_many :drugs, through: :request_drugs
  has_many :customer_drugs, dependent: :delete_all

  accepts_nested_attributes_for :request_drugs, allow_destroy: true, reject_if: :all_blank, allow_destroy: true

  validates :auction_number, presence: true
end
