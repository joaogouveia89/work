module DailiesHelper

    def show_actions? headers_list
        headers_list.size == 1 && headers_list.first.updated_at.to_date == DateTime.now.to_date
    end
end
