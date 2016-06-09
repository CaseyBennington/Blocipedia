class CollaboratorsController < ApplicationController
  before_action :set_wiki

  def index
    @users = User.all
  end

  def create
    @collaborator = @wiki.collaborators.new(user_id: params[:user_id])

    if @collaborator.save
      flash[:notice] = "Collaborator added successfully to #{@wiki.title}"
    else
      flash[:alert] = 'An error has occured. Collaborator was not added. Please try again.'
    end

    redirect_to wiki_collaborators_path(@wiki)
  end

  def destroy
    @collaborator = Collaborator.find(params[:id])

    if @collaborator.destroy
      flash[:notice] = 'Collaborator has been removed successfully.'
    else
      flash[:alert] = 'An error has occured. Collaborator was not removed successfully. Please try again.'
    end

    redirect_to wiki_collaborators_path(@wiki)
  end

  private

  def set_wiki
    @wiki = Wiki.find(params[:wiki_id])
  end
end
