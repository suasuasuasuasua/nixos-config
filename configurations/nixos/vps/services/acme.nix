# ACME/Let's Encrypt setup on VPS
# Note: Lab server manages the actual gitea cert renewal,
# but VPS nginx needs the cert too for SSL termination
{
  security.acme = {
    acceptTerms = true;
    defaults.email = "admin@sua.dev"; # Change to your email
  };
}
