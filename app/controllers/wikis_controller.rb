class WikisController < ApplicationController
  before_action :set_wiki, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show, :edit, :update]

  def index
    @wikis = policy_scope(Wiki)
  end

  def show
    authorize @wiki
    @wiki = Wiki.friendly.find(params[:id])
  end

  def new
    @wiki = Wiki.new
    authorize @wiki
  end

  def edit
    authorize @wiki
  end

  def create
    @wiki = current_user.wikis.new(wiki_params)
    authorize @wiki

    if @wiki.save
      flash[:notice] = 'Wiki was saved successfully.'
      redirect_to @wiki
    else
      flash.now[:alert] = 'Error creating wiki. Please try again.'
      render :new
    end
  end

  def update
    # @wiki.assign_attributes(wiki_params)
    authorize @wiki
    
    if @wiki.update(wiki_params)
      @wiki.slug = nil
      @wiki.save!
      flash[:notice] = 'Wiki was updated successfully.'
      redirect_to @wiki
    else
      flash.now[:alert] = 'Error saving wiki. Please try again.'
      render :edit
    end
  end

  def destroy
    authorize @wiki

    if @wiki.destroy
      flash[:notice] = "\"#{@wiki.title}\" was deleted successfully."
      redirect_to action: :index
    else
      flash.now[:alert] = 'There was an error deleting the wiki.'
      render :show
    end
  end

  def current_user_admin?
    current_user.admin?
  end
  helper_method :current_user_admin?

  def current_user_premium?
    current_user.premium?
  end
  helper_method :current_user_premium?

  private

  def set_wiki
    @wiki = Wiki.friendly.find(params[:id])
  end

  def wiki_params
    params.require(:wiki).permit(:title, :body, :private, :user_id)
  end
end
