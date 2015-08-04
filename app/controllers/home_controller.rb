class HomeController < ApplicationController
  
  def index
    @news = News.where("show_time is not null").order("priority DESC", "show_time DESC").first(4)
    @carousels = Carousel.order("priority DESC", "created_at DESC").first(3)
    @messages = Message.where("deleted = FALSE").order("priority DESC", "created_at DESC", "id DESC").first(20)
    @clubs = Club.where('status' => 2).order("priority DESC", "created_at DESC").first(8)
    @venues = Venue.order("priority DESC", "created_at DESC").first(8)
    @users = User.where('status' => 2).where('is_coach' => true).order("created_at DESC").first(8)
    @competitions = Competition.where("show_on_home_page = ?", 1).order("priority DESC", "first_game_day DESC", "created_at DESC")
    if request.headers['X-PJAX']
      render :layout => false
    end
    render :layout => "header_only_layout"
  end

end
