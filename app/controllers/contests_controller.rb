class ContestsController < ApplicationController
  def show
    redirect_to contest_tasks_path(params[:id]);
  end

  def update_sid
    Ejudge2::Application.config.sid_hash[params[:id]]=params[:sid]
    redirect_back
  end

  def stage_changes
    Ejudge2::Application.config.push_hash[params[:id]] = false
    redirect_back
  end
end
