local wezterm = require("wezterm")

wezterm.on("toggle-opacity", function(window, _)
	local overrides = window:get_config_overrides() or {}
	if not overrides.window_background_opacity then
		overrides.window_background_opacity = 0.8
		overrides.text_background_opacity = 0.8
	else
		overrides.window_background_opacity = nil
		overrides.text_background_opacity = nil
	end
	window:set_config_overrides(overrides)
end)

return {
	-- color_scheme = "nord",
	colors = {
		foreground = "#dcd7ba",
		background = "#1f1f28",

		cursor_bg = "#c8c093",
		cursor_fg = "#c8c093",
		cursor_border = "#c8c093",

		selection_fg = "#c8c093",
		selection_bg = "#2d4f67",

		scrollbar_thumb = "#16161d",
		split = "#16161d",

		ansi = { "#090618", "#c34043", "#76946a", "#c0a36e", "#7e9cd8", "#957fb8", "#6a9589", "#c8c093" },
		brights = { "#727169", "#e82424", "#98bb6c", "#e6c384", "#7fb4ca", "#938aa9", "#7aa89f", "#dcd7ba" },
		indexed = { [16] = "#ffa066", [17] = "#ff5d62" },
	},
	font = wezterm.font("FiraCode Nerd Font"),
	enable_tab_bar = true,
	default_cursor_style = "BlinkingBar",
	cursor_blink_rate = 500,
	exit_behavior = "CloseOnCleanExit",
	font_size = 14,
	initial_cols = 160,
	initial_rows = 48,
	window_decorations = "RESIZE",
	window_padding = {
		left = 2,
		right = 0,
		top = 0,
		bottom = 0,
	},
	use_ime = true,
	keys = {
		{
			key = "d",
			mods = "SUPER|SHIFT",
			action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }),
		},
		{
			key = "d",
			mods = "SUPER",
			action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
		},
		{ key = "Enter", mods = "SUPER", action = "ToggleFullScreen" },
		{ key = "w", mods = "SUPER", action = wezterm.action({ CloseCurrentPane = { confirm = false } }) },
		{ key = "[", mods = "SUPER", action = wezterm.action({ ActivatePaneDirection = "Prev" }) },
		{ key = "]", mods = "SUPER", action = wezterm.action({ ActivatePaneDirection = "Next" }) },
		{ key = "u", mods = "SUPER", action = wezterm.action({ EmitEvent = "toggle-opacity" }) },
	},
}
