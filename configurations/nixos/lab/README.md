# Lab (custom home-server and NAS)

- Main server for services
  - Actual Budget
  - Mealie
  - Open WebUI
- Running `zfs` on root partitioning scheme (see ./disko.nix for more details)
  - RAID-Z1 scheme for 3x4TB HDDs

## Data

See the following noteworthy data

- `/srv/minecraft/` for minecraft data
  - should be changed to `/var/lib/minecraft/` later, though this conflicts with
    the native minecraft-server option
- `/home/` for user home data
- `/var/lib/` for services data
- `/zshare/` for zfs pool data

## Quirks

- Need to export `zshare` pool after installing

```text
$ fastfetch
          ▗▄▄▄       ▗▄▄▄▄    ▄▄▄▖             justinhoang@lab
          ▜███▙       ▜███▙  ▟███▛             ---------------
           ▜███▙       ▜███▙▟███▛              OS: NixOS 25.11 (Xantusia) x86_64
            ▜███▙       ▜██████▛               Kernel: Linux 6.12.59
     ▟█████████████████▙ ▜████▛     ▟▙         Uptime: 10 days, 2 hours, 40 mins
    ▟███████████████████▙ ▜███▙    ▟██▙        Packages: 2290 (nix-system), 520 (nix-user)
           ▄▄▄▄▖           ▜███▙  ▟███▛        Shell: zsh 5.9
          ▟███▛             ▜██▛ ▟███▛         Terminal: /dev/pts/0
         ▟███▛               ▜▛ ▟███▛          CPU: Intel(R) Core(TM) i3-14100 (8) @ 4.70 GHz
▟███████████▛                  ▟██████████▙    GPU: Intel UHD Graphics 730 @ 1.50 GHz [Integrated]
▜██████████▛                  ▟███████████▛    Memory: 22.41 GiB / 31.10 GiB (72%)
      ▟███▛ ▟▙               ▟███▛             Swap: Disabled
     ▟███▛ ▟██▙             ▟███▛              Disk (/): 271.38 MiB / 1.58 TiB (0%) - zfs
    ▟███▛  ▜███▙           ▝▀▀▀▀               Disk (/zshare/app): 128.00 KiB / 500.00 GiB (0%) - zfs
    ▜██▛    ▜███▙ ▜██████████████████▛         Disk (/ztmp/tmp): 29.95 GiB / 449.62 GiB (7%) - zfs
     ▜▛     ▟████▙ ▜████████████████▛          Local IP (enp4s0): 192.168.0.240/24
           ▟██████▙       ▜███▙                Locale: en_US.UTF-8
          ▟███▛▜███▙       ▜███▙
         ▟███▛  ▜███▙       ▜███▙
         ▝▀▀▀    ▀▀▀▀▘       ▀▀▀▘
```
