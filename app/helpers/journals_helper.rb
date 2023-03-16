module JournalsHelper

    def calendar_class_chain(day, today, journals)
        classes = ""
        event_days = journals.map{|j| j.updated_at.to_date }
        
        if today.month == day.month - 1
            classes += " next-month"
        elsif today.month == day.month + 1
            classes += " prev-month"
        else
            if event_days.include?(day.to_date) 
                # to simplify just show journals from this month
                classes += " event"
            end
        end

        if day == today
            classes += " current-day"
        end
        classes
    end

    def get_journal_from_day(day, journals)
        journals.select{ |j| j.updated_at.to_date == day.to_date }.first
    end

    def get_journal_topic_icon scale
        case scale
        when 0
            "fa-regular fa-face-frown fa-2xl"
        when 1
            "fa-regular fa-face-meh fa-2xl"
        else
            "fa-regular fa-face-smile fa-2xl"
        end
    end
end
