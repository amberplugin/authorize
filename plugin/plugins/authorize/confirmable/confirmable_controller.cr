class Authorize::ConfirmableController < ApplicationController
  def confirm
    user = User.find_by(confirmation_token: params[:confirmation_token])
    return redirect_to "/", flash: {"danger" => "Invalid confirmation token."} if user.nil?

    if user.confirm! && user.save
      session[:user_id] = user.id
      redirect_to "/", flash: {"success" => "User has been confirmed."}
    else
      redirect_to "/", flash: {"error" => "Token has expired."}
    end
  end

  private def confirmation_params
    params.validation do
      required :confirmation_token
    end
  end
end
