#encoding: UTF-8
class TasksController < ApplicationController

  def index
    @contest = Contest.find(params[:contest_id])
    redirect_to :action => "show", :contest_id=> @contest.id, :id=>@contest.tasks.sort.first.id
  end
  def show
    @contest, @task = current_contest_task
    @tasks = @contest.tasks.sort
    @tests = @task.tests.sort
    render text: "Задача не найдена" unless @task
    if request.xhr?
      render :partial => "task", :layout=> false
      return
    end
  end

  def create_from
    render :nothing=>true
  end

  def update
    @contest, @task = current_contest_task
    @task.update_attributes(params[:task]);
    @task.save
    Ejudge2::Application.config.push_hash[@contest.id]=true
    render :nothing=>true
  end

  def make_copy
  end

  def test_auth
  end

  def current_contest_task
    contest = Contest.find(params[:contest_id])
    task = contest.tasks.find{|t| t.name.match(/#{params[:id]}/)}
    [contest,task]
  end
end
