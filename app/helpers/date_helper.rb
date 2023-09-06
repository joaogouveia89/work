module DateHelper
  def date_difference_in_words(start_date, end_date)
    seconds_diff = (end_date - start_date).to_i

    if seconds_diff < 60
      "#{seconds_diff} second#{seconds_diff == 1 ? '' : 's'}"
    elsif seconds_diff < 3600
      minutes_diff = (seconds_diff / 60).to_i
      "#{minutes_diff} minute#{minutes_diff == 1 ? '' : 's'}"
    elsif seconds_diff < 86400
      hours_diff = (seconds_diff / 3600).to_i
      "#{hours_diff} hour#{hours_diff == 1 ? '' : 's'}"
    elsif seconds_diff < 2592000 # Approximate days in a month
      days_diff = (seconds_diff / 86400).to_i
      "#{days_diff} day#{days_diff == 1 ? '' : 's'}"
    elsif seconds_diff < 31536000 # Approximate days in a year
      months_diff = (seconds_diff / 2592000).to_i
      "#{months_diff} month#{months_diff == 1 ? '' : 's'}"
    else
      years_diff = (seconds_diff / 31536000).to_i
      "#{years_diff} year#{years_diff == 1 ? '' : 's'}"
    end
  end
end