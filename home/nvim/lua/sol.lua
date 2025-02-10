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

function M.toggle(name, key, opts)
  local toggle = Snacks.toggle[name]()
  toggle.opts.name = name:gsub("_", " ")
  toggle:map(key, opts)
end

return M
