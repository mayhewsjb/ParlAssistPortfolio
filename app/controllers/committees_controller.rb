class CommitteesController < ApplicationController
  before_action :authenticate_user!

  def index
    @committees = Committee.where("LOWER(name) NOT LIKE '%bill%'")
    @current_committee_memberships = []
    @past_committee_memberships = []

    if params[:search].present?
      search_term = "%#{params[:search].downcase}%"
      @committees = @committees.where("LOWER(name) LIKE ?", search_term)

      @people = Person.where("LOWER(name) LIKE ?", search_term)
      @people.each do |person|
        current_memberships = person.committee_memberships.joins(:committee)
                                 .where("LOWER(committees.name) NOT LIKE '%bill%'")
                                 .where('committee_memberships.end_date IS NULL OR committee_memberships.end_date > ?', Time.now)
        @current_committee_memberships += current_memberships unless current_memberships.empty?

        past_memberships = person.committee_memberships.joins(:committee)
                              .where("LOWER(committees.name) NOT LIKE '%bill%'")
                              .where('committee_memberships.end_date <= ?', Time.now)
        @past_committee_memberships += past_memberships unless past_memberships.empty?
      end
    end
  end

  def show
    @committee = Committee.find(params[:id])
    return if @committee.name.downcase.include?('bill')

    @current_members = @committee.people.joins(:committee_memberships)
                            .where('committee_memberships.end_date IS NULL OR committee_memberships.end_date > ?', Time.now)
                            .distinct
    @past_members = @committee.people.joins(:committee_memberships)
                          .where('committee_memberships.end_date <= ?', Time.now)
                          .distinct
  end
end
