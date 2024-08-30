{configs, pkgs, ...}: {


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
        };

      };

      treesitter = {
        enable = true;

        nixGrammars = true;

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
        '';

        servers = {

          clangd.enable = true;

          bashls.enable = true;

          nixd.enable = true;
          
          lua-ls.enable = true;

        };
      };

      rust-tools = {
        enable = true;
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







        nvim-autopairs = {

          enable = true;
        };

      };
      extraPlugins = with pkgs.vimPlugins; [
        vim-nix
        fugitive
        vimtex
        friendly-snippets
        vim-obsession
      ];

      opts = {
        number = true;

        shiftwidth = 4;
      };

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
  ];






};



}
