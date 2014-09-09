json.unprocessed do
  json.array! @unprocessed_surveys do |survey|
    json.fullName "#{survey.user.first_name} #{survey.user.last_name}"
    json.email survey.user.email
    json.date survey.created_at.to_date
    json.id survey.id
  end
end
json.processed do
  json.array! @processed_surveys do |survey|
    json.fullName "#{survey.user.first_name} #{survey.user.last_name}"
    json.email survey.user.email
    json.date survey.created_at.to_date
    json.id survey.id
  end
end


