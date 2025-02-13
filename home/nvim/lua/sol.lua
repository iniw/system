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

---@param split "v"|"s"
function M.send_buffer_to_split(split)
  return function()
    local previous_win = vim.fn.win_getid()

    local is_vertical = split == "v"
    local direction = is_vertical and (vim.o.splitright and "l" or "h") or (vim.o.splitbelow and "j" or "k")
    local existing_split_win = vim.fn.win_getid(vim.fn.winnr(direction))

    if existing_split_win > 0 and existing_split_win ~= previous_win then
      vim.api.nvim_win_set_buf(existing_split_win, vim.api.nvim_get_current_buf())
    else
      vim.api.nvim_open_win(0, true, { vertical = is_vertical, win = previous_win })
    end

    vim.fn.win_execute(previous_win, "b#")
  end
end

M.OnFile = { "BufReadPost", "BufNewFile", "BufWritePre" }

return M
