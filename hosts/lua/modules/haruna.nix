{
  homeManagerModule = { pkgs, ... }: {
    home.packages = [ pkgs.haruna ];

    xdg.configFile."haruna/custom-commands.conf".text =
      let
        # Plays all audio tracks at the same time when a file has more than one.
        mixAudioTracks = pkgs.writeText "mix-audio-tracks.lua" ''
          mp.add_hook("on_preloaded", 50, function()
              local inputs = {}
              for _, track in ipairs(mp.get_property_native("track-list")) do
                  if track.type == "audio" then
                      inputs[#inputs + 1] = "[aid" .. track.id .. "]"
                  end
              end

              -- With zero or one audio track there is nothing to mix. Clear the filter
              -- so that a value from the previous file does not break this one.
              if #inputs < 2 then
                  mp.set_property("lavfi-complex", "")
                  return
              end

              mp.set_property(
                  "lavfi-complex",
                  string.format("%s amix=inputs=%d:normalize=0 [ao]", table.concat(inputs, " "), #inputs)
              )
          end)
        '';
      in
      # conf
      ''
        Counter=1

        [Command_0]
        Command=load-script ${mixAudioTracks}
        Order=0
        OsdMessage=
        Type=startup
      '';
  };
}
