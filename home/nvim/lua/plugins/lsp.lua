local setup = {}

function setup.diagnostics()
  vim.diagnostic.config({
    virtual_text = {
      spacing = 4,
      source = "if_many",
      prefix = "●",
    },
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
  })
end

function setup.keymaps(buffer, server_keymaps)
  local function goto_diagnostic(next, severity)
    local go = vim.diagnostic["goto_" .. next]
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function() go({ severity = severity }) end
  end

  require("which-key").add({
    {
      buffer = buffer,

      -- Code
      { "<leader>c", group = "code" },
      { "<leader>ca", vim.lsp.buf.code_action, desc = "Code action", mode = { "n", "x" } },
      {
        "<leader>cb",
        function()
          local file = vim.fn.expand("%")
          local line = vim.fn.line(".")
          local result = file .. ":" .. line
          vim.fn.setreg("+", result)
          vim.notify("Yanked gdb breakpoint", "info")
        end,
        desc = "Yank gdb breakpoint",
      },
      { "<leader>cd", Snacks.picker.lsp_definitions, desc = "Go to definition" },
      { "<leader>cD", Snacks.picker.lsp_declarations, desc = "Go to declaration" },
      { "<leader>ce", vim.diagnostic.open_float, desc = "Error diagnostics" },
      { "<leader>ci", Snacks.picker.lsp_implementations, desc = "Go to implementation" },
      { "<leader>cr", vim.lsp.buf.rename, desc = "Rename" },
      { "<leader>cR", Snacks.picker.lsp_references, desc = "Go to references" },
      { "<leader>ct", Snacks.picker.lsp_type_definitions, desc = "Go to type definition" },
      {
        "<leader>cv",
        function() Snacks.picker.lsp_definitions({ confirm = "edit_vsplit" }) end,
        desc = "Go to definition in vertical split",
      },

      -- Search
      { "<leader>ss", Snacks.picker.lsp_symbols, desc = "Document symbols" },
      { "<leader>sS", Snacks.picker.lsp_workspace_symbols, desc = "Workspace symbols" },

      -- Hover
      { "K", vim.lsp.buf.hover, desc = "Hover" },
      { "<c-k>", vim.lsp.buf.signature_help, desc = "Signature help", mode = "i" },

      -- Movement
      { "]d", goto_diagnostic("next"), desc = "Next diagnostic" },
      { "[d", goto_diagnostic("prev"), desc = "Previous diagnostic" },
      { "]e", goto_diagnostic("next", "ERROR"), desc = "Next error" },
      { "[e", goto_diagnostic("prev", "ERROR"), desc = "Previous error" },
      { "]w", goto_diagnostic("next", "WARN"), desc = "Next warning" },
      { "[w", goto_diagnostic("prev", "WARN"), desc = "Previous warning" },

      -- UI (keymaps added after)
      { "<leader>cu", group = "ui" },
    },
    -- Also add the server specific keymaps
    server_keymaps,
  })

  sol.toggle("inlay_hints", "<leader>cuh", { buffer = buffer })
  sol.toggle("diagnostics", "<leader>cud", { buffer = buffer })
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
          local server_keymaps = client and opts.servers[client.name] and opts.servers[client.name].keys or {}
          setup.keymaps(event.buf, server_keymaps)
        end,
      })

      local lspconfig = require("lspconfig")
      for server, config in pairs(opts.servers) do
        config.capabilities = sol.lsp_capabilities()
        lspconfig[server].setup(config)
      end
    end,
  },
}
