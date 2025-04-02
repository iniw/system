local setup = {}

function setup.diagnostics()
  vim.diagnostic.config({
    float = {
      source = true,
    },

    severity_sort = true,

    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = " ",
        [vim.diagnostic.severity.WARN] = " ",
        [vim.diagnostic.severity.INFO] = " ",
        [vim.diagnostic.severity.HINT] = " ",
      },
    },

    virtual_text = {
      spacing = 4,
      source = "if_many",
      prefix = "●",
    },
  })
end

local function document_symbols()
  local function cursor_in_range(cursor, range)
    local row, col = unpack(cursor)
    row = row - 1
    return (row > range.start.line or (row == range.start.line and col >= range.start.character))
      and (row < range["end"].line or (row == range["end"].line and col <= range["end"].character))
  end

  local cursor = vim.api.nvim_win_get_cursor(0)
  local picker = Snacks.picker.lsp_symbols()
  picker.matcher.task:on(
    "done",
    vim.schedule_wrap(function()
      for symbol in vim.iter(picker:items()):rev() do
        if cursor_in_range(cursor, symbol.range) then
          picker.list:move(symbol.idx, true)
          return
        end
      end
    end)
  )
end

function setup.keymaps(buffer, server_keymaps)
  require("which-key").add({
    buffer = buffer,
    -- Code
    { "<leader>c", group = "code" },
    { "<leader>ca", vim.lsp.buf.code_action, desc = "Code action", mode = { "n", "x" } },
    { "<leader>cd", Snacks.picker.lsp_definitions, desc = "Go to definition" },
    { "<leader>cD", Snacks.picker.lsp_declarations, desc = "Go to declaration" },
    { "<leader>ce", vim.diagnostic.open_float, desc = "Error diagnostics" },
    { "<leader>cf", function() require("conform").format({ async = true }) end, desc = "Format buffer" },
    { "<leader>ci", Snacks.picker.lsp_implementations, desc = "Go to implementation" },
    {
      "<leader>cp",
      function() vim.fn.setreg("+", vim.fn.expand("%") .. ":" .. vim.fn.line(".")) end,
      desc = "Yank gdb breakpoint",
    },
    { "<leader>cr", vim.lsp.buf.rename, desc = "Rename" },
    { "<leader>cR", Snacks.picker.lsp_references, desc = "Go to references" },
    { "<leader>cs", document_symbols, desc = "Document Symbols" },
    { "<leader>cS", Snacks.picker.lsp_workspace_symbols, desc = "Workspace symbols" },
    { "<leader>ct", Snacks.picker.lsp_type_definitions, desc = "Go to type definition" },
    {
      "<leader>cv",
      function() Snacks.picker.lsp_definitions({ confirm = "edit_vsplit" }) end,
      desc = "Go to definition in vertical split",
    },

    -- Hover
    { "K", vim.lsp.buf.hover, desc = "Hover" },

    -- Movement
    { "]d", function() vim.diagnostic.jump({ count = 1 }) end, desc = "Next diagnostic" },
    { "[d", function() vim.diagnostic.jump({ count = -1 }) end, desc = "Previous diagnostic" },
    { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next reference", mode = { "n", "t" } },
    { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Previous reference", mode = { "n", "t" } },

    -- UI
    { "<leader>cu", group = "ui" },
    sol.toggle({
      key = "<leader>cua",
      name = "autocomplete (buffer)",
      get = function() return vim.b.completion ~= false end,
      set = function(state) vim.b.completion = state end,
      buffer = buffer,
    }),
    sol.toggle({
      key = "<leader>cud",
      name = "diagnostics",
      get = function() return vim.diagnostic.is_enabled({ bufnr = buffer }) end,
      set = function(state) vim.diagnostic.enable(state, { bufnr = buffer }) end,
      buffer = buffer,
    }),
    sol.toggle({
      key = "<leader>cuf",
      name = "autoformat (buffer)",
      get = function() return vim.b.autoformat ~= false end,
      set = function(state) vim.b.autoformat = state end,
      buffer = buffer,
    }),
    sol.toggle({
      key = "<leader>cuF",
      name = "autoformat (global)",
      get = function() return vim.g.autoformat ~= false end,
      set = function(state) vim.g.autoformat = state end,
      buffer = buffer,
    }),
    sol.toggle({
      key = "<leader>cuh",
      name = "inlay hints",
      get = function() return vim.lsp.inlay_hint.is_enabled({ bufnr = buffer }) end,
      set = function(state) vim.lsp.inlay_hint.enable(state, { bufnr = buffer }) end,
      buffer = buffer,
    }),
    -- Also add the server specific keymaps
    server_keymaps,
  })
end

---@type LazySpec
return {
  {
    "neovim/nvim-lspconfig",
    event = sol.OnFile,
    config = function(_, opts)
      setup.diagnostics()

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if not client then
            return
          end

          local server_opts = opts.servers[client.name]

          local server_keymaps = server_opts and server_opts.keys and vim.deepcopy(server_opts.keys) or {}
          setup.keymaps(event.buf, server_keymaps)

          local server_capabilities = server_opts and server_opts.server_capabilities or {}
          client.server_capabilities = vim.tbl_deep_extend("force", client.server_capabilities, server_capabilities)
        end,
      })

      local lspconfig = require("lspconfig")
      for server, config in pairs(opts.servers) do
        config.capabilities = sol.lsp_capabilities()
        lspconfig[server].setup(config)
      end
    end,
  },

  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    --- @module "blink.cmp"
    --- @type blink.cmp.Config
    opts = {
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 1000,
        },

        keyword = {
          range = "full",
        },

        menu = {
          draw = {
            components = {
              kind_icon = {
                text = function(ctx)
                  local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                  return kind_icon
                end,
              },
            },
          },
        },
      },

      keymap = {
        preset = "enter",
        ["<c-j>"] = { "select_next", "fallback" },
        ["<c-k>"] = { "select_prev", "fallback" },
      },

      signature = {
        enabled = true,

        trigger = {
          show_on_insert = true,
        },
      },

      sources = {
        default = { "lsp" },
      },
    },
    opts_extend = { "sources.default" },
  },

  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      format_after_save = function(buf)
        if vim.g.autoformat ~= false and vim.b[buf].autoformat ~= false then
          return { lsp_format = "fallback" }
        end
      end,
    },
    init = function() vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()" end,
  },

  {
    "folke/snacks.nvim",
    ---@module "snacks"
    ---@type snacks.Config
    opts = {
      words = {
        enabled = true,
        debounce = 25,
      },
    },
  },
}
