{configs, pkgs, ...}:

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

  programs.nixvim = {


    enable = true;


    globals = {
      mapleader = " ";
    };


    colorschemes = {

      catppuccin = {
        enable = true;
        settings.flavour = "mocha";
      };

    };

    plugins = {


      alpha = {
        enable = true;

        theme = "startify";
      };

      lualine = {
        enable = true;
        globalstatus = true;

      };

      luasnip = {
        enable = true;
      };


      project-nvim = {

        enable = true;

        manualMode = false;
        patterns = [ ".git" "compile-commands.json"];

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
        vim.keymap.set("n", "<leader>fd", function () require('telescope.builtins').diagnostics() end, opts)
        '';

        servers = {

          clangd.enable = true;

          bashls.enable = true;

          nixd.enable = true;

          lua-ls.enable = true;

          nushell.enable = true;

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
           ['<C-p>'] = cmp.mapping.select_prev_item(),
           ['<C-n>'] = cmp.mapping.select_next_item(),
           ['<Tab>'] = cmp.mapping.confirm({select = true}),
           ['<C-Space>'] = cmp.mapping.complete(),
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



  jupytext = {
    enable = true;
  };




   nvim-autopairs = {

     enable = true;
   };



   copilot-vim = {
     enable = true;
   };


   vimtex = {
     enable = true;
   };


 };
 extraPlugins = with pkgs.vimPlugins; [
   vim-nix
   fugitive
   friendly-snippets
   vim-obsession
   vimtex
   tabular
   (pkgs.vimUtils.buildVimPlugin {
     name = "jupynium";
     src = pkgs.fetchFromGitHub {
       owner = "kiyoon";
       repo = "jupynium.nvim";
       rev = "master";
       sha256 = "sha256-tSm4dTVtthtmEM8Fe+dVAELnhNUpOgSsfvFKwq8uLf8=";
     };
   })
 ];

 opts = {
   number = true;

   shiftwidth = 4;
 };


 extraConfigLua = ''

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
  ];






};



}
