json.array! @pending_users do |pending_user|
  json.fullName "#{pending_user.last_name}, #{pending_user.first_name}"
  json.email pending_user.email
  json.date pending_user.created_at.to_date
  json.id pending_user.id
  json.companyName pending_user.company_name
  json.type pending_user.user_type
end

