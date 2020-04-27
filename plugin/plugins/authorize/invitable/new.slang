h1 New Invitation

== form( action: "/authorize/invite", method: :post) do
  == csrf_tag
  .form-group
    == label :Name
    == text_field(name: :name, type: :text, placeholder: "Your Friend's Name", class: "form-control")

  .form-group
    == label :email
    == text_field(name: :email, type: :email, placeholder: "Your Friend's Email", class: "form-control")

  == submit("Invite", class: "btn btn-primary btn-sm")
