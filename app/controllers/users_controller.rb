class UsersController < ApplicationController
  WHITELIST = [:show, :edit]
  before_filter :login_required, :except => WHITELIST
  before_filter( :except => WHITELIST ) {|c| c.send( "id_match_current_user?", c.action_name, c.params[:id] ) }
  
  # render new.rhtml
  def new
    @user = User.new

    respond_to do |format|
      format.html
      format.xml { render :xml => @user }
    end
  end

  def edit
    @user = User.find( params[:id] )
    @time_zones = ActiveSupport::TimeZone.us_zones

    respond_to do |format|
      format.html
      format.xml { render :xml => clean( @user ) }
    end
  end

  def update
    @user = User.find( params[:id] )

    respond_to do |format|
      if @user.update_attributes( params[:user] )
        flash[:notice] = 'Profile successfully updated.'
        format.html { redirect_to( @user ) }
        format.xml { head :ok }
      else
        format.html { render :action => 'edit' }
        format.xml { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    @user = User.find( params[:id] )

    respond_to do |format|
      format.html
      format.xml { render :xml => clean( @user ) }
    end
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
      # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end

  private
  # cleans the user object for rendering to xml
  # changes sensitive information to nil
  def clean( user )
    user.crypted_password = nil
    user.salt = nil
    user.remember_token = nil

    user
  end

  # authorization check to make sure the id matches the user's id
  def id_match_current_user?( action_name, id )
    if( action_name )
      logged_in? and @current_user.id == id
    end
  end
end
