let
  inherit (import ./lib.nix) importPinned;

  arm-test = import ./arm-test {};
  x86_64-darwin-arm-test = import ./arm-test { system = "x86_64-darwin"; };
  aarch64-darwin-arm-test = import ./arm-test { system = "aarch64-darwin"; };

  # fetch nixpkgs. tbco hydra doesn't provide <nixpkgs>, so we'll have to use
  # a pinned one.
  pkgs = importPinned "nixpkgs" {};

  # cross system settings
  mingwW64 = pkgs.lib.systems.examples.mingwW64;

  # import tbco-nix with the same pin as the nixpkgs above.
  config = { allowUnfree = false; inHydra = true; allowUnsupportedSystem = true; };

  # linux packages
  x86_64-linux = importPinned "tbco-nix"
    { inherit config; nixpkgsJsonOverride = ./pins/nixpkgs-src.json; system = "x86_64-linux"; };

  # macos packages
  x86_64-macos = importPinned "tbco-nix"
    { inherit config; nixpkgsJsonOverride = ./pins/nixpkgs-src.json; system = "x86_64-darwin"; };

  # windows cross compiled on linux
  x86_64-mingw32 = importPinned "tbco-nix"
    { inherit config; nixpkgsJsonOverride = ./pins/nixpkgs-src.json; system = "x86_64-linux"; crossSystem = mingwW64; };

  # jobs contain a key -> value mapping that tells hydra which
  # derivations to build.  There are some predefined helpers in
  # https://github.com/NixOS/nixpkgs/tree/master/pkgs/build-support/release
  # which can be accessed via `pkgs.releaseTools`.
  #
  # It is however not necessary to use those.
  #
  jobs = rec {
    # a very simple job. All it does is call a shell script that print Hello World.
    # hello-world = import ./jobs/trivial-hello-world { inherit pkgs; };

    # this should give us our patched compiler. (e.g. the one
    # from the pinned nixpkgs set with all the tbco-nix
    # patches applied.

    # linux
    # ghc864.x86_64-linux = x86_64-linux.pkgs.haskell.compiler.ghc864;

    # macOS
    # ghc864.x86_64-macos = x86_64-macos.pkgs.haskell.compiler.ghc864;

    # linux -> win32
    # Note: we want to build the cross-compiler. As such we want something from the buildPackages!
    # "${mingwW64.config}-ghc864".x86_64-linux = x86_64-mingw32.pkgs.buildPackages.haskell.compiler.ghc864;

    bcc-node.x86_64-linux-gnu          = arm-test.native.bcc-node.mainnet.tarball;
    bcc-node.x86_64-apple-darwin       = x86_64-darwin-arm-test.native.bcc-node.mainnet.tarball;
    bcc-node.aarch64-apple-darwin      = aarch64-darwin-arm-test.native.bcc-node.mainnet.tarball;

    bcc-node.x86_64-linux-musl         = arm-test.x86-musl64.bcc-node.mainnet.tarball;
    bcc-node.x86_64-windows            = arm-test.x86-win64.bcc-node.mainnet.tarball;

    bcc-node.aarch64-linux-musl        = arm-test.rpi64-musl.bcc-node.mainnet.tarball;

    bcc-node.js-ghcjs                  = arm-test.ghcjs.bcc-node.mainnet.tarball;
    bcc-node.aarch64-android           = arm-test.aarch64-android.bcc-node.mainnet.tarball;
    bcc-node-capi.aarch64-android      = arm-test.aarch64-android.bcc-node.mainnet.bcc-node-capi;

    bcc-wallet-musl.aarch64-linux-musl = arm-test.rpi64-musl.bcc-node.mainnet.bcc-wallet;

    bcc-node-syno-spk.aarch64           = arm-test.rpi64-musl.bcc-node.mainnet.bcc-node-spk;
    bcc-node-syno-spk.x86_64            = arm-test.x86-musl64.bcc-node.mainnet.bcc-node-spk;
    bcc-submit-api-syno-spk.aarch64     = arm-test.rpi64-musl.bcc-node.mainnet.bcc-submit-api-spk;
    bcc-submit-api-syno-spk.x86_64      = arm-test.x86-musl64.bcc-node.mainnet.bcc-submit-api-spk;

    bcc-node-vasil.x86_64-linux-gnu          = arm-test.native.bcc-node.vasil.tarball;
    bcc-node-vasil.x86_64-apple-darwin       = x86_64-darwin-arm-test.native.bcc-node.vasil.tarball;
    bcc-node-vasil.aarch64-apple-darwin      = aarch64-darwin-arm-test.native.bcc-node.vasil.tarball;

    bcc-node-vasil.x86_64-linux-musl         = arm-test.x86-musl64.bcc-node.vasil.tarball;
    bcc-node-vasil.x86_64-windows            = arm-test.x86-win64.bcc-node.vasil.tarball;

    bcc-node-vasil.aarch64-linux-musl        = arm-test.rpi64-musl.bcc-node.vasil.tarball;

    bcc-node-vasil.js-ghcjs                  = arm-test.ghcjs.bcc-node.vasil.tarball;
    bcc-node-vasil.aarch64-android           = arm-test.aarch64-android.bcc-node.vasil.tarball;
    bcc-node-vasil-capi.aarch64-android      = arm-test.aarch64-android.bcc-node.vasil.bcc-node-capi;

    bcc-wallet-vasil-musl.aarch64-linux-musl = arm-test.rpi64-musl.bcc-node.vasil.bcc-wallet;

    bcc-node-vasil-syno-spk.aarch64           = arm-test.rpi64-musl.bcc-node.vasil.bcc-node-spk;
    bcc-node-vasil-syno-spk.x86_64            = arm-test.x86-musl64.bcc-node.vasil.bcc-node-spk;
    bcc-submit-api-vasil-syno-spk.aarch64     = arm-test.rpi64-musl.bcc-node.vasil.bcc-submit-api-spk;
    bcc-submit-api-vasil-syno-spk.x86_64      = arm-test.x86-musl64.bcc-node.vasil.bcc-submit-api-spk;


    ogmios.aarch64                          = arm-test.rpi64-musl.ogmios-tarball;
  };
in
  jobs
