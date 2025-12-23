local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)

-- Start Config from lspconfig
--
-- Reserve a space in the gutter
-- This will avoid an annoying layout shift in the screen
vim.opt.signcolumn = 'yes'

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lspconfig_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}

    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  end,
})

--
-- End config from lsp-config


-- here you can setup the language servers
-- csharp language server
require('lspconfig').csharp_ls.setup({
    handlers = {
        ["window/showMessage"] = function(_, result, ctx)
            local severity = result.type
            if severity <= vim.lsp.protocol.MessageType.Warning then
                vim.notify(result.message, vim.log.levels[severity])
            end
        end
    },
    root_dir = require('lspconfig.util').root_pattern('*.csproj', '*.sln', '.git'),
})

vim.api.nvim_create_autocmd("LspAttach", {
    pattern = "*.cs",
    callback = function()
        vim.cmd("silent! normal! mx `x")
        vim.defer_fn(function()
            vim.diagnostic.show(nil, 0)
        end, 100)
    end,
})


-- Trying the omnisharp language server was not working either
-- local pid = vim.fn.getpid()
-- local omnisharpBin = "/home/nicolai/Bin/Omnisharp/omnisharp/OmniSharp.exe"
-- local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
-- 
-- require('lspconfig').omnisharp.setup{
--     cmd = { omnisharpBin, "--languageserver", "--hostPID", tostring(pid) },
--     capabilities = capabilities,
--     on_attach = on_attach
-- }
-- 
-- local on_attach = function(client, bufnr)
--     vim.api.nvim_buf_set_options(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
--     vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua.lsp.buf.declaration()<CR>', opts)
-- end


--require('lspconfig').pyright.setup({})

-- Start custom configuration of pyright

local function get_python_path(workspace)
  local util = require('lspconfig/util')
  local path = util.path
  -- Use activated virtualenv.
  if vim.env.VIRTUAL_ENV then
    return path.join(vim.env.VIRTUAL_ENV, 'bin', 'python')
  end

  -- Find and use virtualenv in workspace directory.
  for _, pattern in ipairs({'*', '.*'}) do
    local match = vim.fn.glob(path.join(workspace, pattern, 'pyvenv.cfg'))
    if match ~= '' then
      return path.join(path.dirname(match), 'bin', 'python')
    end
  end

  -- Fallback to system Python.
  return vim.fn.exepath('python3') or vim.fn.exepath('py') or 'py'
end

require('lspconfig').pyright.setup({
  before_init = function(_, config)
    local python_path = get_python_path(config.root_dir)
    config.settings.python.pythonPath = python_path
    vim.g.python_host_prog = python_path
    vim.g.python3_host_prog = python_path
  end
})

-- End custom configuration of pyright

require('lspconfig').lua_ls.setup({})
-- Need to install also julials for julia
-- sourcekit for c/c++

--- in your own config you should replace `example_server`
--- with the name of a language server you have installed

