class ActivitiesChannel < ApplicationCable::Channel  
    def subscribed
        stream_from "activities_#{current_user.id}"
      end
  end  