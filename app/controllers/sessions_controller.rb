# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController

  # ログイン
  def new
  end

  def create
    logout_keeping_session!
    if using_open_id?
      open_id_authentication
    else
      password_authentication
    end
  end

  # ログアウト
  def destroy
    logout_killing_session!
    flash[:notice] = "ログアウトに成功しました。"
    redirect_back_or_default('/')
  end

  protected

  # パスワードによる認証処理
  def password_authentication
    user = User.authenticate(params[:login], params[:password])
    if user
      self.current_user = user
      successful_login
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  # OpenIDによる認証処理
  def open_id_authentication
    authenticate_with_open_id do |result, identity_url|
      # RPからの認証に成功
      if result.successful?
        if self.current_user = User.find_by_identity_url(identity_url)
          successful_login
        else
          # 登録がない場合
          failed_login "#{identity_url}の認証IDを持つユーザーは存在しません"
        end
      else
        failed_login result.message
      end
    end
  end

  # ログインに成功
  def successful_login(message=nil)
    new_cookie_flag = (params[:remember_me] == "1")
    handle_remember_cookie! new_cookie_flag
    redirect_back_or_default('/')
    flash[:notice] = "ログインに成功しました。"
  end

  # ログインに失敗
  def failed_login(message=nil)
    flash[:error] = message
    render :action => 'new'
  end
  
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
