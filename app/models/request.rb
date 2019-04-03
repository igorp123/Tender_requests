class Request < ApplicationRecord
  has_many :request_drugs
  has_many :drugs, through: :request_drugs

  def get_customer
    self.customer = "Igor Plotnikov"
  end
end
