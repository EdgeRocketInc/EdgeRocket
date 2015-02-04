class PlaylistsController < ApplicationController

  include PlaylistsOperations

  before_action :set_playlist, only: [:show, :edit, :update, :destroy, :courses, :add_course, :remove_course]
  before_filter :authenticate_user!

  # GET /playlists
  # GET /playlists.json
  def index
    u = current_user
    account = u.account
    @playlists = account ? account.playlists.order('title') : nil
  end

  # GET /playlists/1
  # GET /playlists/1.json
  def show
  end

  # GET /playlists/new
  def new
    @playlist = Playlist.new
  end

  # GET /playlists/1/edit
  def edit
  end

  # POST /playlists.json
  # JSON only
  def create
    @playlist = Playlist.new(playlist_params)
    @playlist.account_id = current_user.account_id

    publish_keen_io(:json, :ui_actions, {
        :user_email => current_user.email,
        :action => controller_path,
        :method => action_name
    })

    respond_to do |format|
      if @playlist.save
        format.json { render action: 'show', status: :created, location: @playlist }
      else
        format.json { render json: @playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /playlists/1.json
  def update
    respond_to do |format|
      if @playlist.update(playlist_params)
        format.json { head :no_content }
      else
        format.json { render json: @playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /playlists/1.json
  def destroy
    @playlist.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  # GET /playlists/1/courses.json
  #
  # List courses in the playlist
  def courses
    @courses_json = @playlist.playlist_items.as_json(:include => :product)
    # see jbuilder
  end


  # POST /playlists/:id/courses/:course_id.json
  # JSON only
  #
  # Add course to playlist
  #
  def add_course
    course = Product.find(params[:course_id])

    add_course_to_playlist(@playlist, course, current_user)

    respond_to do |format|
      format.json { head :no_content }
    end
  end


  # DELETE /playlists/1/courses/1.json
  #
  # Remove course from the playlist
  def remove_course
    # This will delete the link that associates the playlist and the product
    @playlist.products.each { |product|
      if product.id == params[:course_id].to_i
        @playlist.products.delete(product)
      end
      # we keep going here, just in case if there are duplicate links
    }
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  # PUT /playlists/1/ranks.json
  #
  # Update ranking order of the courses in the playlist
  def update_ranks
    ranks = params[:ranks]
    ranks.each { |rank|
      PlaylistItem.update(rank['id'], :rank => rank['rank'])
    }
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_playlist
      @playlist = Playlist.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def playlist_params
      params.require(:playlist).permit(:title, :description, :mandatory)
    end
end
