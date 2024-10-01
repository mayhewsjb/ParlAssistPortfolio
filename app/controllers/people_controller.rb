class PeopleController < ApplicationController
  before_action :authenticate_user!

  def edit_notes
    @person = Person.find(params[:id])
  end

  def update_notes
    @person = Person.find(params[:id])
    if @person.update(notes_params)
      redirect_to @person, notice: 'Notes were successfully updated.'
    else
      render :edit_notes
    end
  end

  def index
    @people = Person.all.includes(:updates)

    apply_filters = false

    if params[:region_ids].present? && params[:region_ids].reject(&:empty?).any?
      @people = @people.where(region_id: params[:region_ids].reject(&:empty?))
      apply_filters = true
    end

    if params[:search].present? && params[:search].strip != ''
      @people = @people.where("LOWER(name) LIKE ? OR LOWER(constituency) LIKE ?", "%#{params[:search].strip.downcase}%", "%#{params[:search].strip.downcase}%")
      apply_filters = true
    end

    if params[:majority_min].present?
      @people = @people.where('majority >= ?', params[:majority_min])
      apply_filters = true
    end

    if params[:majority_max].present?
      @people = @people.where('majority <= ?', params[:majority_max])
      apply_filters = true
    end

    if params[:start_date].present?
      @people = @people.where('membership_start_date >= ?', params[:start_date])
      apply_filters = true
    end

    if params[:end_date].present?
      @people = @people.where('membership_start_date <= ?', params[:end_date])
      apply_filters = true
    end

    if params[:sort].present? && params[:sort].strip != ''
      case params[:sort]
      when 'majority_asc'
        @people = @people.order(majority: :asc)
      when 'majority_desc'
        @people = @people.order(majority: :desc)
      when 'area_asc'
        @people = @people.order(area: :asc)
      when 'area_desc'
        @people = @people.order(area: :desc)
      when 'membership_start_asc'
        @people = @people.order(membership_start_date: :asc)
      when 'membership_start_desc'
        @people = @people.order(membership_start_date: :desc)
      when 'name_asc'
        @people = @people.order('name ASC')
      when 'name_desc'
        @people = @people.order('name DESC')
      when 'constituency_asc'
        @people = @people.order(constituency: :asc)
      when 'constituency_desc'
        @people = @people.order(constituency: :desc)
      end
      apply_filters = true
    end

    if params[:tag_ids].present? && params[:tag_ids].reject(&:empty?).any?
      tagged_update_ids = Tagging.where(tag_id: params[:tag_ids].reject(&:empty?)).pluck(:related_update_id)
      tagged_person_ids = Update.where(id: tagged_update_ids).pluck(:person_id).uniq
      @people = @people.where(id: tagged_person_ids)
      apply_filters = true
    end

    unless apply_filters
      @people = @people.sort_by { |person| person.name.split.last.downcase }
      # Convert array to a paginatable collection
      @people = Kaminari.paginate_array(@people).page(params[:page]).per(25)
    else
      # Apply pagination normally when @people is an ActiveRecord::Relation
      @people = @people.page(params[:page]).per(25)
    end

    @area_rankings = Person.order(area: :desc).pluck(:area).uniq
    @area_ranks = @people.map { |p| @area_rankings.index(p.area) + 1 if p.area.present? }
  end


  def export
    @people = apply_filters(Person.all.includes(:updates))

    respond_to do |format|
      format.xlsx do
        response.headers['Content-Disposition'] = "attachment; filename=People_#{Time.now.strftime('%Y%m%d%H%M%S')}.xlsx"
      end
    end
  end


  def show
    @person = Person.find(params[:id])
    @current_committees = @person.committee_memberships.where(end_date: nil)
    .select { |membership| !membership.committee.name.downcase.include?('bill') }
    @past_committees = @person.committee_memberships.where.not(end_date: nil)

    constituency_name = @person.constituency
    constituency_search_url = "https://members-api.parliament.uk/api/Location/Constituency/Search?searchText=#{constituency_name}&skip=0&take=20"
    search_response = HTTParty.get(constituency_search_url)
    if search_response.success? && search_response.parsed_response["items"].any?
      constituency_id = search_response.parsed_response["items"].first["value"]["id"]
      geometry_url = "https://members-api.parliament.uk/api/Location/Constituency/#{constituency_id}/Geometry"
      geometry_response = HTTParty.get(geometry_url)
      if geometry_response.success?
        @constituency_geometry = geometry_response.parsed_response["value"]
      end
    end

    ranked_areas = Person.order(area: :desc).pluck(:id, :area).map(&:last)
    @area_rank = ranked_areas.index(@person.area) + 1 if @person.area

    if geometry_response.success?
      geometry_data = JSON.parse(geometry_response.parsed_response["value"])
      # Assuming the geometry is a polygon and you want the first set of coordinates
      @constituency_coordinates = geometry_data["coordinates"].first
    end
    uk_location = Geocoder.search("United Kingdom").first
    @uk_coordinates = [uk_location.longitude, uk_location.latitude] if uk_location
  end

  def new
    @person = Person.new
  end

  def create
    @person = Person.new(person_params)
    @person.creating_user_id = current_user.id

    if @person.save
      redirect_to @person, status: :see_other, notice: 'Person was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @person = Person.find(params[:id])
  end

  def update
    @person = Person.find(params[:id])
    if @person.update(person_params)
      redirect_to @person, status: :see_other, notice: 'Person was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @person = Person.find(params[:id])
    @person.destroy
    redirect_to people_url, notice: 'Person was successfully deleted.'
  end

  private

  def notes_params
    params.require(:person).permit(:notes)
  end

  def person_params
    params.require(:person).permit(:name, :party, :role, :notes, :region_id)
  end

  def apply_filters(scope)
    if params[:region_ids].present? && params[:region_ids].reject(&:empty?).any?
      scope = scope.where(region_id: params[:region_ids].reject(&:empty?))
    end

    if params[:search].present? && params[:search].strip != ''
      scope = scope.where("name LIKE ? OR constituency LIKE ?", "%#{params[:search].strip}%", "%#{params[:search].strip}%")
    end

    if params[:majority_min].present?
      scope = scope.where('majority >= ?', params[:majority_min])
    end

    if params[:majority_max].present?
      scope = scope.where('majority <= ?', params[:majority_max])
    end

    if params[:start_date].present?
      scope = scope.where('membership_start_date >= ?', params[:start_date])
    end

    if params[:end_date].present?
      scope = scope.where('membership_start_date <= ?', params[:end_date])
    end

    if params[:sort].present? && params[:sort].strip != ''
      case params[:sort]
      when 'majority_asc'
        scope = scope.order(majority: :asc)
      when 'majority_desc'
        scope = scope.order(majority: :desc)
      when 'area_asc'
        scope = scope.order(area: :asc)
      when 'area_desc'
        scope = scope.order(area: :desc)
      when 'membership_start_asc'
        scope = scope.order(membership_start_date: :asc)
      when 'membership_start_desc'
        scope = scope.order(membership_start_date: :desc)
      when 'name_asc'
        scope = scope.sort_by { |person| person.name.split.last.downcase }
      when 'name_desc'
        scope = scope.sort_by { |person| person.name.split.last.downcase }.reverse
      when 'constituency_asc'
        scope = scope.order(constituency: :asc)
      when 'constituency_desc'
        scope = scope.order(constituency: :desc)
      end
    end

    if params[:tag_ids].present? && params[:tag_ids].reject(&:empty?).any?
      tagged_update_ids = Tagging.where(tag_id: params[:tag_ids].reject(&:empty?)).pluck(:related_update_id)
      tagged_person_ids = Update.where(id: tagged_update_ids).pluck(:person_id).uniq
      scope = scope.where(id: tagged_person_ids)
    end

    scope
  end


  # def sort_column
  #   # Since user_id is no longer a column, remove it from the sort options.
  #   %w[name party constituency created_at updated_at].include?(params[:sort]) ? params[:sort] : 'created_at'
  # end

  # def sort_direction
  #   %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  # end

  # def next_direction(column)
  #   column == params[:sort] && params[:direction] == 'asc' ? 'desc' : 'asc'
  # end
end
