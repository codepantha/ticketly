class Admin::ProjectsController < Admin::ApplicationController
  before_action :set_project, except: %i[new create]

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)

    if @project.save
      flash[:notice] = 'Project has been created.'
      redirect_to @project
    else
      flash.now[:alert] = 'Project has not been created.'
      render 'new'
    end
  end

  def edit; end

  def update
    if @project.update(project_params)
      flash[:notice] = 'Project has been updated.'
      redirect_to @project
    else
      flash.now[:alert] = 'Project has not been updated.'
      render 'edit'
    end
  end

  def destroy
    return unless @project.delete

    flash[:notice] = 'Project has been deleted.'
    redirect_to projects_path
  end

  private

  def project_params
    params.require(:project).permit(:name, :description)
  end

  def set_project
    @project = Project.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = 'The project you were looking for could not be found.'
    redirect_to projects_path
  end
end
