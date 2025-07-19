# Like GNU `make`, but `just` rustier.
# https://just.systems/
# run `just` from this directory to see available commands

# Default command when 'just' is run without arguments
default:
    @just --list

# Update all flake inputs
[group('Main')]
update:
    nix flake update

# Update nixvim config input
[group('Main')]
update-nixvim:
    nix flake update nixvim-config

# Lint nix files
[group('dev')]
lint:
    nix fmt

# Switch
[group('dev')]
[macos]
switch:
    nh darwin switch . -- --accept-flake-config

[group('dev')]
[linux]
switch:
    nh os switch . -- --accept-flake-config

# Boot
[group('dev')]
[macos]
boot:
    nh darwin boot .

[group('dev')]
[linux]
boot:
    nh os boot .

# Build
[group('dev')]
[macos]
build:
    nh darwin build .

[group('dev')]
[linux]
build:
    nh os build .

# Count number of lines of code
[group('dev')]
count:
    tokei .

# Profile neovim
[group('dev')]
profile-nvim:
    vim-startuptime -vimpath nvim -count 100 | bat

# Build the raspberry pi image
[group('dev')]
build-pi:
    nom build .#nixosConfigurations.pi.config.formats.sd-aarch64

# Check nix flake
[group('dev')]
check:
    nix flake check

# Manually enter dev shell
[group('dev')]
dev:
    nom develop
