class Account < ActiveRecord::Base
  has_many :users
  has_many :playlists
  has_many :products
  has_many :my_courses, through: :users

  def assigned_and_completed_by_user
    final = [
      {name: "Assigned", data: {}},
      {name: "Completed", data: {}}
    ]
    my_courses.each do |course|
      name = course.user.name
      final[0][:data][name] = 0 if final[0][:data][name] == nil
      final[1][:data][name] = 0 if final[1][:data][name] == nil
      if course.completed?
        final[1][:data][name] += 1
      else
        final[0][:data][name] += 1
      end
    end
    final
  end

  # [
  #   {name:"Assigned", data: { "Sean Smith" => 1, "Bobby Blackstock" => 3 , "A" => 1, "b" => 2}},
  #   {name:"Completed", data: {"Bobby Blackstock" => 2, "Sean Smith" => 4 }}
  # ]

end