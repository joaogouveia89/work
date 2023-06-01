require 'collections/journals_report'

class DashboardsController < ApplicationController
    def index
        @today = Date.today 
        @last_month = @today- 1.month

        yesterday = @today.wday == 1 ? (@today - 3.day) : Date.yesterday

        @open_tickets = Ticket.where(status: Ticket.statuses[:open])

        dailies =  Daily.where(updated_at: yesterday.beginning_of_day...yesterday.end_of_day)

        @from_yesterday = {
            :num_dailies => dailies.count,
            :num_worked_tasks => dailies.map{ |d| d.ticket.id }.uniq.count,
            :has_journal => !Journal.where(updated_at: yesterday.beginning_of_day...yesterday.end_of_day).empty?
        }

        closed_tickets_map = Ticket.where(status: Ticket.statuses[:closed], updated_at: (@last_month.beginning_of_month)...@today).group_by { |d| d.updated_at.month }
        journals_map = Journal.where(updated_at: (@last_month.beginning_of_month)...@today.end_of_day).group_by { |d| d.updated_at.month }

        @current_month_vs_last_month = {
            :closed_tickets => {
                :total => map_size(closed_tickets_map[@last_month.month]) + map_size(closed_tickets_map[@today.month]),
                :last_month => map_size(closed_tickets_map[@last_month.month]),
                :current_month =>  map_size(closed_tickets_map[@today.month])
            },
            :journals =>{
                :total => map_size(journals_map[@last_month.month]) + map_size(journals_map[@today.month]),
                :last_month => journals_map[@last_month.month] == nil ? nil : JournalsReport.new(journals_map[@last_month.month]),
                :current_month => journals_map[@today.month] == nil ? nil : JournalsReport.new(journals_map[@today.month]) 
            }
        }
        
        @current_month_vs_last_month[:closed_tickets][:perc_diff] = (@current_month_vs_last_month[:closed_tickets][:current_month] == 0 || @current_month_vs_last_month[:closed_tickets][:last_month] == 0) ? 0 : (percentage_calculation(@current_month_vs_last_month[:closed_tickets][:current_month], @current_month_vs_last_month[:closed_tickets][:last_month]) - 100)
        @current_month_vs_last_month[:journals][:perc_diff] = (@current_month_vs_last_month[:journals][:current_month] == nil || @current_month_vs_last_month[:journals][:last_month] == nil) ? 0 : (percentage_calculation(@current_month_vs_last_month[:journals][:current_month].size, @current_month_vs_last_month[:journals][:last_month].size)  - 100)
    end

    private

    def percentage_calculation value, hundred
        (100 * value) / hundred
    end

    def map_size map
        map == nil ? 0 : map.size
    end
end
