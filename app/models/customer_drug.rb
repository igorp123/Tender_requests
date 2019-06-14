class CustomerDrug < ApplicationRecord
  belongs_to :request
  has_many :dosages, dependent: :destroy

  accepts_nested_attributes_for :dosages, allow_destroy: true, reject_if: :all_blank
end
