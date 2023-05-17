require 'collections/journals_report'

class DashboardsController < ApplicationController
    def index
        @today = Date.today 
        @last_month = @today- 1.month

        @open_tickets = Ticket.where(status: Ticket.statuses[:open])

        dailies =  Daily.where(updated_at: Date.yesterday.beginning_of_day...Date.yesterday.end_of_day)

        @from_yesterday = {
            :num_dailies => dailies.count,
            :num_worked_tasks => dailies.map{ |d| d.ticket.id }.uniq.count,
            :has_journal => !Journal.where(updated_at: Date.yesterday.beginning_of_day...Date.yesterday.end_of_day).empty?
        }

        closed_tickets_map = Ticket.where(status: Ticket.statuses[:closed], updated_at: (@last_month.beginning_of_month)...@today).group_by { |d| d.updated_at.month }
        journals_map = Journal.where(updated_at: (@last_month.beginning_of_month)...@today.end_of_day).group_by { |d| d.updated_at.month }
        

        @current_month_vs_las_month = {
            :closed_tickets => {
                :total => closed_tickets_map[@last_month.month].size + closed_tickets_map[@today.month].size,
                :last_month => closed_tickets_map[@last_month.month].size,
                :current_month => closed_tickets_map[@today.month].size
            },
            :journals =>{
                :total => journals_map[@last_month.month].size + journals_map[@today.month].size,
                :last_month => JournalsReport.new(journals_map[@last_month.month]),
                :current_month => JournalsReport.new(journals_map[@today.month]) 
            }
        }
        
        @current_month_vs_las_month[:closed_tickets][:perc_diff] = percentage_calculation(@current_month_vs_las_month[:closed_tickets][:current_month], @current_month_vs_las_month[:closed_tickets][:last_month]) - 100
        @current_month_vs_las_month[:journals][:perc_diff] = percentage_calculation(@current_month_vs_las_month[:journals][:current_month].size, @current_month_vs_las_month[:journals][:last_month].size)  - 100
    end

    private

    def percentage_calculation value, hundred
        (100 * value) / hundred
    end
end
