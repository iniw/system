{
  homeManagerModule =
    { pkgs, inputs, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
      inherit (inputs.self.packages.${system}) linear-cli slackcli;

      context = ./AGENTS.md;
      # Codex skips symlinked SKILL.md files, so keep regular files inside the linked folder.
      skills = pkgs.runCommand "agent-skills" { } ''
        mkdir -p "$out"
        cp -RL ${./skills}/. \
          ${linear-cli}/share/skills/linear-cli/. \
          ${slackcli}/share/skills/slackcli/. \
          "$out"
      '';
    in
    {
      programs = {
        codex = {
          enable = true;

          inherit context skills;
        };

        claude-code = {
          enable = true;

          inherit context skills;

          settings = {
            attribution = {
              commit = "";
              pr = "";
            };

            autoMemoryEnabled = false;
          };

          mutableSettings = true;
        };

        git.ignores = [
          ".agents"
          ".claude"
          ".codex"
        ];
      };

      home = {
        file = {
          ".agents/AGENTS.md".source = context;
          ".agents/skills".source = skills;
        };

        packages =
          let
            inherit (inputs.llm-agents.packages.${system}) claude-desktop;
          in
          [
            claude-desktop
            linear-cli
            slackcli

          ]
          # Programs that AIs use all the time
          ++ (with pkgs; [
            jq
            python3
            file
            binutils
          ]);
      };
    };

  # Claude Desktop runs in a bwrap user namespace that maps only the user's uid, and by default the kernel shows files
  # whose owner isn't mapped, such as root-owned files in /nix/store and /etc, as owned by `nobody`. ssh then rejects
  # `~/.ssh/config` and the `Include` in `/etc/ssh/ssh_config`, because it requires them to be owned by root or the
  # user. Show unmapped owners as the user (uid 1000) instead. bwrap refuses to start if the value is 0, so root
  # isn't an option. This applies to every user namespace, and it only changes the owner that `stat` reports, not who
  # can access the file.
  #
  # See:
  # - https://github.com/nix-community/home-manager/issues/322
  # - https://github.com/numtide/llm-agents.nix/issues/11069
  nixosSystemModule = {
    boot.kernel.sysctl."kernel.overflowuid" = 1000;
  };
}
