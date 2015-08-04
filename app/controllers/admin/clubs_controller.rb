class Admin::ClubsController < Admin::ApplicationController
  
  $pageSize = 10
  def index
    @title = "俱乐部列表"
    @clubs = Club.paginate(:page => params[:page], :per_page => $pageSize ).order("status", "id")
  end
  
  def destroy
    @club = Club.find(params[:id])
    @club.destroy
    redirect_to admin_clubs_path
  end

  def updateStatus
    @club = Club.find(params[:id])
    if @club.status.to_i != params[:status].to_i
      @club.status = params[:status]
      if @club.save
        @user = @club.users.where('club_user_relationships.permission' => 0).first
        if @user.present? && @user.phone.present? && params[:status].to_i == 2
          sendApprovementMsg(@user.phone, @club.name)
        end
      end
    end
    redirect_to admin_clubs_path
  end
  
  #发送短信
  def sendApprovementMsg(phone, name)
    data = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><sendSMS xmlns="http://sdkhttp.eucp.b2m.cn/"><arg0 xmlns="">6SDK-EMY-6688-KCURQ</arg0><arg1 xmlns="">Aiw@8Ldk093kLdca1</arg1><arg2 xmlns=""></arg2><arg3 xmlns="">' + phone.to_s + '</arg3><arg4 xmlns="">【苏州园区网协】您注册的俱乐部“' + name + '”成功通过审核。您现在可以登录苏州工业园区网协网站进行查看。</arg4><arg5 xmlns=""></arg5><arg6 xmlns="">gbk</arg6><arg7 xmlns="">5</arg7><arg8 xmlns="">0</arg8></sendSMS></soapenv:Body></soapenv:Envelope>'
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
