module Authorize::Models

  module Lockable

    macro with_authorize_lockable
      column locked_at : Time?
      column failed_attempts : Int32?
      column unlock_token : String?
    end

    def unlock
      self.locked_at = nil
      self.failed_attempts = 0
      self.unlock_token = nil

      self.save
    end

    def lock
      self.locked_at = Time.utc
      self.failed_attempts = 0
      self.unlock_token = UUID.random.to_s

      self.save
    end

    def is_locked?
      self.locked_at != nil
    end
  end
end