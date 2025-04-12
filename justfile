# Like GNU `make`, but `just` rustier.
# https://just.systems/
# run `just` from this directory to see available commands

# Default command when 'just' is run without arguments
default:
    @just --list

# Update nix flake
[group('Main')]
update:
    nix flake update

# Lint nix files
[group('dev')]
lint:
    nix fmt

# switch the build
[group('dev')]
[macos]
switch:
    darwin-rebuild switch --flake .

# switch the build
[group('dev')]
[linux]
switch:
    nixos-rebuild switch --flake .

# build and check the diff
[group('dev')]
[macos]
diff:
    darwin-rebuild build --flake . && nvd diff /run/current-system result

# build and check the diff
[group('dev')]
[linux]
diff:
    nixos-rebuild build --flake . && nvd diff /run/current-system result

# Build the raspberry pi image
[group('dev')]
build-pi:
    nix build '.#nixosConfigurations.pi.config.system.build.sdImage'

# Check nix flake
[group('dev')]
check:
    nix flake check

# Manually enter dev shell
[group('dev')]
dev:
    nix develop

# Activate the configuration
[group('Main')]
run:
    nix run
