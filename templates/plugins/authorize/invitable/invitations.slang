div.row
  div.col-sm-11
    h2 Invitations
  div.col-sm-1
    a.btn.btn-success.btn-xs href="/authorize/invite" New
div.table-responsive
  table.table.table-striped
    thead
      tr
        th Name
        th Email

    tbody
      - users.each do |user|
        tr
          td = user.name
          td = user.email
          td
            span
              = link_to("resend", "/authorize/invite/resend/#{token}", class: "btn btn-success btn-xs")
              = link_to("delete", "/authorize/invite/delete/#{token}?_method=delete&_csrf=#{csrf_token}", class: "btn btn-danger btn-xs", onclick: "return confirm('Are you sure?');")

            