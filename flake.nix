{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        spdlog-git = pkgs.stdenv.mkDerivation {
          pname = "spdlog";
          version = "v1.13.0";

          src = pkgs.fetchFromGitHub {
            owner = "gabime";
            repo = "spdlog";
            rev = "v1.13.0";
            hash = "sha256-3n8BnjZ7uMH8quoiT60yTU7poyOtoEmzNMOLa1+r7X0=";
          };

          cmakeFlags = [
            # "-DFETCHCONTENT_SOURCE_DIR_SPDLOG=${pkgs.spdlog}"
          ];

          buildPhase = ''
            # # NIX_CFLAGS_COMPILE="-I$out/include/dynamixel-sdk $NIX_CFLAGS_COMPILE"
            # mkdir -p build
            # echo "${pkgs.spdlog}"
            # cmake  -DCMAKE_BBUILD_TYPE=Release -S . -B build
            # cmake --build build

          '';

          installPhase = ''
            mkdir -p $out
            cp -r ./* $out/
          '';
        };

        # canup = pkgs.writeShellScript
      in
      with builtins;
      rec {

        packages.default = pkgs.stdenv.mkDerivation {
          pname = "mcuviewer";
          version = "v1.2.4";
          
          # src = pkgs.fetchgit {
          #   url = "https://github.com/klonyyy/MCUViewer.git";
          #   hash = "sha256-x53p+R7sEVnRIRm0QikfqiZrR+SGzGS7WeMs+shV7W8=";
          # };
          # src = pkgs.fetchFromGitHub {
          #   owner = "klonyyy";
          #   repo = "MCUViewer";
          #   rev = "v1.2.3";
          #   sha256 = "0vzdap4glb73b6xn9k46wi3nn9ma3wll5d0r478mj4gc3vwyk7f7";
          # };
          src = ./.;

          buildInputs = with pkgs; [
            cmake
            libusb1
            glfw
            gtk3
            gtkmm3
            pkg-config

            pcre-cpp
            libxdmcp
            mount
            util-linux
            lerc
            libselinux
            libsepol
            libthai
            libdeflate
            xz
            libwebp
            zstd
            libdatrie
            pcre2
            libsysprof-capture
            libxkbcommon
            libepoxy
            xorg.libXtst
            spdlog-git
            tree
            ninja
          ];

          cmakeFlags = [
            "-DFETCHCONTENT_SOURCE_DIR_SPDLOG=${spdlog-git}"
            "-DCMAKE_BUILD_TYPE=Release"
            "-DCMAKE_PREFIX_PATH=./"
            "-DCMAKE_INSTALL_RPATH=lib/"
            # "-DCMAKE_"
            # "-GNinja"

          ];
          # env = {
          #   CXXFLAGS = "-Wno-error";
          # };

          # CXXF

          buildPhase = ''
            # NIX_CFLAGS_COMPILE="-I$out/include/dynamixel-sdk $NIX_CFLAGS_COMPILE"
            # export CXXFLAGS:="-Wno-error"
            # cmake -S .. -B $out/build -DFETCHCONTENT_SOURCE_DIR_SPDLOG=${spdlog-git}
            cmake ..

            # ls src
            # nnn
            cd ..
            mkdir -p .git/refs/heads
            echo "ref: refs/heads/main" > .git/HEAD
            echo "4be6621edff44fdb1fcc1e2333eb7d3253a18b05" > .git/refs/heads/main
            printf "#define GIT_INFO_PRESENT \n \
                  static constexpr const char* GIT_HASH = \"4be6621edff44fdb1fcc1e2333eb7d3253a18b05\";" > src/gitversion.hpp
            cat src/gitversion.hpp
            cd build


              
            # cat src/gitversion.hpp
            #
            # echo "${spdlog-git}"
            echo $CXXCFLAGS

            cmake --build . -- --ignore-errors || true
                       # cat toairenstoairesn 
            # make -d
            # ninja -C build

          '';

          installPhase = ''

            mkdir -p $out/bin
            # pwd
            # ls
            # make


            ls -R
            tree -L 3
            cmake --install . 
            mv $out/bin/MCUViewer $out/bin/mcuviewer
            cp -r ../third_party/stlink/chips $out/bin/chips
          '';
        };

        devShells.default = pkgs.mkShell {
          name = "mcuviewer";
          packages = with pkgs; [
            cmake
            clang
            libusb1
            glfw
            gtk3
            gtkmm3
            pkg-config

            pcre-cpp
            libxdmcp
            mount
            util-linux
            lerc
            libselinux
            libsepol
            libthai
            libdeflate
            xz
            libwebp
            zstd
            libdatrie
            pcre2
            libsysprof-capture
            libxkbcommon
            libepoxy
            xorg.libXtst
          ];
        };
      }
    );
}
