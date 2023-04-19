class ApplicationController < ActionController::Base
    def today
        Time.now
    end
end
