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
      # Change according to the driver used: stable, beta
      nvidiaPackage = pkgs.linuxPackages.nvidiaPackages.stable;
    in
    {
      # alejandra is a nix formatter with a beautiful output
      formatter."${system}" = nixpkgs.legacyPackages.${system}.alejandra;
      devShells."${system}".default = (pkgs.buildFHSEnv {
        name = "vllm-dev-shell";
        targetPkgs =
          pkgs:
          (with pkgs; [
            cudaPackages.cuda_cudart
            cudaPackages.nsight_systems
            cudaPackages.nsight_compute
            cudaPackages.cudnn
            llvmPackages_21.clang-tools
            cudatoolkit
            python312
            uv
            cmake
            gcc
	    linuxPackages.nvidia_x11
            libGLU libGL
            xorg.libXi xorg.libXmu freeglut
            xorg.libXext xorg.libX11 xorg.libXv xorg.libXrandr zlib 
            ncurses5 binutils
            ffmpeg
          ]);
	profile = ''
      	  export CUDA_PATH=${pkgs.cudatoolkit}
	  export DISABLE_DIRENV=1
	  export EXTRA_LDFLAGS="-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib"
          export EXTRA_CCFLAGS="-I/usr/include"
	  export LD_LIBRARY_PATH="${pkgs.linuxPackages.nvidia_x11}/lib"
	'';
        runScript = "zsh";
      }).env;
    };
}
