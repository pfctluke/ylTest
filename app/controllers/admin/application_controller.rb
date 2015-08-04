class Admin::ApplicationController < ApplicationController
  before_filter :authenticate_user!
  before_filter { redirect_to :root unless current_user.role.try(:downcase) == "admin" }
  layout "admin_layout"
end