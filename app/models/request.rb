class Request < ApplicationRecord
  has_many :request_drugs
  has_many :drugs, through: :request_drugs
end
