{ lib, ... }:
{
  nixpkgs = {
    config = {
      # enable builds with cuda support!
      cudaSupport = true;
      allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) (
          # apps
          [
            "betterttv"
            "discord"
            "obsidian"
            "spotify"
            "steam"
            "steam-unwrapped"
          ]
          # nvidia
          ++ [
            "cuda_cudart"
            "cuda_cccl"
            "cuda_nvcc"
            "cuda_nvrtcl
            "cudnn"
            "libcublas"
            "libcufft"
            "libcurand"
            "libcusparse"
            "libnvjitlink"
            "libnpp"
            "nvidia-settings"
            "nvidia-x11"
          ]
          # vscode
          ++ [
            "code"
            "vscode"
            "vscode-extension-github-codespaces"
            "vscode-extension-ms-dotnettools-csharp"
            "vscode-extension-ms-vscode-cpptools"
            "vscode-extension-ms-vscode-remote-remote-containers"
            "vscode-extension-ms-vscode-remote-remote-ssh"
            "vscode-extension-ms-vscode-remote-remote-ssh-edit"
          ]
        );
    };

    overlays = [ ];
  };
}
