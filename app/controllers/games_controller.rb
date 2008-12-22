class GamesController < ApplicationController
  WHITELIST = [:show, :index]

  before_filter :login_required
  before_filter( :except => WHITELIST ) {|c| c.send( "authorized_to_edit?", c.action_name, c.params[:id] ) }
  before_filter :find_game, :only => [:show, :edit, :update, :destroy]

  def index
    @games = Game.paginate :page => params[:page], :order => 'created_at DESC'

    respond_to do |format|
      format.html
      format.xml  { render :xml => @games }
    end
  end

  def new
    @game = Game.new

    respond_to do |format|
      format.html
      format.xml { redner :xml => @user }
    end
  end

  def create
    @game = Game.new( params[:game] )

    respond_to do |format|
      if @game.save
        flash[:notice] = "Game was successfully created."
        format.html { redirect_to( @game ) }
        format.xml  { render :xml => @game, :status => :created, :location => @game }
      else
        format.html { render :action => 'new' }
        format.xml  { render :xml => @game.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    respond_to do |format|
      format.html
      format.xml  { render :xml => @game }
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.xml { render :xml => @game }
    end
  end

  def update
    respond_to do |format|
      if @game.update_attributes( params[:game] )
        flash[:notice] = 'Update was successful.'
        format.html { redirect_to( @game ) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @game.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @game.destroy

    respond_to do |format|
      format.html { redirect_to( @games_url ) }
      format.xml  { head :ok }
    end
  end

  private
  # authorization check to see if allowed to change games, maybe should add a new auth check for deleting?
  def authorized_to_edit?( action_name, game_id )
    # TODO HACK HACK HACK, return true for now
    true
  end

  def find_game
    @game = Game.find( params[:id] )
  end
end
