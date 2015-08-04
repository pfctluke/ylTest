class ErrorController < ApplicationController
  
  #浏览器版本太低
  def browser
    render layout: false
  end

end
