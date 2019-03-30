json.extract! request_drug, :id, :created_at, :updated_at
json.url request_drug_url(request_drug, format: :json)
