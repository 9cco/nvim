-- Make cursor always fat
-- vim.opt.guicursor = ""

-- Set numbers and relative numbers.
vim.opt.nu = true
vim.opt.rnu = true

-- Make tabs be 4 spaces
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

-- Make search highlighting stop after search is complete
vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

-- Make some margin of 8 lines when scrolling up and down.
vim.opt.scrolloff = 8

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

local function GitBranch()
    local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
    if string.len(branch) > 0 then
        return branch
    else
        return ":"
    end
end

local function statusline()
    local setColor1 = "%#PmenuSel#"
    local branch = GitBranch()
    local setColor2 = "%#LineNr#"
    local staticStatusString = "%n %f %m%r%h%w %= %{&fileencoding?&fileencoding:&encoding} %y %p%% %l:%c"

    return string.format(
        "%s %s %s %s",
        setColor1,
        branch,
        setColor2,
        staticStatusString
    )
end

-- Make statusline show buffer number and percentage
vim.o.statusline = statusline()
