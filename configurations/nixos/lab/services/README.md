# Services

## Workflow

1. Write a new service module (`.nix` file)
1. Add the file to the `default.nix` import list
1. Add the service name to the DNS rewrites
   - Currently managed on the raspberry pi's AdGuard Home instance
1. Profit!

## Debugging

1. Did you open the correct ports? Check the firewall...
1. Is there an entry in the DNS for the service URL?
1. Did the DNS fully propagatate the ACME challenge?
1. Are you referencing the correct path for `sops`?
