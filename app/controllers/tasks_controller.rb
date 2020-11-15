class TasksController < ApplicationController
  before_action :set_task, only: [:edit, :update, :destroy, :raise, :lower]

  def new
    @task = Task.new
    respond_to do |format|
      format.js
    end
  end

  def create
    @task = Task.create(task_params.merge(priority: set_priority))

    respond_to do |format|
      format.js do
        @project = @task.project
        @flash_message = @task.errors.full_messages.join('\n')
      end
    end
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def update
    @task.update(task_params)

    respond_to do |format|
      format.js do
        @project = @task.project
        @flash_message = @task.errors.full_messages.join('\n')
      end
    end
  end

  def destroy
    @task.destroy

    respond_to do |format|
      format.js do
        @project = @task.project
      end
    end
  end

  def raise
    @task.increase_priority(@task)
    @task.save

    respond_to do |format|
      format.js do
        @project = @task.project
        @flash_message = @task.errors.full_messages.join('\n')
        render 'prioritize'
      end
    end
  end

  def lower
    @task.lower_priority(@task)
    @task.save
    respond_to do |format|
      format.js do
        @project = @task.project
        @flash_message = @task.errors.full_messages.join('\n')
        render 'prioritize'
      end
    end
  end

  private

  def task_params
    params.require(:task).permit(:id, :name, :status, :priority, :deadline).merge(params.permit(:name, :project_id))
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def set_priority
    Project.find(task_params[:project_id]).tasks.count + 1
  end
end
