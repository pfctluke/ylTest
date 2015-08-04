class TennisEssaysController < ApplicationController
  def index
    @tennis_essays = TennisEssay.order("contribute_time DESC")
  end
  
  def show
    @essay = TennisEssay.find(params[:id])
  end
end
