class API::V1::NotificationsController < API::V1::RestfulController
  def index
    instantiate_collection do |collection|
      collection.limit(30)
    end
    respond_with_collection
  end

  def viewed
    service.viewed(user: current_user)
    render json: { success: :ok }
  end

  def accessible_records
    current_user.notifications.includes(:actor, :event).order(id: :desc)
  end
end
