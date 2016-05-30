class WikisController < ApplicationController
  # before_action :require_sign_in, except: [:index, :show, :edit, :update]
  # before_action :authorize_user, only: :destroy
  before_action :authenticate_user!, except: [:index, :show, :edit, :update]

  def index
    @wikis = policy_scope(Wiki)
    if current_user.present?
      authorize @wikis
    else
      skip_authorization
    end
  end

  def show
    @wiki = Wiki.find(params[:id])
    authorize @wiki

    # unless @wiki.private || current_user
    #   flash[:alert] = 'You must be signed in to view private wiki.'
    #   redirect_to new_user_session_path
    # end
  end

  def new
    @wiki = Wiki.new
    authorize @wiki
  end

  def edit
    @wiki = Wiki.find(params[:id])
    authorize @wiki
  end

  def create
    @wiki = Wiki.new(wiki_params)
    @wiki.user = current_user
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
    @wiki = Wiki.find(params[:id])
    @wiki.assign_attributes(wiki_params)
    authorize @wiki

    if @wiki.save
      flash[:notice] = 'Wiki was updated successfully.'
      redirect_to @wiki
    else
      flash.now[:alert] = 'Error saving wiki. Please try again.'
      render :edit
    end
  end

  def destroy
    @wiki = Wiki.find(params[:id])
    authorize @wiki

    if @wiki.destroy
      flash[:notice] = "\"#{@wiki.title}\" was deleted successfully."
      redirect_to action: :index
    else
      flash.now[:alert] = 'There was an error deleting the wiki.'
      render :show
    end
  end

  private

  def wiki_params
    params.require(:wiki).permit(:title, :body, :private)
  end

  # def authorize_user
  #   unless current_user.admin? || Wiki.find(params[:id]).user == current_user
  #     flash[:alert] = 'You must be an admin or this wiki\'s author to do that.'
  #     redirect_to wikis_path
  #   end
  # end
end
