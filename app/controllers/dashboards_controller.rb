require 'collections/journals_report'
include DateHelper


class DashboardsController < ApplicationController
    def index
        @today = Time.zone.now
        @last_month = @today- 1.month

        yesterday = @today.wday == 1 ? (@today - 3.day) : Date.yesterday

        @quote = Quote.order("RANDOM()").take

        @number_of_open_tickets = Ticket.where(status: Ticket.statuses[:open]).size
        @number_of_open_prs = Ticket.where(status: Ticket.statuses[:pr_opened]).size
        @last_note = Daily.last

        @day_journal = Journal.where(updated_at: [@today.beginning_of_day..(@today.end_of_day)])
        
        @oneyearago = @today - 365.days

        closed_tickets_365 = Ticket.where(updated_at: [@oneyearago.beginning_of_day..(@today.end_of_day)], status: Ticket.statuses[:closed])
        notes_365 = Daily.where(updated_at: [@oneyearago.beginning_of_day..(@today.end_of_day)])
        journals_365 = Journal.where(updated_at: [@oneyearago.beginning_of_day..(@today.end_of_day)])

        @time_report = {
            "7" => fetch_time_report(7, journals_365, closed_tickets_365, notes_365),
            "30" => fetch_time_report(30, journals_365, closed_tickets_365, notes_365),
            "365" => fetch_time_report(365, journals_365, closed_tickets_365, notes_365)
        }
    end

    private 

    def fetch_time_report days_ago, journals_365, closed_tickets_365, notes_365
        journals = journals_365.filter{ |j| j.updated_at > (@today - days_ago.days).beginning_of_day }
        journals_attr_flatten = journals.map{ |j| [j.meetings, j.current_task, j.team_interaction, j.humor] }.flatten

        {
            "closed_tickets" => closed_tickets_365.filter{ |ct| ct.updated_at > (@today - days_ago.days).beginning_of_day }.count,
            "notes" => notes_365.filter{ |n| n.updated_at > (@today - days_ago.days).beginning_of_day }.count,
            "journals" => journals.count,
            "journal_average" => journals_attr_flatten.size == 0 ? 0 : (journals_attr_flatten.sum/journals_attr_flatten.size.to_f)
        }
    end
end
