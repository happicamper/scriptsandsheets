# configure postfix for alerts
if [ -f /etc/postfix/sasl_passwd ]; then
echo "It seems that its postfix is already configured"
else
# editing main.cf for mail configuration
read -p 'Email address: ' email
read -sp 'Password: ' epass

sudo bash -c 'echo "smtp.gmail.com:587 '"$email"':'"$epass"'" >> /etc/postfix/sasl_passwd'

sudo bash -c 'cat <<EOF >> /etc/postfix/main.cf
#Gmail SMTP
relayhost=smtp.gmail.com:587
# Enable SASL authentication in the Postfix SMTP client.
smtp_sasl_auth_enable=yes
smtp_sasl_password_maps=hash:/etc/postfix/sasl_passwd
smtp_sasl_security_options=noanonymous
smtp_sasl_mechanism_filter=plain
# Enable Transport Layer Security (TLS), i.e. SSL.
smtp_use_tls=yes
smtp_tls_security_level=encrypt
tls_random_source=dev:/dev/urandom
EOF'

sudo postmap /etc/postfix/sasl_passwd
sudo postfix start
echo "Testing email..."
date | mail -s testing $email
fi
