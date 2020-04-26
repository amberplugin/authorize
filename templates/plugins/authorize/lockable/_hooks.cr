module Authorize::LockableHooks

  def before_lock_hook(lock_user) ;   end

  def after_lock_hook(lock_user) ;   end

  def before_unlock_hook(lock_user) ;   end

  def after_unlock_hook(lock_user) ;   end

  def before_unlock_token_hook(lock_user) ;   end

  def after_unlock_token_hook(lock_user) ;   end

end