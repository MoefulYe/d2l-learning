{
  description = "CUDA development environment";
  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.cudaSupport = true;
        config.cudaVersion = "12";
      };
      python = pkgs.python312;
    in
    {
      # alejandra is a nix formatter with a beautiful output
      formatter."${system}" = nixpkgs.legacyPackages.${system}.alejandra;
      devShells."${system}".default = pkgs.mkShell {
        name = "d2l";
        packages = with pkgs; [
          cudaPackages.cuda_cudart
          cudaPackages.nsight_systems
          cudaPackages.nsight_compute
          cudaPackages.cudnn
          llvmPackages_21.clang-tools
          cudatoolkit
          python
          uv
          cmake
          gcc
          libgcc.lib
          glibc
          linuxPackages.nvidia_x11
          libGLU
          libGL
          xorg.libXi
          xorg.libXmu
          freeglut
          xorg.libXext
          xorg.libX11
          xorg.libXv
          xorg.libXrandr
          zlib
          ncurses5
          binutils
          ffmpeg
        ];
        shellHook = ''
          export CUDA_PATH=${pkgs.cudatoolkit}
          export DISABLE_DIRENV=1
          export EXTRA_LDFLAGS="-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib"
          export EXTRA_CCFLAGS="-I/usr/include"
          export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${pkgs.linuxPackages.nvidia_x11}/lib:$(echo "$NIX_LDFLAGS" | grep -o -- '-L[^ ]*' | sed 's/^-L//' | paste -sd:)
          # 检查是否存在.venv目录, 若不存在则创建一个新的虚拟环境
          if [ ! -d ".venv" ]; then
            uv venv
          fi
          source .venv/bin/activate
        '';
      };
    };
}
