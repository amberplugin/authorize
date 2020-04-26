# authorize

Amber web framework plugin to provide Devise like features e.g invitable, lockable, trackable, confirmable, password reset etc.

Amber is a web application framework written in Crystal inspired by Kemal, Rails, Phoenix and other popular application frameworks.

The purpose of Amber is not to create yet another framework, but to take advantage of the beautiful Crystal language capabilities and provide engineers and the Crystal community with an efficient, cohesive, well maintained web framework that embraces the language philosophies, conventions, and guidelines.

Amber web framework includes code generation tools to create standard CRUD web application scaffolding.  Recipes provide a powerful mechanism to generate Amber applications that go beyond the standard CRUD application such as generating SPA web applications.

Plugins are intended to extend the capabilities of Amber and make it easy for developers to create powerful feature rich Amber applications by adding in plugin features.

Authorize is a plugin to add authorization features like those in Devise Ruby gem.

## Requirements

Add this to the dependencies section of your applications's shard.yml
```
  amber_render_module:
    github: damianham/amber_render_module
    version: ~> 0.1.3
```
**IMPORTANT!!** The authorize plugin assumes that the user record that stores application user identities in the **User** class.  In the extremly rare event that this is not the case you will have to replace all instances of __User__ in the plugin with the class name you use to store user identities and change the name of the user identity table in the database migration.

## Installation
```
$ amber plugin add authorize
```

## Setup

### Configuration
Configure authorize plugin in **src/plugins/initializers/authorize.cr**, in particular set the following values

- link_host - the URL of the host for links in emails for things like invitations, resets etc.
- from -  the email address for the sender of emails, e.g.  "no_reply@exampledomain.com"
- who - the name for the sender of emails

### Hooks

Authorize plugin provides a number of hooks that perform before and after event processing.  Each authorize plugin feature provides a different set of hooks.

Override Invitable hooks in **src/plugins/hooks/invitable_hooks.cr** (optional).  See __plugins/authorize/invitable/_hooks.cr__ to see what hook overrides are available.

- Override Lockable hooks in **src/plugins/hooks/lockable_hooks.cr** (optional).  See __plugins/authorize/lockable/_hooks.cr__ to see what hook overrides are available.

### Migration
This plugin includes a migration to add columns to the User table.
```
$ amber db migrate
```

### Modify User class
The User class should ideally have a __#name__ method that returns the user's name so in emails the person can be addressed by name rather than "Friend".

#### Include plugin macros

Change the User class __src/models/user.cr__ and add
```
  include Authorize::Models::Invitable
  include Authorize::Models::Lockable
  include Authorize::Models::Confirmable
  include Authorize::Models::Trackable

  with_authorize_invitable
  with_authorize_lockable
  with_authorize_confirmable
  with_authorize_trackable

```

### Trackable

For the Trackable feature change the create method  in __src/controllers/session_controller.cr__ 
```
  def create
    user = User.find_by(email: params["email"].to_s)
    if user && user.authenticate(params["password"].to_s)
      user.track_signin(client_ip ? client_ip.to_s : request.remote_address ) # <--- add this line here
      session[:user_id] = user.id
      flash[:info] = "Successfully logged in"
      redirect_to "/"
    else
      flash[:danger] = "Invalid email or password"
      user = User.new
      render("new.slang")
    end
  end

```

### Lockable

For the Lockable feature change the create method  in __src/controllers/session_controller.cr__ 
```
  def create
    user = User.find_by(email: params["email"].to_s)
    if user && user.authenticate(params["password"].to_s) && !user.is_locked? # <-- add this test
      session[:user_id] = user.id
      flash[:info] = "Successfully logged in"
      redirect_to "/"
    else
      # Change the flash error message accordingly
      flash[:danger] = (user && user.is_locked?) ? "Account is locked" : "Invalid email or password"
      user = User.new
      render("new.slang")
    end
  end

```

### Email templates

Some authorize features have mailer email templates that are sent to users.  Edit the templates in __plugins/authorize/mailers__ to suit your web application.


## Using authorize plugin

The authorize plugin provides a number of routes in 3 pipelines that are namespaced with **"/authorize"**
- :authorize - intended to be restricted to logged in users
- :authorize_public - intended to be publicly accessible
- :authorize_admin - intended to be restricted to system administrators

See __plugins/authorize/routes.cr__ for details of what routes are available.  The **:authorize** pipeline includes the __Authenticate__ plug which is added with
```
$ amber g auth User
```

The **:authorize_admin** pipeline should have a plug added to the pipeline that restricts the pipeline to system administrators.  For example
```
# src/pipes/authenticate_admin.cr

class AuthenticateAdmin < Amber::Pipe::Base
 
  def call(context)
    # with JWT support
    token = context.params["token"]? || context.request.headers["x-jwt-token"]?
    if token 
      payload, header = JWT.decode(token, Amber.settings.secret_key_base, JWT::Algorithm::HS256)
      user = User.find_by(email: payload["email"].to_s) unless payload["email"]?.nil?
    elsif user_id = context.session["user_id"]?
      user = User.find user_id
    end

    if user
      context.current_user = user

      # requires an is_admin? method on User to determine if the user is an admin
      if ! user.is_admin?  
        context.flash[:warning] = "Access forbidden"
        context.response.headers.add "Location", "/"
        context.response.status_code = 302
      else
          call_next(context)
      end
      
    else
      context.flash[:warning] = "Please Sign In"
      context.response.headers.add "Location", "/signin"
      context.response.status_code = 302
    end
  end
end

```

As a signed in user

- Visit "/authorize/invite" to invite a new user
- Visit "/authorize/invitations" to view a list of invitations you have sent with options to resend and delete invitations.

As a signed in system administrator

- Visit "/authorize/lock/:user_id" - to lock a user account
- Visit "/authorize/unlock/:user_id" - to unlock a user account

## Contributing

Contributing to Amber can be a rewarding way to learn, teach, and build experience in just about any skill you can imagine. You don’t have to become a lifelong contributor to enjoy participating in Amber or Amber plugins.  Contribute to the Amber eco-system to make it the best web application
framework on the planet.  Help us extend this plugin to cover more authorization features, or create your own plugin.  See the Amber framework [plugin](https://docs.amberframework.org/amber/cli/recipes) documentation for information about creating and using plugins.

Code Triage? Join us on [codetriage](https://www.codetriage.com/amberplugin/authorize).

[![Open Source Contributors](https://www.codetriage.com/amberplugin/authorize/badges/users.svg)](https://www.codetriage.com/amberplugin/authorize)

Amber is a community effort and we want You to be part of it. [Join Amber Community!](https://github.com/amberframework/amber/blob/master/.github/CONTRIBUTING.md)

1. Fork it https://github.com/amberplugin/authorize/fork
2. Create your feature branch `git checkout -b my-new-feature`
3. Write and execute specs and formatting checks `crystal spec`
4. Commit your changes `git commit -am 'Add some feature'`
5. Push to the branch `git push origin my-new-feature`
6. Create a new Pull Request

## Contributors

- [Damian Hamill](https://github.com/damianham "damianham")

## Todo

- Omniauthable, e.g. Oauth via google, facebook, github, twitter etc.
- Recoverable
- tests

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

* Inspired by [Mochi](https://github.com/gitlato/mochi), [Devise](https://github.com/heartcombo/devise)