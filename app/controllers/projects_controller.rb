class ProjectsController < ApplicationController
  before_action :set_project, only: [:edit, :update, :destroy]

  respond_to :html, :js

  def index
    @projects = Project.where(user: current_user)
    respond_with(@projects)
  end

  def new
    @project = Project.new
    respond_to do |format|
      format.js
    end
  end

  def create
    @project = Project.create(project_params)
    respond_to do |format|
      format.js { @flash_message = @project.errors.full_messages.join('\n') }
    end
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def update
    @project.update(project_params)
    respond_to do |format|
      format.js { @flash_message = @project.errors.full_messages.join('\n') }
    end
  end

  def destroy
    @project.destroy
    respond_to do |format|
      format.js
    end
  end

  private

  def project_params
    params.require(:project).permit(:id, :name).merge(params.permit(:user_id))
  end

  def set_project
    @project = Project.find(params[:id])
  end
end
