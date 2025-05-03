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

# Switch
[group('dev')]
[macos]
switch:
    nh darwin switch .

[group('dev')]
[linux]
switch:
    nh os switch .

# Boot
[group('dev')]
[macos]
boot:
    nh darwin boot .

[group('dev')]
[linux]
boot:
    nh os boot .

# Difference
[group('dev')]
[macos]
diff:
    nh darwin build .

[group('dev')]
[linux]
diff:
    nh os build .

# Count number of lines of code
[group('dev')]
count:
    tokei .

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
