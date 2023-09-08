module DashboardHelper
    def date_diff_in_days date1, date2
        (date1.to_date - date2.to_date).to_i
    end

    def get_journal_topic_icon scale
        case scale
        when 0
            "fa-solid fa-face-frown fa-2xl"
        when 1
            "fa-solid fa-face-meh fa-2xl"
        else
            "fa-solid fa-face-smile fa-2xl"
        end
    end

    def get_journal_topic_color scale
        case scale
        when 0
            "danger"
        when 1
            "warning"
        else
            "success"
        end
    end
end
