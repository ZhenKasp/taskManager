class TasksController < ApplicationController
  before_filter :authenticate_user!

  def index
    @tasks = current_user.tasks
  end

  def show
    task
  end

  def new
    build_task
  end

  def create
    if build_task.save
      redirect_to task
    else
      render :new
    end
  end

  def edit
    task
  end

  def update
    if task.update_attributes(params[:task])
      redirect_to task
    else
      render action: :edit
    end
  end

  def destroy
    redirect_to root_path if task.destroy
  end

  private

  def task
    @task ||= current_user.tasks.find(params[:id])
  end

  def build_task
    @task = current_user.tasks.build(params[:task])
  end
end
