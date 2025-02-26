{config, pkgs,lib, inputs, ...}:

let 
  nu-grammar = pkgs.tree-sitter.buildGrammar {
    language = "nu";
    version = "0.0.0+rev=082a7c7";
    src = pkgs.fetchFromGitHub {
      owner = "nushell";
      repo = "tree-sitter-nu";
      rev = "main";
      hash = "sha256-BUOadkcQAXqMI8qpDcPN8NwNI+LScPKl/GsGvhfUmhw=";
    };
  };

in
  {

    imports = [
  inputs.nixvim.homeManagerModules.nixvim 

  ];

  options.host.applications.nvim.enable = lib.mkEnableOption "neovim";

  config = lib.mkIf config.host.applications.nvim.enable {

    programs.nixvim = {


      enable = true;


    extraConfigVim = ''
      set noshelltemp
    '';


      globals = {
        mapleader = " ";
      };
       colorschemes = {
/*

          catppuccin = {
          enable = true;
          settings.flavour = "mocha";
          };
*/

        base16 = {
          #   enable = true;
         /* colorscheme = {
        base00 = "#${config.colorScheme.palette.base00}";
        base01 = "#${config.colorScheme.palette.base01}";
        base02 = "#${config.colorScheme.palette.base02}";
        base03 = "#${config.colorScheme.palette.base03}";
        base04 = "#${config.colorScheme.palette.base04}";
        base05 = "#${config.colorScheme.palette.base05}";
        base06 = "#${config.colorScheme.palette.base06}";
        base07 = "#${config.colorScheme.palette.base07}";
        base08 = "#${config.colorScheme.palette.base08}";
        base09 = "#${config.colorScheme.palette.base09}";
        base0A = "#${config.colorScheme.palette.base0A}";
        base0B = "#${config.colorScheme.palette.base0B}";
        base0C = "#${config.colorScheme.palette.base0C}";
        base0D = "#${config.colorScheme.palette.base0D}";
        base0E = "#${config.colorScheme.palette.base0E}";
        base0F = "#${config.colorScheme.palette.base0F}";
        };
*/
          colorscheme = "catppuccin-mocha";
          settings = {
            telescope_borders = true;
            ts_rainbow = true;
            telescope = true;
            mini_completion = true;
            lsp_semantic = true;
            indentblankline = true;
          };
      };


      };

      plugins = {




      #telekasten = {
      # enable = true;
        #  settings = {
        # home = {
        #   __raw = ''vim.fn.expand("~/zettelkasten")'';
        # };
      # };

      orgmode = {
        enable = true;
        settings = {
          org_agenda_files = "~/org/**/*";
          org_default_notes_file = "~/org/notes.org";
        };
      };

      sniprun = {
        enable = true;
      };



      #  luaConfig.post = ''
      #    vim.keymap.set("n", "<leader>z", "<cmd>Telekasten panel<CR>")
      #    vim.keymap.set("n", "<leader>zf", "<cmd>Telekasten find_notes<CR>")
      #    vim.keymap.set("n", "<leader>zn", "<cmd>Telekasten new_note<CR>")
      #   vim.keymap.set("n", "<leader>zt", "<cmd>Telekasten got_today<CR>")
    #      vim.keymap.set("n", "<leader>zc", "<cmd>Telekasten show_calendar<CR>")
      #        '';
      # };

      colorizer = {
        enable = true;
        lazyLoad.enable = false;
      };


        alpha = {
          enable = true;

          theme = "startify";
        };

        lualine = {
          enable = true;
          settings.options.globalstatus = true;

        };

        web-devicons = {
          enable = true;
        };

        luasnip = {
          enable = true;
          fromLua = [
            { paths = "~/snippets";}
          ];
        };


        project-nvim = {

          enable = true;



          settings = {
            manualMode = false;

            patterns = [ ".git" "compile-commands.json"];
          };

        };



        telescope = {
          enable = true;

          keymaps = {
            "<leader>ff" = {
              action = "find_files";
              options = {
                desc = "Search with root = current dir";

              };
            };
            "<leader>fg" = {
              action = "live_grep";
              options = {
                desc = "live grep";
              };
            };
            "<leader>fm" = {
              action = "marks";
              options = {
                desc = "Find marks";
              };
            };
            "<leader>fb" = {
              action = "buffers";
              options = {
                desc = "Find buffers";
              };
            };
            "<leader>fh" = {
              action = "help_tags";
              options = {
                desc = "Find help tags";
              };
            };
          "<leader>fk" = {
            action = "keymaps";
            options = {
              desc = "Find keymaps";
            };
          };
        };

        };

        treesitter = {
          enable = true;

          nixGrammars = true;

          grammarPackages = pkgs.vimPlugins.nvim-treesitter.passthru.allGrammars ++ [ 
            nu-grammar];


            languageRegister = {

              nu = "nu";
              extraConfigLua =
                ''

                do
                local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
                -- change the following as needed
                parser_config.nu = {
                  install_info = {
                    url = "''${nu-grammar}", -- local path or git repo
                    files = {"src/parser.c"}, -- note that some parsers also require src/scanner.c or src/scanner.cc
                    -- optional entries:
                    --  branch = "main", -- default branch in case of git repo if different from master
                    -- generate_requires_npm = false, -- if stand-alone parser without npm dependencies
                    -- requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
                  },
                  filetype = "nu", -- if filetype does not match the parser name
                }
                end
                '';


              };

              settings = {
                indent = {
                  enable = true;
                };
              };

            };

            treesitter-textobjects = {
              enable = true;

              move = {
                enable = true;
                setJumps = true;

                gotoNextStart = {
                  "]f" = {
                    desc = "Goto next Start";
                    query = "@function.outer";

                  };
                };

                  gotoPreviousStart = {
                  "[f" = {
                    desc = "Goto Previous Start";
                    query = "@function.outer";

                  };

                };
                gotoNext = {
                  "]]" = {
                    desc = "Goto next Start";
                    query = "@function.outer";

                  };
                };

                  gotoPrevious = {
                  "[[" = {
                    desc = "Goto Previous Start";
                    query = "@function.outer";

                  };

                };
              };
            };

            lsp = {

              enable = true;

              onAttach = ''

                vim.keymap.set("n", "gd", function() require('telescope.builtin').lsp_definitions() end, opts)
                --vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
                vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
                vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
                vim.keymap.set("n", "<leader>gn", function() vim.lsp.buf.rename() end, opts)
                vim.keymap.set("n", "<leader>wa", function () vim.lsp.buf.add_workspace_folder() end, opts)
                vim.keymap.set("n", "<leader>wr", function () vim.lsp.buf.remove_workspace_folder() end, opts)
                vim.keymap.set("n", "<leader>==", function () vim.lsp.buf.format() end, opts)
                vim.keymap.set("n", "<leader>Kd", function () vim.diagnostic.open_float(nil, {focusable = true}) end, opts)
                vim.keymap.set("n", "<leader>fd", function () require('telescope.builtin').diagnostics() end, opts)
                vim.lsp.inlay_hint.enable(true, {0})
              '';

              servers = {

                clangd.enable = true;
                clangd.cmd = [ "clangd" "--header-insertion=iwyu" "--background-index" "--function-arg-placeholders=false"];

                bashls.enable = true;

                nixd.enable = true;

                lua_ls.enable = true;

                nushell.enable = true;

                fish_lsp.enable = true;
                texlab.enable = true;

              };
            };

      #rust-tools = {
      #  enable = true;
     # };

     rustaceanvim = {
       enable = true;

       settings  = {

         defaultSettings = {
           standalone = true;
         };
       };
     };

     indent-blankline = {

       enable = true;

       settings = {

         scope = {
           enabled = true;
           show_end = false;
         };
       };
     };


     cmp-nvim-lsp = {
       enable = true;
     };

     cmp-buffer = {
       enable = true;
     };

     cmp-zsh = {
       enable = true;
     };
     cmp-path = {
       enable = true;
     };
     cmp_luasnip = {
       enable = true;

     };
     cmp-nvim-lsp-signature-help = {
       enable = true;
     };
     cmp = {
       enable = true;
       settings = { 
         autoEnableSources = true;

         completion = {
         #   keyword_length = 3;
       };

       sources = [
         { name = "nvim_lsp"; }
         { name = "buffer"; }
         { name = "zsh"; }
         { name = "path";}
         {name = "luasnip";}
         {name = "nvim_lsp_signature_help";}
            {name = "orgmode";}
       ];

       snippet.expand = 
       ''
         function(args)
         require('luasnip').lsp_expand(args.body)
         end
       '';

       mapping =
         { __raw = ''
           cmp.mapping.preset.insert({
            -- ['<C-.>'] = cmp.mapping.select_prev_item(),
         --  ['<C-,>'] = cmp.mapping.select_next_item(),
           ['<Tab>'] = cmp.mapping.confirm({select = true}),
           ['<C-e>'] = cmp.mapping.abort(),
           --['<C-Space>'] = cmp.mapping.complete(),
           })'';
         };

         formatting = {

           format = 
           '' function(entry, vim_item)
           local kind_icons = {
             Text = "",
             Method = "󰆧",
             Function = "󰊕",
             Constructor = "",
             Field = "󰇽",
             Variable = "󰂡",
             Class = "󰠱",
             Interface = "",
             Module = "",
             Property = "󰜢",
             Unit = "",
             Value = "󰎠",
             Enum = "",
             Keyword = "󰌋",
             Snippet = "",
             Color = "󰏘",
             File = "󰈙",
             Reference = "",
             Folder = "󰉋",
             EnumMember = "",
             Constant = "󰏿",
             Struct = "",
             Event = "",
             Operator = "󰆕",
             TypeParameter = "󰅲",
           }
           vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
           -- Source
           vim_item.menu = ({
             buffer = "[Buffer]",
             nvim_lsp = "[LSP]",
             luasnip = "[LuaSnip]",
             nvim_lua = "[Lua]",
             latex_symbols = "[LaTeX]",
           })[entry.source.name]
           return vim_item
           end '';

             };
             };
             };


             markdown-preview = {

               enable = true;
             };






             nvim-autopairs = {

               enable = true;


             };



      #copilot-vim = {
      #        enable = true;
      #      };


             vimtex = {
               enable = true;

        settings = {
          compiler_method = "lualatex";
            view_method = "zathura";
        };
             };


           };
    extraPlugins = with pkgs.vimPlugins; [
      vim-nix
      fugitive
      friendly-snippets
      vim-obsession
      tabular
      vim-visual-multi
      (base16-vim.overrideAttrs ( old:
          let 
            scheme-file = config.scheme {  target = "tinted-vim";
              templateRepo = "${inputs.base16-nvim}";
              check-parsed-config-yaml = false;
            use-ifd = false;};
          in {patchPhase = ''cp ${scheme-file} colors/base16-customscheme.vim'';}))
    ];

           opts = {
             number = true;

             shiftwidth = 4;
        
           };

      # autoCmd = [
      # { event = "FileType";
      #   pattern = [ "*.md" "markdown"];
      #  callback = {
    #__raw = ''
            #    function() 
    #print("Enter markdown")
  #      vim.keymap.set("n", "<leader>cc", "<cmd>Telekasten toggle_todo<CR>", "{ buffer = true}") end
            #    '';
      #  };
      # }
      # ];


      extraConfigLua = ''
            -- tinted-nvim colorscheme
            vim.g.tinted_colorspace = 256
            vim.cmd.colorscheme('base16-customscheme')

             -- Vimtex config

             vim.g.vimtex_view_method = 'zathura'
             vim.g.vimtex_compiler_method = 'lualatex'

             function Make(opts)
             local dir_contents = vim.split(vim.fn.system("ls"), "\n")
             local make_command = "!make"
             if opts.fargs[1] ~= nil then
             make_command = make_command .. " " .. opts.fargs[1]
             end
             for _ ,a in ipairs(dir_contents) do
             if a == "build" then
             vim.cmd("silent! lcd build")
             vim.cmd(make_command)
             vim.cmd("silent! lcd ..")
             return
             end
             end
             vim.cmd(make_command)
             end

             function Termin(opts)
             print("Creating Terminal")

             local buffers = vim.api.nvim_list_bufs()
             local term_active = false

             for _, s in ipairs(buffers) do
             local name = vim.api.nvim_buf_get_name(s)
             if string.find(name, "^term") ~= nil then
             print("Found Terminal, switching")
             term_active = true

             end
             end

             if not term_active then
             vim.cmd("split")
             vim.cmd("wincmd J")
             vim.cmd("resize 10")
             local win = vim.api.nvim_get_current_win()
             vim.cmd("terminal")
             vim.api.nvim_set_current_win(win)
             end



             end

             vim.api.nvim_create_user_command("Make", Make, {nargs = "?"})
             vim.api.nvim_create_user_command("Term", Termin, {nargs = 0})

             function hello() 
             print("Welcome to nvim")
             end



             --vim.g.copilot_no_tab_map = true



             _G.snip_or_tab = function()
             local ls = require("luasnip")
             if ls.expand_or_jumpable() then
             return "<Plug>luasnip-expand-or-jump"
             else 
             return "<Tab>"
             end
             end





           '';

           keymaps = [
             { key ="<M-p>";
             mode = ["i" "n" "t"];
             action = "<cmd>:bp<CR>";
           }
           { key ="<M-n>";
           mode = ["i" "n" "t"];
           action = "<cmd>:bn<CR>";
         }
         { key = "<Esc>";
         mode = ["t"];
         action = "<C-\\><C-n>";
       }

       {key = "<A-h>";
       mode = ["n" "i" "t"];
       action = "<C-w>h";
     }
     {key = "<A-j>";
     mode = ["n" "i" "t"];
     action = "<C-w>j";
   }
   {key = "<A-k>";
   mode = ["n" "i" "t"];
   action = "<C-w>k";
 }
 {key = "<A-l>";
 mode = ["n" "i" "t"];
 action = "<C-w>l";
  }

  {key = "<C-BS>";
  mode = ["i"];
  action = "<C-w>";}

  {key = "<C-,>";
  mode = ["i" "n"];
  action = "<cmd>:set number relativenumber!<CR>";
}
{key = "<C-Space>";
mode = ["i" "n"];
action = "<cmd>:set number hlsearch!<CR>";
 }
 { key = "<Tab>";
 mode = ["i"];
 action = "v:lua.snip_or_tab()";
 options = {expr = true;};
} 
{ key = "<S-Tab>";
mode = ["i"];
action = "<cmd>lua require\"luasnip\".jump(-1)<CR>";
} 
{key = "<C-]>";
mode = ["i"];
action = "<cmd>lua if require\"luasnip\".choice_active() then require\"luasnip\".change_choice() end<CR>";}
      {key = "<M-m>";
        mode = ["i" "n"];
      action = "<plug>(VM-Add-Cursor-At-Pos)";
      }
  ];

};
};
}


