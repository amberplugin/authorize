h1 Hello
  = name

p Thank you for registering with us.

p Please click on this link to confirm your email address. 
  == link_to("Confirm your email address", "#{ host }/authorize/confirm/#{ token }")

p Best regards
  br
  = who