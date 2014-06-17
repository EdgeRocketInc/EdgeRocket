#json.array!(@profiles) do |profile|
#  json.extract! profile, :id, :title, :user_id, :employee_id, :photo
#end
json.profile @profile
