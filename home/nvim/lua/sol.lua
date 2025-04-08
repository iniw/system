local M = {}

function M.lsp_capabilities()
  return require("blink.cmp").get_lsp_capabilities(
    {
      workspace = {
        fileOperations = {
          didRename = true,
          willRename = true,
        },
      },
    },
    true -- Include neovim's defaults
  )
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
    vim.notify((state and "Disabled " or "Enabled ") .. "**" .. name .. "**", state and vim.log.levels.INFO or vim.log.levels.WARN, {
      title = "Toggle",
    })
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
    local direction = is_vertical and (vim.opt.splitright and "l" or "h") or (vim.opt.splitbelow and "j" or "k")
    local existing_split_win = vim.fn.win_getid(vim.fn.winnr(direction))

    if existing_split_win > 0 and existing_split_win ~= previous_win then
      vim.api.nvim_win_set_buf(existing_split_win, vim.api.nvim_get_current_buf())
    else
      vim.api.nvim_open_win(0, false, { vertical = is_vertical, win = previous_win })
    end

    vim.fn.win_execute(previous_win, "b#")
  end
end

-- From: https://stackoverflow.com/questions/13848429/window-navigation-wrap-around-in-vim

---@param direction "h"|"j"|"k"|"l"
---@param opposite "h"|"j"|"k"|"l"
function M.jump_window_with_wrap(direction, opposite)
  local function try_jump_window(try_direction, count)
    local prev_win_nr = vim.fn.winnr()
    vim.cmd(count .. "wincmd " .. try_direction)
    return vim.fn.winnr() ~= prev_win_nr
  end

  return function()
    if not try_jump_window(direction, vim.v.count1) then
      try_jump_window(opposite, 999)
    end
  end
end

M.OnFile = { "BufReadPost", "BufNewFile", "BufWritePre" }

return M
