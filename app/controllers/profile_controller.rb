class ProfileController < ApplicationController
  before_action :set_profile, only: [:current, :edit, :update, :destroy, :get_profile_photo, :get_profile_photo_thumb]
  before_filter :authenticate_user!

  # GET /ptofile
  # HTML
  def index
  end

  # GET /ptofile/current
  # JSON
  def current
  end

  # PATCH/PUT /profile/1
  # PATCH/PUT /profile/1.json
  def update
    respond_to do |format|
      current_user.save()
      if @profile.blank?
        @profile = Profile.new
        @profile.user_id = current_user.id
      end
      if @profile.update(profile_params)
        format.html { redirect_to @profile, notice: 'Profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /upload
  def upload
    respond_to do |format|
      uploaded_io = params[:file]
      new_profile = Profile.find_by user_id: current_user.id

      if new_profile.blank?
        new_profile = Profile.new
        new_profile.user_id = current_user.id
      end

      uploaded_photo = uploaded_io.read
      
      # convert & resize, and save a photo
      image_photo = MiniMagick::Image.read(uploaded_photo)
      image_photo.thumbnail "x200"
      image_photo.format 'png'
      new_profile.photo = image_photo.to_blob
      new_profile.photo_mime_type = 'image/png'
      
      # resize and save a thumb
      image_thumb = MiniMagick::Image.read(uploaded_photo)
      image_thumb.thumbnail "x45"
      image_thumb.format 'png'
      new_profile.photo_thumb = image_thumb.to_blob
      new_profile.thumb_mime_type = 'image/png'

      new_profile.save

      format.html { head :no_content}
      format.json { head :no_content }
    end
  end

  def get_profile_photo
    image_type = 'image/png' # by default
    if @profile.blank? || @profile.photo.blank?
      file = "app/assets/images/user_default.png"
      File.open(file, "r")
      send_file file, :type => image_type, :disposition => 'inline'
    else
      if !@profile.photo_mime_type.blank?
        image_type = @profile.photo_mime_type
      end
      send_data @profile.photo, :type => image_type, :disposition => 'inline'
    end
  end

  def get_profile_photo_thumb
    image_type = 'image/png' # by default
    if @profile.blank? || @profile.photo_thumb.blank?
      file = "app/assets/images/user_default_thumb.png"
      File.open(file, "r")
      send_file file, :type => image_type, :disposition => 'inline'
    else
      if !@profile.thumb_mime_type.blank?
        image_type = @profile.thumb_mime_type
      end
      send_data @profile.photo_thumb, :type => image_type, :disposition => 'inline'
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_profile
    @profile = current_user.profile
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    # TODO: figure out how to pass and recieve :user instead of :employee
    params.require(:employee).permit(:email, :first_name, :last_name)
  end

  def profile_params
    # TODO: figure out how to pass and recieve :user instead of :employee
    params.require(:profile).permit(:id, :title, :employee_identifier, :user_id)
  end
end
