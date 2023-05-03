module ApplicationHelper
    def date_ty_simplifier date
        now = Time.now.to_date
        date = date.to_date
        if date == now
            "hoje"
        elsif date == (now - 1)
            "ontem"
        else
            date.strftime("%d/%m/%Y")
        end
    end

    def diff_in_days date1
        (Time.now.to_date - date1.to_date).to_i
    end
end
