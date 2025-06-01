{ lib, pkgs, ... }:
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
            "code"
            "discord"
            "obsidian"
            "spotify"
            "steam"
            "steam-unwrapped"
            "vscode"
            "vscode-extension-github-codespaces"
            "vscode-extension-ms-dotnettools-csharp"
            "vscode-extension-ms-vscode-cpptools"
            "vscode-extension-ms-vscode-remote-remote-containers"
            "vscode-extension-ms-vscode-remote-remote-ssh"
            "vscode-extension-ms-vscode-remote-remote-ssh-edit"
          ]
          # nvidia
          ++ [
            "cuda_cccl"
            "cuda_cudart"
            "cuda_cuobjdump"
            "cuda_cupti"
            "cuda_cuxxfilt"
            "cuda_gdb"
            "cuda-merged"
            "cuda_nvcc"
            "cuda_nvdisasm"
            "cuda_nvml_dev"
            "cuda_nvprune"
            "cuda_nvrtc"
            "cuda_nvtx"
            "cuda_profiler_api"
            "cuda_sanitizer_api"
            "cudnn"
            "libcublas"
            "libcufft"
            "libcurand"
            "libcusolver"
            "libcusparse"
            "libcusparse_lt"
            "libnpp"
            "libnvjitlink"
            "nvidia-x11"
            "nvidia-settings"
          ]
        );
    };

    overlays = [
      # https://github.com/NixOS/nixpkgs/issues/388681
      # TODO:remove when fixed for legion build (open-webui is broken i think)
      (_: prev: {
        pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
          (_: python-prev: {
            onnxruntime = python-prev.onnxruntime.overridePythonAttrs (oldAttrs: {
              buildInputs = lib.lists.remove pkgs.onnxruntime oldAttrs.buildInputs;
            });
          })
        ];
      })
    ];
  };
}
