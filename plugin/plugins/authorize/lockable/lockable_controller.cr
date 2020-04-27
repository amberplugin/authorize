class Authorize::LockableController < ApplicationController
  include Authorize::LockableHooks

  getter lock_user = User.new
  getter token : String = ""

  def lock_user
    if (cur_usr = current_user) && (lock_user = get_user)
      before_lock_hook(lock_user)
      if lock_user.lock
        after_lock_hook(lock_user)
        msg = "User #{lock_user.email} was locked"
        result = {result: msg, user: lock_user}
        respond_with do
          html ->{ redirect_to "/", flash: {"success" => msg} }
          json result.to_json
        end
      else
        msg = "User #{lock_user.email} could not be locked"
        result = {error: msg, user: lock_user}
        respond_with do
          html ->{ redirect_to "/", flash: {"danger" => msg} }
          json result.to_json
        end
      end
    else
      error_redirect "You need to be signed in to lock users."
    end
  end

  def do_unlock(lock_user : User)
    before_unlock_hook(lock_user)
    if lock_user.unlock
      after_unlock_hook(lock_user)
      msg = "User #{lock_user.email} was unlocked"
      result = {result: msg, user: lock_user}
      respond_with do
        html ->{ redirect_to "/", flash: {"success" => msg} }
        json result.to_json
      end
    else
      msg = "User #{lock_user.email} could not be unlocked"
      result = {error: msg, user: lock_user}
      respond_with do
        html ->{ redirect_to "/", flash: {"danger" => msg} }
        json result.to_json
      end
    end
  end

  def unlock_user
    if (cur_usr = current_user) && (lock_user = get_user)
      do_unlock lock_user
    else
      error_redirect "You need to be signed in to unlock users."
    end
  end

  def unlock_token
    if lock_user = get_token_user
      do_unlock lock_user
    else
      error_redirect "We could not find that lock token."
    end
  end

  private def error_redirect(msg)
    error = {errors: [msg]}
    respond_with do
      html ->{ redirect_to "/", flash: {"danger" => msg} }
      json error.to_json
    end
  end

  private def get_user
    # find the user by the invite token
    return User.find(params["user_id"])
  end

  private def get_token_user
    # find the user by the invite token
    @token = params[:unlock_token]
    return User.find_by(unlock_token: token)
  end

end