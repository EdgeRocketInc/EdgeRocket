class UserAccount
  def initialize(pending_user,hostname)
    @pending_user = pending_user
    @hostname = hostname
  end

  def save_user(generated_password)
    account_exists = Account.find_by(:company_name => @pending_user.company_name)
    if account_exists
      @user = User.new(
        :account_id => account_exists.id, 
        :email => @pending_user.email, 
        :password => @pending_user.encrypted_password, 
        :first_name => @pending_user.first_name, 
        :last_name => @pending_user.last_name
      )
    else
      @account = Account.new(:company_name => @pending_user.company_name, :account_type => @pending_user.user_type)
      
      # set default options
      # TODO move it to a more flexible configuration file/etc.

      @account.options = '{"budget_management":false,"survey":true,"discussions":"builtin","recommendations":false,"disable_search":false,"disable_plans":true,"dashboard_demo":false}'
      @account.overview = '<p>EdgeRocket provides access to learning resources -- such as online courses, articles and videos -- on business and technical topics.  Quick tips:</p><ol><li>Go to <a href="/search">Search</a> page to search for learning content.</li><li>Once you identify a course or article of interest on the <a href="/search">Search</a> page, click and select "Add to Wishlist," and it will appear in your Wishlist on the <a href="/my_courses">My Courses</a> page.</li><li>As you complete various courses or content, you&#39;re invited to share comments and recommendations (click "C" for Completed next to the item on <a href="/my_courses">My Courses</a> page).</li><li>The playlists (listed below and detailed on <a href="/my_courses">My Courses</a> page) are curated collections of content about specific job functions or important topics. A user with an administrator role can create playlists under <a href="/playlists">Manage>Playlists</a>.</li></ol><p>For a screencast about basic functionality, click <a href="https://vimeo.com/100743097" target="_blank">EdgeRocket Introduction</a>.</p><p>Questions? Contact <a href="mailto:support@edgerocket.co">support@edgerocket.co</a></p>'
      @account.save
      
      # Clone default Playlists here
      Playlist.clone_with_items(@account.id, 3008)
      Playlist.clone_with_items(@account.id, 3023)

      @user = User.new(:account_id => @account.id, :email => @pending_user.email, :password => @pending_user.encrypted_password, :first_name => @pending_user.first_name, :last_name => @pending_user.last_name)
    end

    @user.encrypted_password = @pending_user.encrypted_password
    if @user.save
      Notifications.account_confirmation_email(@user, @hostname, generated_password).deliver
      # Add SA role to new users with new accounts only!
      if !account_exists
        @role = Role.new(name:'SA', user_id: @user.id)
        @role.save
      end
      @pending_user.destroy
    else
      # TODO crtitical error
    end
  end

end