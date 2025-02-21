require("which-key").add({
  -- General
  { "<leader>e", Snacks.explorer.open, desc = "File explorer" },
  { "<leader>q", "<cmd>qa<cr>", desc = "Quit" },
  { "<leader>/", Snacks.picker.grep, desc = "Grep" },
  {
    "<leader><space>",
    function()
      Snacks.picker.smart({
        multi = { "buffers", "files" },
        layout = { preview = true },
      })
    end,
    desc = "Find files",
  },
  {
    "<leader>?",
    function() require("which-key").show({ global = false }) end,
    desc = "Buffer keymaps (which-key)",
  },
  {
    "<c-/>",
    Snacks.terminal.toggle,
    mode = { "n", "t" },
    desc = "Toggle terminal",
  },
  {
    "<cr>",
    function() require("flash").jump() end,
    mode = { "n", "o", "v" },
  },

  -- Buffers
  { "<leader>b", group = "buffer" },
  { "<leader>bd", Snacks.bufdelete.delete, desc = "Close buffer" },
  { "<leader>bD", "<cmd>:bd<cr>", desc = "Close buffer and window" },
  { "<leader>bh", "<cmd>bp<cr>", desc = "Previous buffer" },
  { "<leader>bl", "<cmd>bn<cr>", desc = "Next buffer" },
  { "<leader>bn", "<cmd>enew<cr>", desc = "New buffer" },
  { "<leader>bo", Snacks.bufdelete.other, desc = "Close all other buffers" },
  { "<leader>bs", sol.send_buffer_to_split("s"), desc = "Send buffer to split" },
  { "<leader>bv", sol.send_buffer_to_split("v"), desc = "Send buffer to vertical split" },

  -- Git
  { "<leader>g", group = "git" },
  { "<leader>gb", Snacks.picker.git_branches, desc = "Branches" },
  { "<leader>gd", Snacks.picker.git_diff, desc = "Diff (hunks)" },
  { "<leader>gf", Snacks.picker.git_log_file, desc = "Log file" },
  { "<leader>gg", Snacks.lazygit.open, desc = "Lazygit" },
  { "<leader>gl", Snacks.picker.git_log, desc = "Log" },
  { "<leader>gL", Snacks.picker.git_log_line, desc = "Log line" },
  { "<leader>gn", "<cmd>Neogit<cr>", desc = "Neogit" },
  { "<leader>gs", Snacks.picker.git_status, desc = "Status" },
  { "<leader>gS", Snacks.picker.git_stash, desc = "Stash" },
  { "<leader>gz", Snacks.lazygit.open, desc = "Lazygit" },

  -- Multicursors
  { "<leader>m", group = "multicursors" },
  {
    "<leader>ma",
    function() require("multicursor-nvim").toggleCursor() end,
    desc = "Toggle cursor at the current position",
    mode = { "n", "v" },
  },
  {
    "<leader>mc",
    function() require("multicursor-nvim").clearCursors() end,
    desc = "Clear cursors",
    mode = { "n", "v" },
  },
  {
    "<leader>mi",
    function() require("multicursor-nvim").insertVisual() end,
    desc = "Create a cursor in each selected line",
    mode = "x",
  },
  {
    "<leader>mj",
    function() require("multicursor-nvim").lineAddCursor(1) end,
    desc = "Add cursor below",
    mode = { "n", "v" },
  },
  {
    "<leader>mk",
    function() require("multicursor-nvim").lineAddCursor(-1) end,
    desc = "Add cursor above",
    mode = { "n", "v" },
  },
  {
    "<leader>mn",
    function() require("multicursor-nvim").matchAddCursor(1) end,
    desc = "Add cursor and jump to next match",
    mode = { "n", "v" },
  },
  {
    "<leader>mp",
    function() require("multicursor-nvim").matchAddCursor(-1) end,
    desc = "Add cursor and jump to previous match",
    mode = { "n", "v" },
  },
  {
    "<leader>mt",
    function()
      local mc = require("multicursor-nvim")
      if mc.cursorsEnabled() then
        mc.disableCursors()
      else
        mc.enableCursors()
      end
    end,
    desc = "Toggle cursors",
    mode = { "n", "v" },
  },
  {
    "<leader>mu",
    function() require("multicursor-nvim").restoreCursors() end,
    desc = "Restore cursors",
    mode = { "n", "v" },
  },
  {
    "<leader>mw",
    function() require("multicursor-nvim").operator({ motion = "iw" }) end,
    desc = "Add cursor to every match of [word] in [motion]",
    mode = { "n", "x" },
  },
  {
    "<leader>mx",
    function() require("multicursor-nvim").operator() end,
    desc = "Add cursor to every match of [operator] in [motion]",
    mode = "n",
  },
  {
    "<leader>m<a-n>",
    function() require("multicursor-nvim").matchSkipCursor(1) end,
    desc = "Jump to next match",
    mode = { "n", "v" },
  },
  {
    "<leader>m<a-p>",
    function() require("multicursor-nvim").matchSkipCursor(-1) end,
    desc = "Jump to previous match",
    mode = { "n", "v" },
  },
  {
    "<leader>m<space>",
    function()
      --  HACK: The goal is to set scrolloff to a huge value, essentially locking the cursor to the vertical center of the screen,
      --        until we are out of hydra mode.
      --        Which-key unfortunately provides no callback for when that happens, so we hook key presses and compare them against '<esc>'
      local esc_termcode = vim.api.nvim_replace_termcodes("<esc>", true, true, true)
      local ns = vim.api.nvim_create_namespace("center-cursor-while-in-hydra-mode")
      vim.on_key(function(_, typed)
        if typed == esc_termcode then
          -- Go back to the global value
          vim.cmd.setlocal("scrolloff<")
          -- Remove the callback
          vim.on_key(nil, ns)
        end
      end, ns)

      vim.cmd.setlocal("scrolloff=999")
      require("which-key").show({ keys = "<leader>m", loop = true })
    end,
    desc = "Hydra Mode",
    mode = { "n", "v" },
  },

  -- Search
  { "<leader>s", group = "search" },
  { "<leader>sa", Snacks.picker.autocmds, desc = "Autocmds" },
  { "<leader>sb", Snacks.picker.lines, desc = "Buffer lines" },
  { "<leader>sB", Snacks.picker.buffers, desc = "Buffer list" },
  { "<leader>sc", Snacks.picker.command_history, desc = "Command history" },
  { "<leader>sC", Snacks.picker.commands, desc = "Commands" },
  { "<leader>sd", Snacks.picker.diagnostics_buffer, desc = "Diagnostics (buffer)" },
  { "<leader>sD", Snacks.picker.diagnostics, desc = "Diagnostics" },
  { "<leader>sh", Snacks.picker.help, desc = "Help pages" },
  { "<leader>sH", Snacks.picker.highlights, desc = "Highlights" },
  { "<leader>si", Snacks.picker.icons, desc = "Icons" },
  { "<leader>sk", Snacks.picker.keymaps, desc = "Keymaps" },
  { "<leader>sn", Snacks.picker.notifications, desc = "Notification history" },
  { "<leader>sq", Snacks.picker.qflist, desc = "Quickfix list" },
  { "<leader>sp", Snacks.picker.lazy, desc = "Search plugin spec" },
  {
    "<leader>sr",
    function()
      local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
      require("grug-far").open({
        transient = true,
        prefills = {
          filesFilter = ext and ext ~= "" and "*." .. ext or nil,
        },
      })
    end,
    desc = "Search and replace",
    mode = { "n", "v" },
  },
  { "<leader>sR", Snacks.picker.resume, desc = "Resume" },
  { "<leader>su", Snacks.picker.undo, desc = "Undotree" },
  { '<leader>s"', Snacks.picker.registers, desc = "Registers" },
  { "<leader>s/", Snacks.picker.search_history, desc = "Search history" },
  { "<leader>sw", Snacks.picker.grep_word, desc = "Grep Word", mode = { "n", "x" } },

  -- UI
  { "<leader>u", group = "ui" },
  { "<leader>uC", Snacks.picker.colorschemes, desc = "Colorschemes" },
  { "<leader>ui", vim.show_pos, desc = "Inspect position" },
  { "<leader>uI", "<cmd>InspectTree<cr>", desc = "Inspect tree" },

  -- Windows
  { "<leader>w", group = "windows", proxy = "<c-w>" },
  { "<leader>wd", "<c-w>c", desc = "Close window" },
  sol.toggle({
    key = "<leader>wm",
    name = "zoom",
    get = function() return Snacks.zen.win and Snacks.zen.win:valid() or false end,
    set = function(state)
      if state then
        Snacks.zen.zoom()
      elseif Snacks.zen.win then
        Snacks.zen.win:close()
      end
    end,
  }),
  { "<c-h>", "<c-w>h", desc = "Go to the left window" },
  { "<c-j>", "<c-w>j", desc = "Go to the lower window" },
  { "<c-k>", "<c-w>k", desc = "Go to the upper window" },
  { "<c-l>", "<c-w>l", desc = "Go to the right window" },

  { "<leader>wr", group = "resize" },
  { "<leader>wr=", "<c-w>=", desc = "Equally high and wide" },
  { "<leader>wr_", "<c-w>_", desc = "Max out the height" },
  { "<leader>wr|", "<c-w>|", desc = "Max out the width" },
  { "<leader>wr<left>", "<cmd>vertical resize -2<cr>", desc = "Decrease width" },
  { "<leader>wr<right>", "<cmd>vertical resize +2<cr>", desc = "Increase width" },
  { "<leader>wr<up>", "<cmd>resize +2<cr>", desc = "Increase height" },
  { "<leader>wr<down>", "<cmd>resize -2<cr>", desc = "Decrease height" },
  {
    "<leader>wr<space>",
    function() require("which-key").show({ keys = "<leader>wr", loop = true }) end,
    desc = "Hydra Mode",
  },

  -- Yazi
  { "<leader>y", group = "yazi" },
  {
    "<leader>yR",
    "<cmd>Yazi toggle<cr>",
    desc = "Resume",
    mode = { "n", "v" },
  },
  {
    "<leader>yy",
    "<cmd>Yazi<cr>",
    desc = "Open yazi (file)",
    mode = { "n", "v" },
  },
  {
    "<leader>yY",
    "<cmd>Yazi cwd<cr>",
    desc = "Open yazi (cwd)",
    mode = { "n", "v" },
  },

  -- Tabs
  { "<leader><tab>", group = "tabs" },
  { "<leader><tab>d", "<cmd>tabc<cr>", desc = "Close tab" },
  { "<leader><tab>h", "<cmd>tabp<cr>", desc = "Go to the previous tab" },
  { "<leader><tab>l", "<cmd>tabn<cr>", desc = "Go to the next tab" },
  { "<leader><tab>n", "<cmd>tabnew<cr>", desc = "New tab" },
  { "<leader><tab>o", "<cmd>tabo<cr>", desc = "Close all other tabs" },

  -- Save with <c-s>
  {
    "<c-s>",
    "<cmd>w<cr>",
    desc = "Save buffer",
    mode = { "n", "i" },
  },
  -- Clear search on escape
  {
    "<esc>",
    function()
      vim.cmd("noh")
      return "<esc>"
    end,
    mode = { "i", "n", "s" },
    expr = true,
  },
  -- Better <c-o>
  { "<c-o>", "<left><c-o>", mode = "i" },
  -- Better delete/yank/copy
  { "D", "dd" },
  { "Y", "yy" },
  { "C", "cc" },
  -- Better up/down
  { "j", "v:count == 0 ? 'gj' : 'j'", mode = { "n", "x" }, expr = true, silent = true },
  { "<down>", "v:count == 0 ? 'gj' : 'j'", mode = { "n", "x" }, expr = true, silent = true },
  { "k", "v:count == 0 ? 'gk' : 'k'", mode = { "n", "x" }, expr = true, silent = true },
  { "<up>", "v:count == 0 ? 'gk' : 'k'", mode = { "n", "x" }, expr = true, silent = true },
  -- Better indenting
  { "<", "<gv", mode = "v" },
  { ">", ">gv", mode = "v" },
  -- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
  { "n", "'Nn'[v:searchforward].'zv'", mode = "n", expr = true },
  { "N", "'nN'[v:searchforward].'zv'", mode = "n", expr = true },
  { "n", "'Nn'[v:searchforward]", mode = "x", expr = true },
  { "N", "'nN'[v:searchforward]", mode = "x", expr = true },
  { "n", "'Nn'[v:searchforward]", mode = "o", expr = true },
  { "N", "'nN'[v:searchforward]", mode = "o", expr = true },
  -- Move in insert mode
  { "<c-h>", "<left>", mode = "i", remap = true },
  { "<c-j>", "<down>", mode = "i", remap = true },
  { "<c-k>", "<up>", mode = "i", remap = true },
  { "<c-l>", "<right>", mode = "i", remap = true },
})
