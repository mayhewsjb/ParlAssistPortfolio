class RegionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @regions = Region.all
  end

  def show
    @region = Region.find(params[:id])
    @people = @region.people
  end
end
