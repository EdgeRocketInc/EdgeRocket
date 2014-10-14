json.array! @companies do |company|
  json.companyName company.company_name
  json.overview company.overview
  json.options company.options
  if company.created_at != nil
    json.date company.created_at.to_date
  else
    json.date company.created_at
  end
  json.accountType company.account_type
  json.domain company.domain
  # TODO add back when ready 
  #json.disabled company.disabled
  json.id company.id
end
