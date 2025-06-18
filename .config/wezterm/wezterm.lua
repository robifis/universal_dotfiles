-- ~/.config/wezterm/wezterm.lua

-- Import the wezterm library
local wezterm = require 'wezterm'

-- This table will hold our final configuration
local config = {}

-- WezTerm recommends this, especially for Windows users, but it's good practice
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  config.default_prog = { 'powershell.exe', '-NoLogo' }
end

-- ===================================================
-- ||               THEME SELECTION                 ||
-- ===================================================
-- Define all your color palettes here.
local themes = {
  gruvbox_mist = {
    background = '#2E3440',
    foreground = '#D8DEE9',
    cursor_bg = '#D8DEE9',
    cursor_fg = '#2E3440',
    selection_bg = '#434C5E',
    selection_fg = '#ECEFF4',
    ansi = { '#4C566A', '#BF616A', '#A3BE8C', '#EBCB8B', '#81A1C1', '#B48EAD', '#88C0D0', '#ECEFF4' },
    brights = { '#4C566A', '#BF616A', '#A3BE8C', '#EBCB8B', '#81A1C1', '#B48EAD', '#88C0D0', '#ECEFF4' },
  },
  gruvbox_dusk = {
    background = '#32302F',
    foreground = '#D4BE98',
    cursor_bg = '#D4BE98',
    cursor_fg = '#32302F',
    selection_bg = '#45403D',
    selection_fg = '#D4BE98',
    ansi = { '#45403D', '#C14A4A', '#8F9A64', '#D8A657', '#76949F', '#B28395', '#83A598', '#D4BE98' },
    brights = { '#45403D', '#C14A4A', '#8F9A64', '#D8A657', '#76949F', '#B28395', '#83A598', '#D4BE98' },
  },
  gruvbox_paper = {
    background = '#F2E5BC',
    foreground = '#504945',
    cursor_bg = '#504945',
    cursor_fg = '#F2E5BC',
    selection_bg = '#D5C4A1',
    selection_fg = '#504945',
    ansi = { '#928374', '#9D0006', '#79740E', '#B57614', '#458588', '#8F3F71', '#427B58', '#3C3836' },
    brights = { '#928374', '#9D0006', '#79740E', '#B57614', '#458588', '#8F3F71', '#427B58', '#3C3836' },
  },
}

-- CHOOSE YOUR THEME HERE by changing the name
config.colors = themes.gruvbox_dusk -- Options: gruvbox_mist, gruvbox_dusk, gruvbox_paper

-- ===================================================
-- ||               FONT CONFIGURATION              ||
-- ===================================================
config.font = wezterm.font_with_fallback {
  -- Your primary font
  'Ligature SF Nerd Font',
  -- Your fallback font
  'JetBrains Mono Nerd Font',
  -- A good generic fallback for symbols
  'Symbols Nerd Font',
}
config.font_size = 14.0

-- ===================================================
-- ||             AESTHETICS & WINDOW               ||
-- ===================================================
config.window_background_opacity = 0.95 -- Set to 1.0 for solid
config.window_padding = {
  left = 10,
  right = 10,
  top = 10,
  bottom = 10,
}
config.window_decorations = "RESIZE" -- Removes titlebar on systems that support it
config.hide_tab_bar_if_only_one_tab = true

-- ===================================================
-- ||              KEYBINDINGS & LAUNCHER           ||
-- ===================================================
config.keys = {}
local act = wezterm.action

-- OS-specific keybindings for Yazi
if wezterm.target_triple:find 'apple' then
  -- macOS: Cmd+Shift+Y
  table.insert(config.keys, {
    key = 'Y',
    mods = 'CMD|SHIFT',
    action = act.SpawnCommandInNewTab {
      cwd = 'file://' .. wezterm.home_dir,
      args = { 'yazi' },
    },
  })
else
  -- Linux: Ctrl+Shift+Y
  table.insert(config.keys, {
    key = 'Y',
    mods = 'CTRL|SHIFT',
    action = act.SpawnCommandInNewTab {
      cwd = 'file://' .. wezterm.home_dir,
      args = { 'yazi' },
    },
  })
end

-- ===================================================
-- ||                 RETURN CONFIG                 ||
-- ===================================================
return config
