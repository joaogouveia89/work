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
end
