{
  lib,
  config,
  ...
}:
let
  name = "harper_ls";
  cfg = config.home.development.neovim.lsp.${name};
in
{
  options.home.development.neovim.lsp.${name} = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable ${name} LSP for neovim";
    };
  };

  config = lib.mkIf cfg.enable {
    # https://writewithharper.com/docs/integrations/neovim
    programs.nixvim.plugins = {
      lsp.servers.harper_ls = {
        enable = true;
        # NOTE: add options as I need
        # supported filetypes
        filetypes = [
          "c"
          "cmake"
          "cpp"
          "csharp"
          "dart"
          "mail"
          "gitcommit"
          "go"
          "html"
          "java"
          "javascript"
          "javascriptreact"
          "lua"
          "markdown"
          "nix"
          "php"
          "plaintext"
          "python"
          "ruby"
          "rust"
          "shellscript"
          "swift"
          "toml"
          "typescript"
          "typescriptreact"
          "typst"
        ];
        # https://writewithharper.com/docs/integrations/language-server#Configuration
        # https://writewithharper.com/docs/rules
        settings = {
          "harper-ls" = {
            userDictPath = "~/.harper";
            fileDictPath = ".harper";
            linters = {
              SpellCheck = true;
              SpelledNumbers = false;
              AnA = true;
              SentenceCapitalization = true;
              UnclosedQuotes = true;
              WrongQuotes = false;
              LongSentences = true;
              RepeatedWords = false; # annoying when true
              Spaces = true;
              Matcher = true;
              CorrectNumberSuffix = true;
            };
            codeActions = {
              ForceStable = false;
            };
            markdown = {
              IgnoreLinkTitle = false;
            };
            diagnosticSeverity = "hint";
            isolateEnglish = false;
            dialect = "American";
          };
        };
      };
    };
  };
}
