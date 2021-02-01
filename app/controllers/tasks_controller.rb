class TasksController < ApplicationController
  before_filter :authenticate_user!

  def index
    @tasks = current_user.tasks.group_by { |task| task.due_time.to_date }
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
    if task.update_attributes(task_params)
      redirect_to task
    else
      render :edit
    end
  end

  def destroy
    task.destroy

    redirect_to root_path
  end

  private

  def task
    @task ||= current_user.tasks.find(params[:id])
  end

  def build_task
    @task = current_user.tasks.build(task_params)
  end

  def task_params
    params.fetch(:task, {})
  end
end
