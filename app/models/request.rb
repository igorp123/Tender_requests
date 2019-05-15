class Request < ApplicationRecord

  include Models::Request::XmlParse

  has_many :request_drugs, dependent: :destroy
  has_many :drugs, through: :request_drugs
  has_many :customer_drugs, dependent: :destroy

  accepts_nested_attributes_for :request_drugs, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :customer_drugs, allow_destroy: true, reject_if: :all_blank


  validates :auction_number, presence: true


end

