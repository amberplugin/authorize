class Authorize::DefaultMailer < Authorize::Mailer

  def confirmation_instructions(record : User, options : Hash)
    Authorize::ConfirmationMailer.new(
      (record.responds_to?(:name) ? record.name : "friend"),
      record.email,
      options
    ).deliver
  end

  def reset_password_instructions(record : User, options : Hash)
    Authorize::RecoveryMailer.new(
      (record.responds_to?(:name) ? record.name : "friend"),
      record.email,
      options
    ).deliver
  end

  def unlock_instructions(record : User, options : Hash)
    Authorize::UnlockMailer.new(
      (record.responds_to?(:name) ? record.name : "friend"),
      record.email,
      options
    ).deliver
  end

  def invitation_instructions(record : User, options : Hash)
    Authorize::InviteMailer.new(
      (record.responds_to?(:name) ? record.name : "friend"),
      record.original_email,
      options
    ).deliver
  end

end
