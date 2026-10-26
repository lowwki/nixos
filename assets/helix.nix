{
  self,
  inputs,
  ...
}: {
  flake.wrappersModules.helix = {
    ...
  }: {
    config = {
      settings = {
        theme = "gruvbox-hard";

        editor = {
          true-color = true;
          color-modes = true;
          cursorline = true;
          bufferline = "multiple";
          line-number = "relative";
          indent-guides.render = true;
          cursor-shape = {
            normal = "block";
            insert = "bar";
            select = "underline";
          };
        };
      };

      themes.gruvbox-hard = {
        palette = {
          bg      = self.theme.base00;
          bg1     = self.theme.base01;
          bg2     = self.theme.base02;
          gray    = self.theme.base03;
          fg4     = self.theme.base04;
          fg3     = self.theme.base05;
          fg      = self.theme.base06;
          fg0     = self.theme.base07;
          red     = self.theme.base08;
          orange  = self.theme.base09;
          yellow  = self.theme.base0A;
          green   = self.theme.base0B;
          cyan    = self.theme.base0C;
          blue    = self.theme.base0D;
          magenta = self.theme.base0E;
        };
      
        "comment" = "gray";
      
        "keyword" = "red";                      # Keyword, Statement, Conditional, Repeat
        "keyword.control" = "red";
        "keyword.control.import" = "cyan";      # Include
        "keyword.directive" = "cyan";           # PreProc, Define
        "keyword.storage" = "orange";           # StorageClass
        "keyword.operator" = "red";
        "label" = "red";
      
        "function" = {fg = "green"; modifiers = ["bold" "italic"];};
        "function.builtin" = {fg = "green"; modifiers = ["bold" "italic"];};
        "function.method" = {fg = "green"; modifiers = ["bold" "italic"];};
        "function.macro" = "orange";            # Macro
      
        "type" = {fg = "cyan"; modifiers = ["bold"];};
        "type.builtin" = {fg = "cyan"; modifiers = ["bold"];};
        "type.parameter" = {fg = "cyan"; modifiers = ["bold"];};
        "constructor" = {fg = "cyan"; modifiers = ["bold"];};
        "namespace" = "cyan";                   # Structure
        "attribute" = "orange";
      
        "variable" = "blue";                    # @variable and Identifier
        "variable.builtin" = "blue";
        "variable.parameter" = {fg = "blue"; modifiers = ["bold"];};
        "variable.other.member" = "blue";
      
        "constant" = "magenta";
        "constant.numeric" = "magenta";
        "constant.builtin" = "magenta";
        "constant.builtin.boolean" = "magenta";
        "constant.character" = "magenta";
        "constant.character.escape" = "red";    # SpecialChar
      
        "string" = {fg = "green"; modifiers = ["italic"];};
        "string.regexp" = "orange";
        "string.special" = "orange";
        "string.special.path" = {fg = "orange"; modifiers = ["underlined"];};
        "string.special.url" = {fg = "red"; modifiers = ["underlined"];};   # Underlined
        "string.special.symbol" = "orange";
      
        "operator" = "orange";
        "special" = "orange";
        "tag" = "red";
      
        "punctuation" = "orange";               # @punctuation and Delimiter
        "punctuation.delimiter" = "orange";
        "punctuation.bracket" = "orange";
        "punctuation.special" = "orange";
      
        # ---------- markup ----------
        "markup.heading" = {fg = "blue"; modifiers = ["bold"];};   # Title
        "markup.heading.marker" = "orange";
        "markup.list" = "red";
        "markup.bold" = {modifiers = ["bold"];};
        "markup.italic" = {modifiers = ["italic"];};
        "markup.strikethrough" = {modifiers = ["crossed_out"];};
        "markup.link.url" = {fg = "red"; modifiers = ["underlined"];};
        "markup.link.text" = "blue";
        "markup.link.label" = "blue";
        "markup.quote" = "gray";
        "markup.raw" = "green";
      
        # ---------- diff ----------
        "diff.plus" = "green";
        "diff.minus" = "red";
        "diff.delta" = "blue";
      
        # ---------- diagnostics ----------
        "error" = "red";
        "warning" = "orange";
        "info" = "yellow";
        "hint" = "yellow";
        "diagnostic.error" = {underline = {color = "red"; style = "curl";};};
        "diagnostic.warning" = {underline = {color = "orange"; style = "curl";};};
        "diagnostic.info" = {underline = {color = "yellow"; style = "curl";};};
        "diagnostic.hint" = {underline = {color = "yellow"; style = "curl";};};
        "diagnostic.unnecessary" = {modifiers = ["dim"];};
      
        # ---------- ui ----------
        "ui.background" = {};                   # kitty's background shows through
        "ui.text" = "fg";
        "ui.text.focus" = {bg = "bg2";};
        "ui.text.inactive" = "gray";
        "ui.linenr" = "gray";
        "ui.linenr.selected" = "fg4";           # CursorLineNr
        "ui.cursorline.primary" = {bg = "bg1";};
        "ui.cursor.match" = {bg = "gray";};     # MatchParen
        "ui.selection" = {bg = "bg2";};         # Visual
        "ui.selection.primary" = {bg = "bg2";};
        "ui.highlight" = {bg = "bg2";};
      
        "ui.statusline" = {fg = "fg4"; bg = "bg2";};
        "ui.statusline.inactive" = {fg = "gray"; bg = "bg1";};
        "ui.statusline.normal" = {fg = "bg"; bg = "blue"; modifiers = ["bold"];};
        "ui.statusline.insert" = {fg = "bg"; bg = "green"; modifiers = ["bold"];};
        "ui.statusline.select" = {fg = "bg"; bg = "yellow"; modifiers = ["bold"];};
      
        "ui.bufferline" = {fg = "gray"; bg = "bg1";};
        "ui.bufferline.active" = {fg = "green"; bg = "bg1";};   # TabLineSel
        "ui.bufferline.background" = {bg = "bg1";};
      
        "ui.popup" = {fg = "fg3"; bg = "bg1";};
        "ui.help" = {fg = "fg3"; bg = "bg1";};
        "ui.menu" = {fg = "fg3"; bg = "bg1";};
        "ui.menu.selected" = {bg = "bg2";};
        "ui.window" = "bg2";
      
        "ui.virtual.whitespace" = "gray";
        "ui.virtual.indent-guide" = "bg2";
        "ui.virtual.ruler" = {bg = "bg1";};
        "ui.virtual.inlay-hint" = {fg = "gray"; modifiers = ["italic"];};
        "ui.virtual.jump-label" = {fg = "orange"; modifiers = ["bold"];};
      };

    };
  };

  perSystem = {pkgs, ...}: {
    packages.helix =
    (inputs.wrappers.wrappers.helix.apply {
      inherit pkgs;
      imports = [self.wrappersModules.helix];
    }).wrapper;
  };
}
