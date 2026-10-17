{
  homeManagerModule =
    { pkgs, inputs, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
      inherit (inputs.self.packages.${system}) linear-cli slackcli;
      llm-agents = inputs.llm-agents.packages.${system};

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

          inherit context;
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
        file.".agents/skills".source = skills;

        packages =
          let
            inherit (llm-agents) claude-desktop;
          in
          [
            claude-desktop
            linear-cli
            slackcli
          ];
      };
    };
}
