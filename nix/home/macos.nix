{ lib, dotfilesPath, user, ... }:
{
  home.homeDirectory = "/Users/${user}";

  home.activation.macosSetup = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ -z "''${SKIP_INSTALL:-}" ]; then
      NONINTERACTIVE=1 bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      brew install $(cat "${dotfilesPath}/distros/macos/packages/"*)
    fi
  '';
}
