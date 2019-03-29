class RequestDrug < ApplicationRecord
  belongs_to :request
  belongs_to :drug
end
