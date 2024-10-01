class UpdatesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_person, only: [:new, :create, :edit, :update, :destroy, :index, :show]
  before_action :set_update, only: [:show, :edit, :update, :destroy]

  def all_updates
    @updates = Update.includes(:person, :user).order(created_at: :desc).page(params[:page]).per(15)  # Adjust the number per page as needed
  end

  def index
    @updates = @person.updates
  end

  def show
  end

  def new
    @update = @person.updates.build
    @recent_occasions = session[:recent_occasions] || Update.select(:occasion).distinct.order(updated_at: :desc).limit(10).pluck(:occasion)
  end

  def create
    @update = @person.updates.build(update_params.merge(user_id: current_user.id))
    if @update.save
      update_recent_occasions(@update.occasion)
      redirect_to add_tags_person_update_path(@person, @update), notice: 'Update was successfully created. Now add tags.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @update.update(update_params)
      process_tags(@update, params[:update][:tag_ids])
      redirect_to person_path(@update.person), notice: 'Update was successfully updated.'
    else
      render :edit
    end
  end

  def add_tags
    @person = Person.find(params[:person_id]) # Ensure this matches the parameter name in your routes
    @update = @person.updates.find(params[:id])
  end

  def update_tags
    @update = Update.find(params[:id])
    @person = @update.person
    process_tags(@update, params[:update][:tag_ids])
    redirect_to person_path(@update.person), notice: 'Tags were successfully updated.'
  end


  def destroy
    person = @update.person
    @update.destroy
    redirect_to person_path(person), notice: 'Update was successfully deleted.'
  end

  private

  def process_tags(update, tag_ids)
    # Clear existing tags only if new tag ids are provided
    update.tags.clear if tag_ids

    # Add new tags based on the provided tag ids
    Array(tag_ids).each do |tag_id|
      tag = Tag.find_by_id(tag_id)
      update.tags << tag if tag
    end
  end

  def update_recent_occasions(new_occasion)
    recent_occasions = session[:recent_occasions] || []
    recent_occasions.delete(new_occasion) # Remove if it already exists to avoid duplicates
    recent_occasions.unshift(new_occasion) # Add to the top
    recent_occasions = recent_occasions.uniq.first(10) # Ensure uniqueness and limit to 10
    session[:recent_occasions] = recent_occasions
  end


  def set_person
    @person = Person.find(params[:person_id])
  end

  def set_update
    @update = @person.updates.find(params[:id])
  end

  def update_params
    params.require(:update).permit(:content, :person_id, :occasion, :comment_date, tag_ids: [])
  end

end
