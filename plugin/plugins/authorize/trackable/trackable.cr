module Authorize::Models

  module Trackable
    macro with_authorize_trackable
      # should be in trackable
      column last_sign_in_at : Time?
      column last_sign_in_ip : String?
      column current_sign_in_at : Time?
      column current_sign_in_ip : String?
    end

    def track_signin(host : String | Nil)
      self.last_sign_in_at = self.current_sign_in_at
      self.last_sign_in_ip = self.current_sign_in_ip
      self.current_sign_in_at = Time.utc
      
      if host
        # remove the port element of remote IP
        self.current_sign_in_ip = (index = host.index(":")) ? host[0...index] : host
      else
        self.current_sign_in_ip = nil
      end
      self.save
    end
  end
end