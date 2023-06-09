local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        "ray-x/lsp_signature.nvim",
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lsp = require("lspconfig")
            local capabilities = vim.lsp.protocol.make_client_capabilities()

            local function on_attach(client, bufnr)
                require("lsp_signature").on_attach({}, bufnr)
            end

            lsp.gopls.setup({ capabilities = capabilities, on_attach = on_attach })

            vim.lsp.handlers["textDocument/publishDiagnostics"] =
                vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
                    update_in_insert = false,
                })
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        commit = "09ff53f",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    expand = function(args) end,
                },
                sources = {
                    { name = "nvim_lsp" },
                },
                mapping = {
                    ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
                    ["<CR>"] = cmp.mapping(cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Insert,
                        select = true,
                    })),
                },
            })
        end,
    },
})
