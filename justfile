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
    # NOTE: https://github.com/nix-community/nh/issues/149
    # wait until version 4.0.0
    darwin-rebuild switch --flake .

# switch the build
[group('dev')]
[linux]
switch:
    nh os switch .

# build and check the diff
[group('dev')]
[macos]
diff:
    # NOTE: https://github.com/nix-community/nh/issues/149
    # wait until version 4.0.0
    darwin-rebuild build --flake . && nvd diff /run/current-system result

# build and check the diff
[group('dev')]
[linux]
diff:
    nh os build .

# Build the raspberry pi image
[group('dev')]
build-pi:
    nom build '.#nixosConfigurations.pi.config.system.build.sdImage'

# Check nix flake
[group('dev')]
check:
    nix flake check

# Manually enter dev shell
[group('dev')]
dev:
    nom develop
