class UpdateSurveys < ActiveRecord::Migration
  def change
    User.all.each do |user|
      unless user.preferences == nil
        Survey.create!(
          preferences: user.preferences,
          user_id: user.id,
          processed: true
        )
      end
    end
  end
end
