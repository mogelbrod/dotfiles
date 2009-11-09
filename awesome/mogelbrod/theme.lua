-------------------------------
-- "mogelbrod" awesome theme --
--        by mogelbrod       --
-------------------------------

-- {{{ Setup
  theme = {}
  theme.confdir = awful.util.getdir("config") .. "/mogelbrod"
  theme.font = "Sans 8"
	theme.wallpaper_cmd = { "awsetbg /home/mogel/system/wallpapers/current" }
-- }}}

-- {{{ Colors
  theme.fg_normal = "#bbbbbb"
  theme.fg_focus  = "#ffddbb"
  theme.fg_urgent = "#ffffff"
  theme.bg_normal = "#333333"
  theme.bg_focus  = "#444444"
  theme.bg_urgent = "#aa3333"
-- }}}

-- {{{ Borders
  theme.border_width  = "2"
  theme.border_normal = "#333333"
  theme.border_focus  = "#444444"
  theme.border_marked = "#666666"
-- }}}

-- {{{ Titlebars
  theme.titlebar_bg_focus  = "#444444"
  theme.titlebar_bg_normal = "#333333"
-- }}}

-- {{{ Widgets
  theme.fg_widget        = "#aecf96"
  theme.fg_center_widget = "#88a175"
  theme.fg_end_widget    = "#ff5656"
  theme.fg_off_widget    = "#494b4f"
  theme.fg_netup_widget  = "#7f9f7f"
  theme.fg_netdn_widget  = "#cc9393"
  theme.bg_widget        = "#3f3f3f"
  theme.border_widget    = "#3f3f3f"
-- }}}

-- {{{ Mouse finder
  theme.mouse_finder_color = "#9999cc"
-- theme.mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Tooltips
-- theme.tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- }}}

-- {{{ Taglist and Tasklist
-- theme.[taglist|tasklist]_[bg|fg]_[focus|urgent]
-- }}}

-- {{{ Menu
	theme.menu_height = "12"
	theme.menu_width = "120"
	theme.menu_border_width = "0"
-- theme.menu_[bg|fg]_[normal|focus]
-- theme.menu_[height|width|border_color|border_width]
-- }}}

-- {{{ Icons
--
-- {{{ Taglist icons
  theme.taglist_squares_sel   = theme.confdir .. "/icons/taglist/squarefz.png"
  theme.taglist_squares_unsel = theme.confdir .. "/icons/taglist/squareza.png"
--theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc icons
--theme.awesome_icon           = theme.confdir .. "/icons/awesome.png"
	theme.menu_submenu_icon      = theme.confdir .. "/icons/submenu.png" --"/usr/share/awesome/themes/default/submenu.png"
	theme.tasklist_floating_icon = theme.confdir .. "/icons/floating.png" --"/usr/share/awesome/themes/default/tasklist/floatingw.png"
-- }}}

-- {{{ Layout icons
  theme.layout_tile       = theme.confdir .. "/icons/layouts/tile.png"
  theme.layout_tileleft   = theme.confdir .. "/icons/layouts/tileleft.png"
  theme.layout_tilebottom = theme.confdir .. "/icons/layouts/tilebottom.png"
  theme.layout_tiletop    = theme.confdir .. "/icons/layouts/tiletop.png"
  theme.layout_fairv      = theme.confdir .. "/icons/layouts/fairv.png"
  theme.layout_fairh      = theme.confdir .. "/icons/layouts/fairh.png"
  theme.layout_spiral     = theme.confdir .. "/icons/layouts/spiral.png"
  theme.layout_dwindle    = theme.confdir .. "/icons/layouts/dwindle.png"
  theme.layout_max        = theme.confdir .. "/icons/layouts/max.png"
  theme.layout_fullscreen = theme.confdir .. "/icons/layouts/fullscreen.png"
  theme.layout_magnifier  = theme.confdir .. "/icons/layouts/magnifier.png"
  theme.layout_floating   = theme.confdir .. "/icons/layouts/floating.png"
-- }}}

-- {{{ Widget icons
  theme.widget_cpu    = theme.confdir .. "/icons/cpu.png"
  theme.widget_bat    = theme.confdir .. "/icons/bat.png"
  theme.widget_mem    = theme.confdir .. "/icons/mem.png"
  theme.widget_fs     = theme.confdir .. "/icons/disk.png"
  theme.widget_net    = theme.confdir .. "/icons/down.png"
  theme.widget_netup  = theme.confdir .. "/icons/up.png"
  theme.widget_mail   = theme.confdir .. "/icons/mail.png"
  theme.widget_vol    = theme.confdir .. "/icons/vol.png"
  theme.widget_org    = theme.confdir .. "/icons/cal.png"
  theme.widget_date   = theme.confdir .. "/icons/time.png"
  theme.widget_crypto = theme.confdir .. "/icons/crypto.png"
-- }}}

-- {{{ Titlebar icons
  theme.titlebar_close_button_focus  = theme.confdir .. "/icons/titlebar/close_focus.png"
  theme.titlebar_close_button_normal = theme.confdir .. "/icons/titlebar/close_normal.png"

  theme.titlebar_ontop_button_focus_active    = theme.confdir .. "/icons/titlebar/ontop_focus_active.png"
  theme.titlebar_ontop_button_normal_active   = theme.confdir .. "/icons/titlebar/ontop_normal_active.png"
  theme.titlebar_ontop_button_focus_inactive  = theme.confdir .. "/icons/titlebar/ontop_focus_inactive.png"
  theme.titlebar_ontop_button_normal_inactive = theme.confdir .. "/icons/titlebar/ontop_normal_inactive.png"

  theme.titlebar_sticky_button_focus_active    = theme.confdir .. "/icons/titlebar/sticky_focus_active.png"
  theme.titlebar_sticky_button_normal_active   = theme.confdir .. "/icons/titlebar/sticky_normal_active.png"
  theme.titlebar_sticky_button_focus_inactive  = theme.confdir .. "/icons/titlebar/sticky_focus_inactive.png"
  theme.titlebar_sticky_button_normal_inactive = theme.confdir .. "/icons/titlebar/sticky_normal_inactive.png"

  theme.titlebar_floating_button_focus_active    = theme.confdir .. "/icons/titlebar/floating_focus_active.png"
  theme.titlebar_floating_button_normal_active   = theme.confdir .. "/icons/titlebar/floating_normal_active.png"
  theme.titlebar_floating_button_focus_inactive  = theme.confdir .. "/icons/titlebar/floating_focus_inactive.png"
  theme.titlebar_floating_button_normal_inactive = theme.confdir .. "/icons/titlebar/floating_normal_inactive.png"

  theme.titlebar_maximized_button_focus_active    = theme.confdir .. "/icons/titlebar/maximized_focus_active.png"
  theme.titlebar_maximized_button_normal_active   = theme.confdir .. "/icons/titlebar/maximized_normal_active.png"
  theme.titlebar_maximized_button_focus_inactive  = theme.confdir .. "/icons/titlebar/maximized_focus_inactive.png"
  theme.titlebar_maximized_button_normal_inactive = theme.confdir .. "/icons/titlebar/maximized_normal_inactive.png"
-- }}}

return theme
