class Authorize::InvitableController < ApplicationController
  include Authorize::InvitableHooks
  getter user = User.new
  getter token : String = ""

  def new
    if cur_usr = current_user
      respond_with do
        html render_module("new.slang")
        json User.new.to_json
      end      
    else
      error_redirect "You need to be signed in to send invites."
    end
  end

  def invitations
    if cur_usr = current_user
      users = User.all("where invited_by = ? and invitation_accepted_at IS NULL and invitation_token IS NOT NULL", [cur_usr.id])
      respond_with do
        html render_module("invitations.slang")
        json users.map {|user| user.as_invitation }.to_json
      end
    else
      error_redirect "You need to be signed in to list your invitations."
    end
  end

  def create
    if cur_usr = current_user
      if user = User.find_by(email: params[:email])
        err_msg = "That email address is already registered to a user."
        flash[:danger] = err_msg
        error = {errors: [err_msg]}
        respond_with do
          html render_module("new.slang")
          json error.to_json
        end
      else
        user = User.new
        user.email = params[:email]
        if user.responds_to?(:name) && params.has_key?(:name) 
          user.name = params[:name]
        end
        
        before_invite_hook(user)
        if user.invite!(cur_usr)
          msg = "Invite successfully created & sent."
          result = {result: msg, user: user.as_invitation }
          respond_with do
            html ->{ redirect_to "/", flash: {"success" => msg} }
            json result.to_json
          end
          
          after_invite_hook(user)
        else
          err_msg = "Could not create new invite. Please try again."
          flash[:danger] = err_msg
          error = {errors: [err_msg]}
          respond_with do
            html render_module("new.slang")
            json error.to_json
          end
        end
      end
      
    else
      error_redirect "You need to be signed in to send invites."
    end   
  end

  def resend
    if (user = get_user) && (cur_usr = current_user) && (user.invited_by == cur_usr.id)
      before_resend_hook(user)
      if user.resend!(cur_usr)
        msg = "Invitation was resent to #{user.original_email}."
        result = {result: msg}
        respond_with do
          html ->{ redirect_to "/", flash: {"success" => msg} }
          json result.to_json
        end

        after_resend_hook(user)
      else 
        msg = "Invitation could not be resent to #{user.original_email}."
        result = {warning: msg}
        respond_with do
          html ->{ redirect_to "/", flash: {"warning" => msg} }
          json result.to_json
        end
      end

    else
      error_redirect "We could not find that invitation."
    end
  end

  def delete
    if (user = get_user) && (cur_usr = current_user) && (user.invited_by == cur_usr.id)
      msg = "Invitation to #{user.original_email} was deleted."
      before_delete_hook(user)
      user.delete!
      after_delete_hook(user)
      result = {result: msg}
      respond_with do
        html ->{ redirect_to "/", flash: {"success" => msg} }
        json result.to_json
      end

    else
      error_redirect "We could not find that invitation."
    end
  end

  def accept
    if user = get_user
      respond_with do
        html render_module("accept.slang")
        json user.to_json
      end 
    else
      error_redirect "We could not find that invitation."
    end
  end

  def decline
    if user = get_user
      before_decline_hook(user)
      user.decline_invitation!
      after_decline_hook(user)
      msg = "Invitation was declined, thanks for letting us know."
      result = {result: msg}
      respond_with do
        html ->{ redirect_to "/", flash: {"success" => msg} }
        json result.to_json
      end
    else
      error_redirect "We could not find that invitation."
    end
  end

  def update
    if (user = get_user) 
      user.set_attributes accept_params.validate!
      user.password = params["password"].to_s

      if user.responds_to?(:name) && params.has_key?(:name) 
        user.name = params[:name]
      end

      if (params[:password] == params[:confirm_password])
        
        before_accept_hook(user)
        user.accept_invitation!
        after_accept_hook(user)
        
        msg = "Invitation accepted, welcome."
        result = {result: msg, user: user}
        respond_with do
          html ->{ redirect_to "/", flash: {"success" => msg} }
          json result.to_json
        end
      else
        msg = "Could not accept invite. Please try again."
        flash[:danger] = msg
        result = {error: msg}
        respond_with do
          html render_module("accept.slang")
          json result.to_json
        end
      end
    else
      error_redirect "We could not find that invitation."
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
    invitable_params.validate!
    @token = params[:invitation_token]
    return User.find_by(invitation_token: token)
  end

  private def invitable_params
    params.validation do
      required :invitation_token
    end
  end

  private def accept_params
    params.validation do
      required(:email) { |f| !f.nil? }
      required(:name) { |f| !f.nil? }
      required(:password) { |f| !f.nil? }
    end
  end
end