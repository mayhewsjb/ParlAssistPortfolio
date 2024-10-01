class BugsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bug, only: [:show, :edit, :update, :destroy]
  skip_before_action :check_permissions, only: [:index]

  def index
    @bugs = Bug.all
  end

  def show
  end

  def new
    @bug = Bug.new
  end

  def edit
  end

  def create
    @bug = Bug.new(bug_params)
    @bug.user = current_user

    if @bug.save
      redirect_to @bug, notice: 'Bug was successfully created.'
    else
      render :new
    end
  end

  def update
    if @bug.update(bug_params)
      redirect_to @bug, notice: 'Bug was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @bug.destroy
    redirect_to bugs_url, notice: 'Bug was successfully deleted.'
  end

  private

    def set_bug
      @bug = Bug.find(params[:id])
    end

    def bug_params
      params.require(:bug).permit(:title, :description)
    end
end
