-- Rust Development Configuration

-- Rust-specific settings
vim.g.rustfmt_autosave = 1
vim.g.rust_clip_command = 'xclip -selection clipboard'

-- Setup rust-tools.nvim
local function setup_rust_tools()
    local rt_ok, rt = pcall(require, "rust-tools")
    if not rt_ok then
        vim.notify("rust-tools.nvim not found. Run :PlugInstall to install plugins.", vim.log.levels.WARN)
        return false
    end
    
    rt.setup({
        server = {
            on_attach = function(_, bufnr)
                -- Hover actions
                vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
                -- Code action groups
                vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
            end,
            settings = {
                ["rust-analyzer"] = {
                    checkOnSave = {
                        command = "clippy"
                    },
                    cargo = {
                        allFeatures = true,
                    },
                    completion = {
                        postfix = {
                            enable = false,
                        },
                    },
                }
            }
        },
        tools = {
            hover_actions = {
                auto_focus = true,
            },
            inlay_hints = {
                auto = true,
                show_parameter_hints = false,
                parameter_hints_prefix = "",
                other_hints_prefix = "",
            },
        },
        dap = {
            adapter = {
                type = 'executable',
                command = 'lldb-vscode',
                name = "rt_lldb",
            },
        },
    })
    return true
end

-- Setup crates.nvim for Cargo.toml management
local function setup_crates()
    local crates_ok, crates = pcall(require, 'crates')
    if not crates_ok then
        vim.notify("crates.nvim not found. Run :PlugInstall to install plugins.", vim.log.levels.WARN)
        return false
    end
    
    crates.setup({
        smart_insert = true,
        insert_closing_quote = true,
        autoload = true,
        autoupdate = true,
        loading_indicator = true,
        date_format = "%Y-%m-%d",
        thousands_separator = ".",
        notification_title = "Crates",
        curl_args = { "-sL", "--retry", "1" },
        max_parallel_requests = 80,
        enable_update_available_warning = true,
        on_attach = function(bufnr)
            -- Crates keymaps
            local opts = { silent = true, buffer = bufnr }
            vim.keymap.set("n", "<leader>ct", require('crates').toggle, opts)
            vim.keymap.set("n", "<leader>cr", require('crates').reload, opts)
            vim.keymap.set("n", "<leader>cv", require('crates').show_versions_popup, opts)
            vim.keymap.set("n", "<leader>cf", require('crates').show_features_popup, opts)
            vim.keymap.set("n", "<leader>cd", require('crates').show_dependencies_popup, opts)
            vim.keymap.set("n", "<leader>cu", require('crates').update_crate, opts)
            vim.keymap.set("v", "<leader>cu", require('crates').update_crates, opts)
            vim.keymap.set("n", "<leader>ca", require('crates').update_all_crates, opts)
            vim.keymap.set("n", "<leader>cU", require('crates').upgrade_crate, opts)
            vim.keymap.set("v", "<leader>cU", require('crates').upgrade_crates, opts)
            vim.keymap.set("n", "<leader>cA", require('crates').upgrade_all_crates, opts)
            vim.keymap.set("n", "<leader>cH", require('crates').open_homepage, opts)
            vim.keymap.set("n", "<leader>cR", require('crates').open_repository, opts)
            vim.keymap.set("n", "<leader>cD", require('crates').open_documentation, opts)
            vim.keymap.set("n", "<leader>cC", require('crates').open_crates_io, opts)
        end
    })
    return true
end

-- Setup DAP for Rust debugging
local function setup_rust_dap()
    local dap_ok, dap = pcall(require, 'dap')
    if not dap_ok then
        vim.notify("nvim-dap not found. Run :PlugInstall to install plugins.", vim.log.levels.WARN)
        return false
    end
    
    dap.adapters.lldb = {
        type = 'executable',
        command = '/usr/bin/lldb-vscode', -- adjust as needed
        name = 'lldb'
    }
    
    dap.configurations.rust = {
        {
            name = 'Launch',
            type = 'lldb',
            request = 'launch',
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
            args = {},
            
            -- 💀
            -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
            --
            --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
            --
            -- Otherwise you might get the following error:
            --
            --    Error on launch: Failed to attach to the target process
            --
            -- But you should be aware of the implications:
            -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
            runInTerminal = false,
        },
    }
    return true
end

-- Setup DAP UI
local function setup_dap_ui()
    local dapui_ok, dapui = pcall(require, "dapui")
    if not dapui_ok then
        vim.notify("nvim-dap-ui not found. Run :PlugInstall to install plugins.", vim.log.levels.WARN)
        return false
    end
    
    local dap_ok, dap = pcall(require, "dap")
    if not dap_ok then
        vim.notify("nvim-dap not found. Run :PlugInstall to install plugins.", vim.log.levels.WARN)
        return false
    end
    
    dapui.setup({
        icons = { expanded = "▾", collapsed = "▸" },
        mappings = {
            expand = { "<CR>", "<2-LeftMouse>" },
            open = "o",
            remove = "d",
            edit = "e",
            repl = "r",
            toggle = "t",
        },
        expand_lines = vim.fn.has("nvim-0.7"),
        layouts = {
            {
                elements = {
                    { id = "scopes", size = 0.25 },
                    "breakpoints",
                    "stacks",
                    "watches",
                },
                size = 40,
                position = "left",
            },
            {
                elements = {
                    "repl",
                    "console",
                },
                size = 0.25,
                position = "bottom",
            },
        },
        floating = {
            max_height = nil,
            max_width = nil,
            border = "single",
            mappings = {
                close = { "q", "<Esc>" },
            },
        },
        windows = { indent = 1 },
        render = {
            max_type_length = nil,
        }
    })
    
    -- Auto open/close DAP UI
    local dap, dapui = dap, dapui
    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
    end
    return true
end

-- Setup virtual text for DAP
local function setup_dap_virtual_text()
    local vtext_ok, vtext = pcall(require, "nvim-dap-virtual-text")
    if not vtext_ok then
        vim.notify("nvim-dap-virtual-text not found. Run :PlugInstall to install plugins.", vim.log.levels.WARN)
        return false
    end
    
    vtext.setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        only_first_definition = true,
        all_references = false,
        filter_references_pattern = '<module',
        virt_text_pos = 'eol',
        all_frames = false,
        virt_lines = false,
        virt_text_win_col = nil
    })
    return true
end

-- Rust-specific keymaps
local function setup_rust_keymaps()
    -- Rust run commands
    vim.keymap.set("n", "<leader>rr", ":!cargo run<CR>", { desc = "Cargo run" })
    vim.keymap.set("n", "<leader>rt", ":!cargo test<CR>", { desc = "Cargo test" })
    vim.keymap.set("n", "<leader>rb", ":!cargo build<CR>", { desc = "Cargo build" })
    vim.keymap.set("n", "<leader>rc", ":!cargo check<CR>", { desc = "Cargo check" })
    vim.keymap.set("n", "<leader>rC", ":!cargo clippy<CR>", { desc = "Cargo clippy" })
    vim.keymap.set("n", "<leader>rf", ":!cargo fmt<CR>", { desc = "Cargo format" })
    vim.keymap.set("n", "<leader>rd", ":!cargo doc --open<CR>", { desc = "Cargo docs" })
    
    -- Debug keymaps (only if DAP is available)
    local dap_ok, dap = pcall(require, 'dap')
    local dapui_ok, dapui = pcall(require, 'dapui')
    
    if dap_ok then
        vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Continue" })
        vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step over" })
        vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step into" })
        vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step out" })
        vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle breakpoint" })
        vim.keymap.set("n", "<leader>dB", function()
            dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
        end, { desc = "Debug: Set conditional breakpoint" })
        vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Debug: Open REPL" })
        vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Debug: Run last" })
    end
    
    if dapui_ok then
        vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Debug: Toggle UI" })
    end
    return true
end

-- Initialize all Rust configurations
local function init_rust_config()
    local success = true
    
    -- Setup rust-tools first (includes LSP)
    if not setup_rust_tools() then
        success = false
    end
    
    -- Setup crates.nvim for Cargo.toml
    if not setup_crates() then
        success = false
    end
    
    -- Setup debugging (optional - don't fail if not available)
    setup_rust_dap()
    setup_dap_ui()
    setup_dap_virtual_text()
    
    -- Setup keymaps (always works)
    setup_rust_keymaps()
    
    if success then
        vim.notify("Rust development environment loaded successfully!", vim.log.levels.INFO)
    else
        vim.notify("Some Rust plugins missing. Run :PlugInstall to install.", vim.log.levels.WARN)
    end
end

-- Auto-setup when opening Rust files
vim.api.nvim_create_autocmd("FileType", {
    pattern = "rust",
    callback = function()
        -- Rust file type setup (no auto-format on save)
        vim.notify("Rust LSP loaded. Use <leader>q to format manually.", vim.log.levels.INFO)
    end,
})

-- Only load the configuration if we're not in the initial plugin install phase
local function safe_init()
    -- Check if we're in the middle of plugin installation
    local plug_dir = vim.fn.stdpath('data') .. '/plugged'
    if vim.fn.isdirectory(plug_dir .. '/rust-tools.nvim') == 1 then
        init_rust_config()
    else
        vim.notify("Rust plugins not installed yet. Run :PlugInstall first.", vim.log.levels.INFO)
    end
end

-- Load the configuration
safe_init()

return {}
