local M = {}

function M.lsp_capabilities()
  return require("blink.cmp").get_lsp_capabilities({
    textDocument = {
      completion = { completionItem = { snippetSupport = false } },
    },

    workspace = {
      fileOperations = {
        didRename = true,
        willRename = true,
      },
    },
  }, true)
end

--- Options for `newtoggle`
---@class ToggleOpts
---@field key string
---@field set fun(value: boolean)
---@field get fun(): boolean
---@field name string
---@field buffer? number

---@param opts ToggleOpts
---@return table
function M.toggle(opts)
  local function notify(state, name)
    vim.notify(
      (state and "Disabled " or "Enabled ") .. "**" .. name .. "**",
      state and vim.log.levels.INFO or vim.log.levels.WARN,
      {
        title = "Toggle",
      }
    )
  end

  return {
    opts.key,
    function()
      local state = opts.get()
      opts.set(not state)
      notify(state, opts.name)
    end,
    desc = function()
      local prefix = opts.get() and "Disable " or "Enable "
      return prefix .. opts.name
    end,
    buffer = opts.buffer,
  }
end

M.OnFile = { "BufReadPost", "BufNewFile", "BufWritePre" }

return M
