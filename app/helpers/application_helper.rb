module ApplicationHelper
  def formatted_update_time(updated_at)
    if updated_at > 24.hours.ago
      # For updates within the last 24 hours, show how many hours/minutes ago
      "#{time_ago_in_words(updated_at)} ago"
    else
      # For older updates, show the date
      updated_at.strftime("%d/%m/%y")
    end
  end

  def next_direction(current_column)
    if params[:sort] == current_column && params[:direction] == "asc"
      "desc"
    else
      "asc"
    end
  end
end
