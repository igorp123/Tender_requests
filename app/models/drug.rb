class Drug < ApplicationRecord
  has_many :request_drugs
  has_many :requests, through: :request_drugs
end
