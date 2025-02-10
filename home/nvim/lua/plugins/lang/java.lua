---@type LazySpec
return {
  {
    "mfussenegger/nvim-jdtls",
    version = false,
    ft = "java",
    config = function()
      local root_dir = require("lspconfig.configs.jdtls").default_config.root_dir

      local function cmd()
        local root = root_dir(vim.api.nvim_buf_get_name(0))
        local project = root and vim.fs.basename(root)
        local full_cmd = { "jdtls" }
        if project then
          vim.list_extend(full_cmd, {
            "-configuration",
            vim.fn.stdpath("cache") .. "/jdtls/" .. project .. "/config",
            "-data",
            vim.fn.stdpath("cache") .. "/jdtls/" .. project .. "/workspace",
          })
        end
        return full_cmd
      end

      local function attach_jdtls()
        local fname = vim.api.nvim_buf_get_name(0)

        require("jdtls").start_or_attach({
          cmd = cmd(),
          root_dir = root_dir(fname),
          capabilities = sol.lsp_capabilities(),
          handlers = {
            -- Disable progress messages, too spammy
            ["$/progress"] = function() end,
          },
        })
      end

      -- `config` is called when the lazy-spec `ft` gets hit, meaning the autocmd created
      -- below won't get hit for the first file, so we call `attach_jdtls` manually.

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = attach_jdtls,
      })

      attach_jdtls()
    end,
  },
}
