class CtfController < ApplicationController

  def index
    @users = User.find(:all).sort {|a, b| a.score <=> b.score }
  end

  def about
    render :layout => false
  end

  def log
    render :layout => false
  end

  def score
    @users = User.find(:all).sort {|a, b| a.score <=> b.score }
    render :layout => false
  end
end
