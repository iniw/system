vim.keymap.set('n', '<C-j>', '<C-e>')
vim.keymap.set('n', '<C-k>', '<C-y>')
-- how is this not the default
vim.keymap.set('i', '<C-o>', '<Left><C-o>')
vim.keymap.set('n', 'U', '<C-r>')

if vim.g.vscode then
    vim.keymap.set('n', 'gd', '<Cmd>call VSCodeNotify(\'editor.action.revealDefinition\')<CR>')
    vim.keymap.set('n', 'gD', '<Cmd>call VSCodeNotify(\'editor.action.peekDefinition\')<CR>')

    vim.keymap.set('n', 'gt', '<Cmd>call VSCodeNotify(\'editor.action.revealDeclaration\')<CR>')
    vim.keymap.set('n', 'gT', '<Cmd>call VSCodeNotify(\'editor.action.peekDeclaration\')<CR>')

    vim.keymap.set('n', 'gf', '<Cmd>call VSCodeNotify(\'editor.action.goToReferences\')<CR>')
    vim.keymap.set('n', 'gF', '<Cmd>call VSCodeNotify(\'references-view.findReferences\')<CR>')

    vim.keymap.set('n', 'gi', '<Cmd>call VSCodeNotify(\'clangd.inlayHints.toggle\')<CR>')
    vim.keymap.set('n', 'gl', '<Cmd>call VSCodeNotify(\'editor.action.openLink\')<CR>')

    vim.keymap.set('n', 'gad', '<Cmd>call VSCodeNotify(\'editor.action.revealDefinitionAside\')<CR>')
end
