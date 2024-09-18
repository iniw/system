return {
  {
    "folke/noice.nvim",
    opts = {
      routes = {
        {
          -- jdtls' progress notifications are *extremely* spammy, the two "Validate" and "Publish" mentioned in this function in particular
          -- happen about twice for every character typed!
          -- I couldn't figure out a way to filter the lsp events themselves so this just filters the actual rendering of the notifications.
          filter = {
            event = "lsp",
            kind = "progress",
            cond = function(message)
              local client = vim.tbl_get(message.opts, "progress", "client")
              if client ~= "jdtls" then
                return false
              end

              local content = vim.tbl_get(message.opts, "progress", "message")
              if content == nil then
                return false
              end

              return string.find(content, "Validate") or string.find(content, "Publish")
            end,
          },
          opts = { skip = true },
        },
      },
    },
  },
}
