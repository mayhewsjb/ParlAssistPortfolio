class TagsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tag, only: [:edit, :update, :destroy]

  # GET /tags
  def index
    @tags = Tag.all
  end

  # GET /tags/new
  def new
    @tag = Tag.new
  end

  # app/controllers/tags_controller.rb
  def show
    @tag = Tag.find(params[:id])
    # This will group updates by person, assuming you have a person association in your update model
    @updates_by_person = @tag.updates.includes(:person).group_by(&:person)
  end


  # POST /tags
  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      render json: @tag, status: :created
    else
      render json: @tag.errors, status: :unprocessable_entity
    end
  end

  # GET /tags/:id/edit
  def edit
  end

  # PATCH/PUT /tags/:id
  def update
    if @tag.update(tag_params)
      redirect_to tags_path, notice: 'Tag was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /tags/:id
  def destroy
    if @tag.destroy
      redirect_to tags_path, notice: 'Tag was successfully deleted.'
    else
      redirect_to tags_path, alert: @tag.errors.full_messages.to_sentence
    end
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name)
  end
end
