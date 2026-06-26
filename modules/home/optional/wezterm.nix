{ ... }:

{
  programs.wezterm = {
    enable = true;

    # The full Lua config — same as our standalone setup, embedded in Nix.
    # Nix places this at ~/.config/wezterm/wezterm.lua automatically.
    extraConfig = ''
      local wezterm = require("wezterm")
      local act     = wezterm.action
      local config  = wezterm.config_builder()

      -- ── Rosé Pine color palette ──────────────────────────────────────────
      local rose_pine = {
        base    = "#191724",
        surface = "#1f1d2e",
        overlay = "#26233a",
        muted   = "#6e6a86",
        subtle  = "#908caa",
        text    = "#e0def4",
        love    = "#eb6f92",
        gold    = "#f6c177",
        rose    = "#ebbcba",
        pine    = "#31748f",
        foam    = "#9ccfd8",
        iris    = "#c4a7e7",
      }

      -- ── Appearance ───────────────────────────────────────────────────────
      config.color_scheme = "rose-pine"
      config.colors = {
        tab_bar = {
          background        = rose_pine.base,
          new_tab           = { bg_color = rose_pine.base,    fg_color = rose_pine.muted  },
          new_tab_hover     = { bg_color = rose_pine.overlay, fg_color = rose_pine.subtle },
          active_tab        = { bg_color = rose_pine.overlay, fg_color = rose_pine.text, intensity = "Bold" },
          inactive_tab      = { bg_color = rose_pine.base,    fg_color = rose_pine.muted  },
          inactive_tab_hover = { bg_color = rose_pine.surface, fg_color = rose_pine.subtle },
        },
      }

      config.font = wezterm.font_with_fallback({
        { family = "JetBrainsMono Nerd Font", weight = "Regular" },
        { family = "JetBrains Mono",          weight = "Regular" },
        "Menlo",
      })
      config.font_size   = 13.5
      config.line_height = 1.2

      config.window_padding               = { left = 16, right = 16, top = 12, bottom = 8 }
      config.window_decorations           = "TITLE | RESIZE"   -- shows traffic light buttons
      config.window_background_opacity    = 0.96
      config.macos_window_background_blur = 20

      config.enable_tab_bar               = true
      config.use_fancy_tab_bar            = false
      config.hide_tab_bar_if_only_one_tab = false  -- always show tab bar so you see cwd/process
      config.tab_max_width                = 32
      config.show_tab_index_in_tab_bar    = false

      config.default_cursor_style  = "BlinkingBar"
      config.cursor_blink_rate     = 600
      config.scrollback_lines      = 10000
      config.audible_bell          = "Disabled"

      -- ── Leader key (CTRL+a, like tmux) ──────────────────────────────────
      config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

      config.keys = {
        -- Pane splits
        { key = "|", mods = "LEADER",    action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
        { key = "-", mods = "LEADER",    action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
        -- Pane navigation (vim-style)
        { key = "h", mods = "LEADER",    action = act.ActivatePaneDirection("Left")  },
        { key = "j", mods = "LEADER",    action = act.ActivatePaneDirection("Down")  },
        { key = "k", mods = "LEADER",    action = act.ActivatePaneDirection("Up")    },
        { key = "l", mods = "LEADER",    action = act.ActivatePaneDirection("Right") },
        -- Pane resize
        { key = "H", mods = "LEADER",    action = act.AdjustPaneSize({ "Left",  5 }) },
        { key = "J", mods = "LEADER",    action = act.AdjustPaneSize({ "Down",  5 }) },
        { key = "K", mods = "LEADER",    action = act.AdjustPaneSize({ "Up",    5 }) },
        { key = "L", mods = "LEADER",    action = act.AdjustPaneSize({ "Right", 5 }) },
        -- Pane zoom / close
        { key = "z", mods = "LEADER",    action = act.TogglePaneZoomState },
        { key = "x", mods = "LEADER",    action = act.CloseCurrentPane({ confirm = true }) },
        -- Tabs
        { key = "c", mods = "LEADER",    action = act.SpawnTab("CurrentPaneDomain") },
        { key = "n", mods = "LEADER",    action = act.ActivateTabRelative(1)  },
        { key = "p", mods = "LEADER",    action = act.ActivateTabRelative(-1) },
        -- CMD shortcuts
        { key = "t", mods = "CMD",       action = act.SpawnTab("CurrentPaneDomain") },
        { key = "d", mods = "CMD",       action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
        { key = "d", mods = "CMD|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
        { key = "[", mods = "CMD",       action = act.ActivateTabRelative(-1) },
        { key = "]", mods = "CMD",       action = act.ActivateTabRelative(1)  },
        -- Pass CTRL+a through (press LEADER twice)
        { key = "a", mods = "LEADER|CTRL", action = act.SendKey({ key = "a", mods = "CTRL" }) },
        -- Copy mode
        { key = "[", mods = "LEADER",    action = act.ActivateCopyMode },
        -- Font size
        { key = "=", mods = "CMD",       action = act.IncreaseFontSize },
        { key = "-", mods = "CMD",       action = act.DecreaseFontSize },
        { key = "0", mods = "CMD",       action = act.ResetFontSize },
      }

      config.mouse_bindings = {
        { event = { Up = { streak = 1, button = "Left" } }, mods = "CMD", action = act.OpenLinkAtMouseCursor },
      }

      -- ── Tab title ────────────────────────────────────────────────────────
      wezterm.on("format-tab-title", function(tab)
        local pane  = tab.active_pane
        local title = tab.tab_title
        if title and #title > 0 then return " " .. title .. " " end
        local process = pane.foreground_process_name:match("([^/]+)$") or ""
        local cwd     = pane.current_working_dir
        local dir     = cwd and (cwd.file_path:match("([^/]+)/?$") or "") or ""
        if process ~= "" and dir ~= "" then
          return " " .. process .. " · " .. dir .. " "
        end
        return " " .. (process ~= "" and process or dir) .. " "
      end)

      -- ── Status bar (clock) ───────────────────────────────────────────────
      wezterm.on("update-right-status", function(window)
        window:set_right_status(wezterm.format({
          { Foreground = { Color = "#6e6a86" } },
          { Text = "  " .. wezterm.strftime("%H:%M") .. "  " },
        }))
      end)

      return config
    '';
  };
}
