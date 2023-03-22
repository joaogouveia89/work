module TasksHelper
    def bs_status_badge ticket
        html = '<span class="badge rounded-pill bg-'
        case ticket.status
        when Ticket.statuses.key(0)
            html = html + "primary"
        when Ticket.statuses.key(1)
            html = html + "warning"
        when Ticket.statuses.key(2)
            html = html + "danger"
        end

        html = html + '">' +  ticket.status_title + ' </span>'
        html.html_safe
    end
end
