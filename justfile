# Like GNU `make`, but `just` rustier.
# https://just.systems/
# run `just` from this directory to see available commands

# Add --no-nom flag when running in CI for cleaner logs
ci_flag := if env_var_or_default('CI', '') != '' { '--no-nom' } else { '' }

# Default command when 'just' is run without arguments
default:
    @just --list

# Update flake.nix inputs
[group('inputs')]
update +inputs="":
    nix flake update {{ inputs }}

###############################################################################

# Switch nix-darwin configuration
[group('switch')]
[macos]
switch:
    nh darwin switch . -- --accept-flake-config

# Switch NixOS configuration
[group('switch')]
[linux]
switch:
    nh os switch . -- --accept-flake-config

# Switch home-manager configuration
[group('switch')]
[linux]
switch-home host:
    nh home switch -c {{ host }} . -b bak

###############################################################################

# Boot nix-darwin configuration
[group('boot')]
[macos]
boot:
    nh darwin boot .

# Boot NixOS configuration
[group('boot')]
[linux]
boot:
    nh os boot .

###############################################################################

# Build nix-darwin configuration
[group('build')]
[macos]
build host:
    nh darwin build . -H {{ host }} {{ ci_flag }}

# Build NixOS configuration
[group('build')]
[linux]
build host:
    nh os build . -H {{ host }} {{ ci_flag }}

# Build a home manager configuration
[group('build')]
build-home host:
    nh home build . -c {{ host }} {{ ci_flag }}

# Build an SD card image for a configuration
[group('build')]
build-sd host:
    nom build .#nixosConfigurations.{{ host }}.config.formats.sd-aarch64

###############################################################################

# Deploy a configuration to a specific host
[group('deploy')]
deploy host target-host:
    nh os switch --target-host {{ target-host }} -H {{ host }} .

###############################################################################

# Check nix flake
[group('dev')]
check:
    nix flake check

# Lint nix files
[group('dev')]
lint:
    nix fmt

# Count number of lines of code
[group('dev')]
count:
    tokei .

# Manually enter dev shell
[group('dev')]
dev:
    nom develop

# Profile neovim
[group('dev')]
profile-nvim:
    vim-startuptime -vimpath nvim -count 100 | bat
