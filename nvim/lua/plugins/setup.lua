require("nvim-surround").setup {}
require("various-textobjs").setup {
    useDefaultKeymaps = true,
    disabledKeymaps = {"ii", "ai", "aI", "iI" },
}
if vim.g.vscode then 
    require('vscode-multi-cursor').setup { 
        default_mappings = true 
    }
end
