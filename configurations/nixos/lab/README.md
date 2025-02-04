# Laboratory (custom home-server and NAS)

- Running `zfs` on root partitioning scheme (see ./disko.nix for more details)
- Also running `zfs` with RAID-Z1 scheme for 3x4TB HDDs
- Main server running the following services (not exhaustive)
  <!-- TODO: fill in the services once i've built and setup the computer -->
  - ...

## Quirks

- Need to export `zshare` pool after installing

```text
/home/justinhoang/ [justinhoang@lab] [23:04]
> fastfetch
          ▗▄▄▄       ▗▄▄▄▄    ▄▄▄▖             justinhoang@lab
          ▜███▙       ▜███▙  ▟███▛             ---------------
           ▜███▙       ▜███▙▟███▛              OS: NixOS 25.05 (Warbler) x86_64
            ▜███▙       ▜██████▛               Kernel: Linux 6.6.74
     ▟█████████████████▙ ▜████▛     ▟▙         Uptime: 4 hours, 20 mins
    ▟███████████████████▙ ▜███▙    ▟██▙        Packages: 1154 (nix-system)
           ▄▄▄▄▖           ▜███▙  ▟███▛        Shell: zsh 5.9
          ▟███▛             ▜██▛ ▟███▛         Terminal: tmux 3.5a
         ▟███▛               ▜▛ ▟███▛          CPU: Intel(R) Core(TM) i3-14100 (8) @ 4.70 GHz
▟███████████▛                  ▟██████████▙    GPU: Intel UHD Graphics 730 @ 1.50 GHz [Integrated]
▜██████████▛                  ▟███████████▛    Memory: 25.84 GiB / 31.10 GiB (83%)
      ▟███▛ ▟▙               ▟███▛             Swap: Disabled
     ▟███▛ ▟██▙             ▟███▛              Disk (/): 603.50 MiB / 1.74 TiB (0%) - zfs
    ▟███▛  ▜███▙           ▝▀▀▀▀               Disk (/zshare/projects): 15.44 GiB / 6.65 TiB (0%) - zfs
    ▜██▛    ▜███▙ ▜██████████████████▛         Disk (/ztmp/tmp): 2.12 GiB / 449.62 GiB (0%) - zfs
     ▜▛     ▟████▙ ▜████████████████▛          Local IP (enp4s0): 192.168.0.240/24
           ▟██████▙       ▜███▙                Locale: en_US.UTF-8
          ▟███▛▜███▙       ▜███▙
         ▟███▛  ▜███▙       ▜███▙
         ▝▀▀▀    ▀▀▀▀▘       ▀▀▀▘

```
