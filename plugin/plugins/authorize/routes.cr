Amber::Server.configure do |app|
  pipeline :authorize do
    # Plug is the method to use connect a pipe (middleware)
    # A plug accepts an instance of HTTP::Handler
    # plug Amber::Pipe::PoweredByAmber.new
    # plug Amber::Pipe::ClientIp.new(["X-Forwarded-For"])
    plug Citrine::I18n::Handler.new
    plug Amber::Pipe::Error.new
    plug Amber::Pipe::Logger.new
    plug Amber::Pipe::Session.new
    plug Amber::Pipe::Flash.new
    plug Amber::Pipe::CSRF.new
    
    # 'amber g auth User' will create a User model and signin/signup routes
    # it will also add Authenticate pipe in src/pipes/authenticate.cr
    plug Authenticate.new
  end

  routes :authorize, "/authorize" do
    # invitable module
    get "/invite", Authorize::InvitableController, :new
    get "/invitations", Authorize::InvitableController, :invitations
    post "/invite", Authorize::InvitableController, :create
    get "/invite/resend/:invitation_token", Authorize::InvitableController, :resend
    delete "/invite/delete/:invitation_token", Authorize::InvitableController, :delete

    # confirmable module
    get "/confirm/:confirmation_token", Authorize::ConfirmableController, :confirm
  end

  pipeline :authorize_admin do
    # Plug is the method to use connect a pipe (middleware)
    # A plug accepts an instance of HTTP::Handler
    # plug Amber::Pipe::PoweredByAmber.new
    # plug Amber::Pipe::ClientIp.new(["X-Forwarded-For"])
    plug Citrine::I18n::Handler.new
    plug Amber::Pipe::Error.new
    plug Amber::Pipe::Logger.new
    plug Amber::Pipe::Session.new
    plug Amber::Pipe::Flash.new
    plug Amber::Pipe::CSRF.new
    
    # add a pipe that restricts these routes to admin users
    # e.g. plug AuthenticateAdmin.new
  end

  routes :authorize_admin, "/authorize" do

    # lockable module - should be restricted to admin users
    get "/lock/:user_id", Authorize::LockableController, :lock_user
    get "/unlock/:user_id", Authorize::LockableController, :unlock_user

  end

  pipeline :authorize_public do
    # Plug is the method to use connect a pipe (middleware)
    # A plug accepts an instance of HTTP::Handler
    # plug Amber::Pipe::PoweredByAmber.new
    # plug Amber::Pipe::ClientIp.new(["X-Forwarded-For"])
    plug Citrine::I18n::Handler.new
    plug Amber::Pipe::Error.new
    plug Amber::Pipe::Logger.new
    plug Amber::Pipe::Session.new
    plug Amber::Pipe::Flash.new
    plug Amber::Pipe::CSRF.new
    
  end

  routes :authorize_public, "/authorize" do
    get "/invite/accept/:invitation_token", Authorize::InvitableController, :accept
    get "/invite/decline/:invitation_token", Authorize::InvitableController, :decline
    post "/invite/update/:invitation_token", Authorize::InvitableController, :update
    get "/unlocktoken/:unlock_token", Authorize::LockableController, :unlock_token
  end
  
end