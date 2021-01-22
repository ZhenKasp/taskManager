class TasksController < ApplicationController
    before_filter :authenticate_user!

  def index
    p current_user.tasks
    p Task.all
    @tasks = current_user.tasks
  end

  def show
    @task = Task.where(id: params[:id], user_id: current_user.id).first
    redirect_to root_path unless @task
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(params[:task].merge(user_id: current_user.id))
    p @task

    if @task.save
      redirect_to @task
    else
      render :new
    end
  end

  def edit
    @task = Task.where(id: params[:id], user_id: current_user.id).first
  end

  def update
    @task = Task.where(id: params[:id], user_id: current_user.id).first
    if @task&.update_attributes(params[:task])
      redirect_to @task
    else
      render :action => "edit"
    end
  end

  def destroy
    @task = Task.where(id: params[:id], user_id: current_user.id).first
    @task&.destroy
  end
end
