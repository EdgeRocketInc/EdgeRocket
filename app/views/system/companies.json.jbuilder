json.array! @companies do |company|
  json.companyName company.company_name
  json.overview company.overview
  json.options company.options
  json.date company.created_at.to_date
  json.accountType company.account_type
  json.domain company.domain
end
