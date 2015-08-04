class Admin::UsersController < Admin::ApplicationController
  
  $pageSize = 10
  def index
    @title = "用户列表"
    @users = User.paginate(:page => params[:page], :per_page => $pageSize ).order("role","id")
  end
  
  def edit
    @title = "用户编辑"
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if params[:user][:status].present? && params[:user][:status].to_i == 2
      now = Time.new
      @user.approval_time = now
      @user.annual_fee_validity = now
    end
    if @user.update_attributes(params[:user])
      redirect_to admin_users_path
    else
      @title = "编辑用户"
      render 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path
  end

  def updateStatus
    @user = User.find(params[:id])
    if @user.status.to_i != params[:status].to_i
      @user.status = params[:status]
      if @user.status.to_i == 2
        now = Time.new
        @user.approval_time = now
        @user.annual_fee_validity = now
      end
      if @user.save
        if @user.phone.present? && params[:status].to_i == 2
          sendApprovementMsg(@user.phone)
        end
      end
    end
    redirect_to admin_users_path
  end
  
  #发送短信
  def sendApprovementMsg(phone)
    data = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><sendSMS xmlns="http://sdkhttp.eucp.b2m.cn/"><arg0 xmlns="">6SDK-EMY-6688-KCURQ</arg0><arg1 xmlns="">Aiw@8Ldk093kLdca1</arg1><arg2 xmlns=""></arg2><arg3 xmlns="">' + phone.to_s + '</arg3><arg4 xmlns="">【苏州园区网协】您已成功注册成为苏州工业园区网协会员。您可以使用手机号登录苏州工业园区网协网站。</arg4><arg5 xmlns=""></arg5><arg6 xmlns="">gbk</arg6><arg7 xmlns="">5</arg7><arg8 xmlns="">0</arg8></sendSMS></soapenv:Body></soapenv:Envelope>'
    #data = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><sendSMS xmlns="http://sdkhttp.eucp.b2m.cn/"><arg0 xmlns="">0SDK-EBB-6688-JFWPK</arg0><arg1 xmlns="">654778</arg1><arg2 xmlns=""></arg2><arg3 xmlns="">18051091926</arg3><arg4 xmlns="">感谢您注册苏州新闻网移动客户端，您的验证码是：115654，请使用验证码完成注册。【iCityMobile】</arg4><arg5 xmlns=""></arg5><arg6 xmlns="">gbk</arg6><arg7 xmlns="">5</arg7><arg8 xmlns="">0</arg8></sendSMS></soapenv:Body></soapenv:Envelope>'
    url = 'http://sdk4report.eucp.b2m.cn:8080/sdk/SDKService'
    
    response = RestClient.post url, data,{"Content-Type"=> "text/xml; charset=utf-8", "Content-Length" => data.length.to_s }
    case response.code
    when 200
      hash = Hash.from_xml(response)
      result = hash["Envelope"]["Body"]["sendSMSResponse"]["return"]
      return result
    else
      return nil
    end
  end
end
