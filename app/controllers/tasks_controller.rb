class TasksController < ApplicationController
  before_filter :authenticate_user!

  def index
    @tasks = current_user.tasks
  end

  def show
    @task = current_user.tasks.find(params[:id])

    redirect_to root_path unless @task
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(params[:task])

    if @task.save
      redirect_to @task
    else
      render :new
    end
  end

  def edit
    @task = current_user.tasks.find(params[:id])
  end

  def update
    @task = current_user.tasks.find(params[:id])
    if @task.update_attributes(params[:task])
      redirect_to @task
    else
      render action: "edit"
    end
  end

  def destroy
    @task = current_user.tasks.find(params[:id])
    if @task.destroy
      redirect_to root_path
    end
  end
end
