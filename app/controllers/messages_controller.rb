class MessagesController < ApplicationController
  before_filter :authenticate_user!, :only => [:message_upload_view]    
  before_filter :check_edit, :only => [:message_upload_view]
  $pageSize = 10
  
  def index
    #@messages = Message.order("priority DESC", "created_at DESC").first($pageSize)
    if request.headers['X-PJAX']
      render :layout => false
    end
  end
  
  def get_messages
    page = params[:page].to_i
    offset = page * $pageSize
    messages = Message.where("deleted = FALSE").order("priority DESC", "created_at DESC", "id DESC").limit($pageSize).offset(offset)
    render :json => {:messages => messages}.to_json(:include => {:user => {:only => [:full_name], :methods => [:profile_picture_url]}}, :methods => [:message_images_first_url, :create_time_show]) 
  end
  
  #根据页码，每页数目，offset获取消息
  def get_messages_by_size
    page = params[:page].to_i
    pageSize = params[:pageSize].to_i
    offset = page * pageSize + params[:offset].to_i
    messages = Message.where("deleted = FALSE").order("priority DESC", "created_at DESC", "id DESC").limit(pageSize).offset(offset)
    render :json => {:messages => messages}.to_json(:include => {:user => {:only => [:full_name], :methods => [:profile_picture_url]}}, :methods => [:message_images_first_url, :create_time_show])
  end
  
  def message_upload_view
    @message = Message.new
    @message.message_images.build
  end
  
  def upload
    @message = Message.new(params[:message])
    if user_signed_in? && !current_user.id.blank?
      @message.user_id = current_user.id
      if @message.save
        redirect_to messages_path
      else
        @message.message_images.build
        render messages_message_upload_view_path
      end
    end
    # @message = Message.new
    # if user_signed_in? && !current_user.id.blank?
      # @message.user_id = current_user.id
      # @message.body = params[:message][:body]
      # if @message.body == nil || @message.body == "" then#判断是否为空
        # flash[:notice] = "请输入您要发布的内容！"
        # redirect_to :action => 'message_upload_view'
      # elsif @message.body.length > 255 then #判断是否长度超过255
        # flash[:notice] = "内容超出长度！"
        # redirect_to :action => "message_upload_view"
      # else
        # if @message.save then
          # if params[:message][:message_images] != nil #判断是否有图
            # @message_image = MessageImage.new
            # @message_image.message_id = @message.id
            # @message_image.image = params[:message][:message_images][:image]
              # if @message_image.save
                # flash[:notice] = "发布成功！"
                # redirect_to :action => 'index'
              # else
                # flash[:notice] = "图片上传错误！检查您上传的图片格式大小是否有误"
                # @message.destroy
                # redirect_to :action => 'message_upload_view'
              # end
          # else
            # flash[:notice] = "发布成功！"
            # redirect_to :action => 'index'
          # end
        # else
          # flash[:notice] = "保存失败！"
          # redirect_to :action => 'message_upload_view'
        # end
      # end
    # end
  end
  
  #检查是否完善信息
  def check_edit
    if user_signed_in? && current_user.full_name.blank?
      redirect_to edit_user_registration_path
    end
  end
  
end
