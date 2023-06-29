class API::V1::SearchController < API::V1::RestfulController

  def index
    @search = Discussion.weighted_search_for(params[:q].strip, current_user, search_params)
    @search = @search.where('discussions.group_id IN (?)', group_ids) if params[:group_id]

    respond_with_collection
  end

  private
  def group_ids
    case params[:subgroups]
    when 'all', 'mine'
      Group.find(params[:group_id]).parent_or_self.id_and_subgroup_ids
    else
      Array(params[:group_id])
    end
  end

  def search_params
    params.slice(:from, :per)
  end

  def serializer_root
    :search_results
  end

  def serializer_class
    SearchResultSerializer
  end
end
