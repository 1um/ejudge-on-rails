class LoginsController < ApplicationController
  helper_method :sort_column, :sort_direction

  def index
    @logins = Login.search(params[:search]).order(sort_column + " " + sort_direction)
  end

  def update
    l = Login.find(params[:id])
    l.update_attributes(params[:login])
    render :nothing=>true and return if request.xhr?
  end

  private

  def sort_column
    Login.column_names.include?(params[:sort]) ? params[:sort] : "login"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
