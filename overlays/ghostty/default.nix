# FIXME: Remove once https://github.com/NixOS/nixpkgs/pull/455047 is merged
final: prev: {
  ghostty = prev.ghostty.overrideAttrs (
    finalAttrs: previousAttrs: {
      version = "1.2.3";
      src = final.fetchFromGitHub {
        owner = "ghostty-org";
        repo = "ghostty";
        tag = "v${finalAttrs.version}";
        hash = "sha256-0tmLOJCrrEnVc/ZCp/e646DTddXjv249QcSwkaukL30=";
      };
    }
  );

  ghostty-bin = prev.ghostty-bin.overrideAttrs (
    finalAttrs: previousAttrs: {
      version = "1.2.3";
      src = final.fetchurl {
        url = "https://release.files.ghostty.org/${finalAttrs.version}/Ghostty.dmg";
        hash = "sha256-817pHxFuKAJ6ufje9FCYx1dbRLQH/4g6Lc0phcSDIGs=";
      };
    }
  );
}
