h1 Accept Invitation

== form( action: "/authorize/invite/update/#{token}", method: :post) do
  == csrf_tag
  .form-group
    == label :Name
    == text_field(name: :name, type: :text, value: (user.responds_to?(:name) ? user.name : ""),  placeholder: "Your Name", class: "form-control")

  .form-group
    == label :email
    == text_field(name: :email, type: :email, value: user.original_email,  placeholder: "Email", class: "form-control")

  .form-group
    == label :password
    == text_field(name: :password, type: :password,  placeholder: "Password", class: "form-control")

  .form-group
    == label :confirm_password
    == text_field(name: :confirm_password, type: :password,  placeholder: "Confirm Password", class: "form-control")


  == submit("Continue", class: "btn btn-primary btn-sm")

hr