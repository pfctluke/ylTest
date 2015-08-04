require 'rest-client'
require 'active_support/all'
class UtilitiesController < ApplicationController
  #获取验证码的接口
  def get_valid_code
    phone = params[:phone]
    if user_signed_in?  #已登录则使用当前用户的手机号（此种情况为用户修改手机号）
      phone = current_user.phone
    end
    if phone.present?
      validCode = ""
      6.times{ validCode<<rand(10).to_s }
      @user = User.find_by_phone(phone)
      if @user.blank?
        @user = User.new
        @user.phone = phone
        @user.status = -1
        if (Time.now.to_i - ((@user.valid_code_create_at.present?)?(@user.valid_code_create_at.to_i):0)) < 60
          render :json => {"response"=> "0","msg" => "请稍等60秒再获取验证码！"}.to_json
        else
          @user.valid_code = validCode
          @user.valid_code_create_at = Time.new
          if @user.save
            result = self.sendMsg(phone,validCode)
            if result == "0"
              render :json => {"response"=> "1","msg" => "验证码已发送 ，请注意查收！"}.to_json, :template => false
            end
          else
            render :json => {"response"=> "0","msg" => "保存失败！"}.to_json, :template => false
          end
        end
      else
        if (Time.current - @user.valid_code_create_at) < 60
           render :json => {"response"=> "0","msg" => "请稍等60秒再获取验证码！"}.to_json, :template => false
        else
          @user.valid_code = validCode
          @user.valid_code_create_at = Time.new
          @user.save
          result = self.sendMsg(phone,validCode)
          if result == "0"
            render :json => {"response"=> "1", "msg" => "验证码已发送 ，请注意查收！"}.to_json, :template => false
          end
          
        end
      end
    else
      render :json => {"response"=> "0","msg" => "手机号不能为空！"}.to_json, :template => false
    end

  end
  
  def get_valid_code_by_new_phone
    phone = params[:new_phone]
    if phone.present?
      validCode = ""
      6.times{ validCode<<rand(10).to_s }
      @user = current_user
      if @user.blank?
        redirect_to new_user_session_path
      else
        if (Time.current - @user.valid_code_create_at) < 60
           render :json => {"response"=> "0","msg" => "请稍等60秒再获取验证码！"}.to_json, :template => false
        else
          @user.new_phone = phone
          @user.valid_code = validCode
          @user.valid_code_create_at = Time.new
          @user.save
          result = self.sendMsg(phone,validCode)
          if result == "0"
            render :json => {"response"=> "1", "msg" => "验证码已发送 ，请注意查收！"}.to_json, :template => false
          end
          
        end
      end
    else
      render :json => {"response"=> "0","msg" => "手机号不能为空！"}.to_json, :template => false
    end
  end
  
  #发送短信
  def sendMsg(phone, valideCode)
    data = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><sendSMS xmlns="http://sdkhttp.eucp.b2m.cn/"><arg0 xmlns="">6SDK-EMY-6688-KCURQ</arg0><arg1 xmlns="">Aiw@8Ldk093kLdca1</arg1><arg2 xmlns=""></arg2><arg3 xmlns="">' + phone.to_s + '</arg3><arg4 xmlns="">【苏州园区网协】您的注册和登录的验证码是：' + valideCode.to_s + '，感谢您的使用。</arg4><arg5 xmlns=""></arg5><arg6 xmlns="">gbk</arg6><arg7 xmlns="">5</arg7><arg8 xmlns="">0</arg8></sendSMS></soapenv:Body></soapenv:Envelope>'
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