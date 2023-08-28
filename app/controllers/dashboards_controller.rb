require 'collections/journals_report'


class DashboardsController < ApplicationController
    def index
        @today = Date.today 
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
            "7" => {
                "closed_tickets" => closed_tickets_365.filter{ |ct| ct.updated_at > (@today - 7).beginning_of_day }.count,
                "notes" => notes_365.filter{ |n| n.updated_at > (@today - 7).beginning_of_day }.count,
                "journals" => journals_365.filter{ |j| j.updated_at > (@today - 7).beginning_of_day }.count,
                "journal_average" => (journals_365.filter{ |j| j.updated_at > (@today - 7).beginning_of_day }.map{ |j| [j.meetings, j.current_task, j.team_interaction, j.humor] }.flatten.sum/journals_365.filter{ |j| j.updated_at > (@today - 7).beginning_of_day }.map{ |j| [j.meetings, j.current_task, j.team_interaction, j.humor] }.flatten.size.to_f)
            },
            "30" => {
                "closed_tickets" => closed_tickets_365.filter{ |ct| ct.updated_at > (@today - 30).beginning_of_day }.count,
                "notes" => notes_365.filter{ |n| n.updated_at > (@today - 30).beginning_of_day }.count,
                "journals" => journals_365.filter{ |j| j.updated_at > (@today - 30).beginning_of_day }.count,
                "journal_average" => (journals_365.filter{ |j| j.updated_at > (@today - 30).beginning_of_day }.map{ |j| [j.meetings, j.current_task, j.team_interaction, j.humor] }.flatten.sum/journals_365.filter{ |j| j.updated_at > (@today - 30).beginning_of_day }.map{ |j| [j.meetings, j.current_task, j.team_interaction, j.humor] }.flatten.size.to_f)
            },
            "365" => {
                "closed_tickets" => closed_tickets_365.count,
                "notes" => notes_365.count,
                "journals" => journals_365.count,
                "journal_average" => (journals_365.map{ |j| [j.meetings, j.current_task, j.team_interaction, j.humor] }.flatten.sum/journals_365.map{ |j| [j.meetings, j.current_task, j.team_interaction, j.humor] }.flatten.size.to_f)
            }
        }
    end
end
