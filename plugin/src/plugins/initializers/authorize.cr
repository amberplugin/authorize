module Authorize
  # Main configuration class for Authorize
  # Holds all variables for configuration (excluding omniauthable)
  #
  # Usage:
  #
  # ```
  # Authorize.setup do |config|
  #   config.property = X
  # end
  # ```

  @@config : Configuration?

  def self.configuration
    @@config ||= Configuration.new
  end

  def self.configuration(&block)
   yield config
  end

  class Configuration
    # Set the view extension.
    # Useful if you use slang or someother
    # templating engine.
    #
    # Default is `"ecr"`
    property view_language : String = "ecr"

    # Allow/prevent users to reconfirm with the confirmable module
    #
    # Default is `false`
    property reconfirmable : Bool = false

    # Allow account access for X number of days
    # without confirming email
    #
    # `Nil` will give indefinite access
    property allow_unconfirmed_access_for : Nil | Int64

    # How many days a confirmation_token lasts
    # Default is `7`
    property confirm_within : Int64 = 7

    # Do invited users need to confirm their email address
    # should be false as accepting the invite confirms their email implicitely
    property confirm_invited_user : Bool = false

    # delete delined invitations?
    property delete_declined : Bool = true

    # Configure which class recieves the call to all emails.
    #
    # Default is `Authorize::DefaultMailer`
    #
    # Feel free to inherit from `Authorize::Mailer` and implement your own
    property mailer_class : Authorize::Mailer.class = Authorize::DefaultMailer

    # The time period within which the password
    # must be reset or the token expires. Number
    # is measured in days
    property reset_password_within : Int64 = 7

    # Whether or not to sign in the user
    # automatically after a password reset.
    property sign_in_after_reset_password : Bool = true

    # Number of attempts a user has until their
    # account is locked
    property maximum_attempts : Int32 = 3

    # Number of days until the account is automatically
    # unlocked
    property unlock_in : Int32 = 1

    # The message users recieve when they are on their final login attempt
    property last_attempt_warning : String = "This is your final attempt"

    # Whether or not to sign in the user
    # automatically after unlocking an account.
    # this could also be achieved in the after_unlock_hook
    property sign_in_after_unlocking : Bool = true

    property paranoid : Bool = false

    property accept_invitation_within : Int32 = 7

    # Configure the FQDN of the host for embedded links
    property link_host : String = (Amber.env == "production" ? "https://www.exampledomain.com/" : "http://localhost:3000" )

    # Configure the sender email address for replies
    property from : String = "no_reply@exampledomain.com"

    # Configure the name of the sender
    property who : String = "The Example Team"

  end
end

