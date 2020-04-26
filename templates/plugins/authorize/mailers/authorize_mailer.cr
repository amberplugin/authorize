abstract class Authorize::Mailer
  abstract def confirmation_instructions(record : User, options : Hash)
  abstract def reset_password_instructions(record : User, options : Hash)
  abstract def unlock_instructions(record : User, options : Hash)
  abstract def invitation_instructions(record : User, options : Hash)
end
