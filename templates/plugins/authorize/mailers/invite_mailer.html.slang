h1 Hello
  = name

p You have been invited to join our wonderful website by 
  = inviter.name

p Click on this link to 
  == link_to("accept this invitation", "#{ host }/authorize/invite/accept/#{ token }")
  | and get started.

p Best regards
  br
  = who