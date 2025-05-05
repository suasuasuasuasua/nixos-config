{
  hardware.raspberry-pi."4" = {
    # disable audio
    audio.enable = false;
    # disable backlight
    backlight.enable = false;
    # disable bluetooth
    bluetooth.enable = false;
    # disable UDB controller
    dwc2.enable = false;
    # disable i2c
    i2c0.enable = false;
    i2c1.enable = false;
    # disable fkms-3b
    fkms-3d.enable = false;
    # enable pkgs overlay
    apply-overlays-dtmerge.enable = true;
    # disable poe hat
    poe-hat.enable = false;
    poe-plus-hat.enable = false;
    # disable hardware pwm0 channel on gpio_18
    pwm0.enable = false;
    # disable support for toshiba tc358743 hdmi-to-csi-2 converter
    tc358743.enable = false;
    # disable support for official raspberry pi touch display
    touch-ft5406.enable = false;
    # disable support for raspberry pi tv hat
    tv-hat.enable = false;
    # disable xhci controller for usb
    xhci.enable = false;
  };
}
