# It's a module that can be used acorss several controllers

module PlaylistsOperations
  extend ActiveSupport::Concern


  # Add course to the playlist and to all users who are subscribed to this playlist,
  # and send email notifications to the subscribers if needed
  def add_course_to_playlist(playlist, course, user)

    playlist.products << course

    # Add it to playlist's users too
    playlist.users.each { |pl_user|
      subscribed_by = (pl_user.id==current_user.id) ? 'Self' : 'Manager'
      result = MyCourse.subscribe(pl_user.id, course.id, 'reg', subscribed_by)
      # Send email to the user if he got a new course
      #byebug
      if result == true && pl_user.id != current_user.id
        Notifications.playlist_course_added(pl_user, playlist, course, request.protocol + request.host_with_port).deliver
      end
    }

   end


end