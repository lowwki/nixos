{
  inputs,
  lib,
  ...
}: {
  perSystem = {
    pkgs,
    ...
  }: let
#    lf = self'.packages.lf;
    fishConf =
      pkgs.writeText "fishy-fishy"
      # fish
      ''
        function fish_prompt
          set -l last_status $status

          echo                      # blank line between prompts

          set_color 244c58
          echo (prompt_pwd)

          if test $last_status -eq 0
            set_color 244b24
          else
            set_color f38ba8      # red-pink if the last command failed
          end
          echo -n "❯ "
            set_color normal
        end
	function fish_mode_prompt
	end

        set fish_greeting
        fish_vi_key_bindings

        ${lib.getExe pkgs.zoxide} init fish | source

        function lf --wraps="lf" --description="lf - Terminal file manager (changing directory on exit)"
            cd "$(command lf -print-last-dir $argv)"
        end

        if type -q direnv
            direnv hook fish | source
        end
      '';
  in {
    packages.fish = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.fish;
      runtimeInputs = [
  #      pkgs.zoxide
      ];
      flags = {
        "-C" = "source ${fishConf}";
      };
    };
  };
}
