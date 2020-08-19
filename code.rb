class Api::V6::AuthController < ApplicationController
  def signin
    begin
      User.where(vDeviceToken: params[:vDeviceToken]).update_all(login_status: false, vDeviceToken: "") unless params[:vDeviceToken].blank?
      vDeviceVersion = device_version()

      vOSVersion = os_version()

      vPlatform = platform()

      if !params[:vPhone].blank?
        # SignIn/SignUp via Mobile
        return login_with_mobile(vDeviceVersion,vOSVersion,vPlatform)
      elsif !params[:vFacbookId].blank?
        # SignIn/SignUp via Facebook
        return login_with_facebook(vDeviceVersion,vOSVersion,vPlatform)
      elsif !params[:vGoogleId].blank?
        # SignIn/SignUp via Google+
        return login_with_google(vDeviceVersion,vOSVersion,vPlatform)
      end
    rescue Exception => e
      Raven.capture_exception(e)
      ecode = ApplicationHelper.get_error_code
      Rails.logger.error ">>>Exception(#{ecode}): signin - Details: params => #{params}, message => #{e}"
      render_exception(e, ecode)
      return
    end
  end

  def platform
    if params[:vPlatform]
      params[:vPlatform]
    else
      "301"
    end
  end

  def os_version
    if params[:vOSVersion]
     params[:vOSVersion]
    elsif params[:vIOSVersion]
      params[:vIOSVersion]
    end
  end
  def device_version
    if params[:vDeviceVersion]
      params[:vDeviceVersion]
    elsif params[:vIPhoneVersion]
      params[:vIPhoneVersion]
    end
  end

end
