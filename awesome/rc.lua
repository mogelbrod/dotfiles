-- {{{ Load libraries
	require("awful")
	require("awful.autofocus")
	require("awful.rules")
	require("beautiful")
	require("naughty")
	require("debian.menu")
	require("shifty")
	require("teardrop")
-- }}}

-- {{{ General settings
	terminal = "roxterm"
	editor = "vim"
	editor_cmd = terminal .. " -e " .. editor
	browser = "firefox"
	modkey = "Mod4"
	theme_path = "/home/mogel/.config/awesome/mogelbrod/theme.lua"

	layouts = {
		awful.layout.suit.tile,
		--awful.layout.suit.tile.left,
		awful.layout.suit.tile.bottom,
		--awful.layout.suit.tile.top,
		awful.layout.suit.fair,
		awful.layout.suit.fair.horizontal,
		awful.layout.suit.max,
		--awful.layout.suit.max.fullscreen,
		--awful.layout.suit.magnifier,
		awful.layout.suit.floating
	}

	titlebar_args = { modkey = modkey, height = "16" }
-- }}}

-- {{{ Awesome basic bindings
	globalkeys = awful.util.table.join(
		awful.key({ modkey, "Control" }, "r", awesome.restart),
		awful.key({ modkey, "Control" }, "q", awesome.quit),
		awful.key({ modkey, }, "Return", function () awful.util.spawn(terminal) end),
		awful.key({ modkey, }, "b", function () awful.util.spawn(browser) end),
		awful.key({ modkey }, "c", function () teardrop(terminal, "top") end)
	)
	root.keys(globalkeys)
-- }}}

-- {{{ Shifty (tagging) settings
	shifty.config.sloppy = false

	shifty.config.tags = {
		["1:gen"]  = { position = 1, init = true },
		["2:term"] = { position = 2, init = true },
		["3:work"] = { position = 3, init = true },
		["4:full"] = { position = 4, init = true, layout = awful.layout.suit.max },
		["5:chat"] = { position = 5, init = true, layout = awful.layout.suit.floating },
	}

	shifty.config.apps = {

		{ match = { "^Mirage" }, tag = "4:full" },

		{ match = { "^Buddy List$", "^irssi$", "^conversation$" }, tag = "5:chat", float = true },
		{ match = { "^Buddy List$" }, geometry = {1818,19,260,778} },
		{ match = { "^irssi$" }, geometry = {2,19,600,778} },

		-- Button bindings
		{ match = { "" }, buttons = awful.util.table.join(
			awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
			awful.button({ modkey }, 1, function (c) awful.mouse.client.move() end),
			awful.button({ modkey }, 3, awful.mouse.client.resize )
		)},
	}

	shifty.config.defaults = {
		layout = awful.layout.suit.tile,
		ncol = 2,
		mwfact = 0.60,
		--floatBars = true,
	}
-- }}}

-- {{{ Initialization
	beautiful.init(theme_path)
	shifty.init()
-- }}}

-- {{{ Menus
	awesomemenu = {
		{ "manual", terminal .. " -e man awesome" },
		{ "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
		{ "restart", awesome.restart },
		{ "quit", awesome.quit }
	}

	mainmenu = awful.menu.new({ items = {
		{ "awesome", awesomemenu },
		{ "open terminal", terminal },
		{ "debian", debian.menu.Debian_menu.Debian }
	}})
-- }}}

-- {{{ Wibox
	textclock = awful.widget.textclock({ align = "right"}, "  %H:%M:%S  ", 1)
	systray = widget({ type = "systray" })

	spacer    = widget({ type = "textbox" })
	separator = widget({ type = "textbox" })
	spacer.text    = " "
	separator.text = "|"

-- Create a wibox for each screen and add it
	statusbar = {}
	mypromptbox = {}
	mylayoutbox = {}

	mytaglist = {}
	shifty.taglist = mytaglist
	mytaglist.buttons = awful.util.table.join(
		awful.button({ }, 1, awful.tag.viewonly),
		awful.button({ modkey }, 1, awful.client.movetotag),
		awful.button({ }, 3, awful.tag.viewtoggle),
		awful.button({ modkey }, 3, awful.client.toggletag),
		awful.button({ }, 4, awful.tag.viewnext),
		awful.button({ }, 5, awful.tag.viewprev)
	)

	mytasklist = {}
	mytasklist.buttons = awful.util.table.join(
		awful.button({ }, 1, function (c)
			if not c:isvisible() then
					awful.tag.viewonly(c:tags()[1])
			end
			client.focus = c
			c:raise()
		end),
		awful.button({ }, 3, function ()
			if instance then
					instance:hide()
					instance = nil
			else
					instance = awful.menu.clients({ width=250 })
			end
		end),
		awful.button({ }, 4, function ()
			awful.client.focus.byidx(1)
			if client.focus then client.focus:raise() end
		end),
		awful.button({ }, 5, function ()
			awful.client.focus.byidx(-1)
			if client.focus then client.focus:raise() end
		end)
	)

	for s = 1, screen.count() do
			-- Create a promptbox for each screen
			mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
			-- Create an imagebox widget which will contains an icon indicating which layout we're using.
			-- We need one layoutbox per screen.
			mylayoutbox[s] = awful.widget.layoutbox(s)
			mylayoutbox[s]:buttons(awful.util.table.join(
				awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
				awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
				awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
				awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)
			))
			-- Create a taglist widget
			mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

			-- Create a tasklist widget
			mytasklist[s] = awful.widget.tasklist(function(c)
						return awful.widget.tasklist.label.currenttags(c, s)
				end, mytasklist.buttons)

			-- Create the wibox
			statusbar[s] = awful.wibox({ position = "top", screen = s, height = "16" })
			-- Add widgets to the wibox - order matters
			statusbar[s].widgets = {
					{
							spacer, mytaglist[s],
							spacer, mypromptbox[s], spacer,
							layout = awful.widget.layout.horizontal.leftright
					},
					spacer, mylayoutbox[s],
					spacer, textclock,
					s == 1 and systray or nil,
					spacer, mytasklist[s],
					layout = awful.widget.layout.horizontal.rightleft
			}
	end
-- }}}

-- {{{ Root mouse bindings
	root.buttons(awful.util.table.join(
			--awful.button({ }, 4, awful.tag.viewnext),
			--awful.button({ }, 5, awful.tag.viewprev),
			awful.button({ }, 3, function () mainmenu:toggle() end)
	))
-- }}}

-- {{{ Global key bindings
	globalkeys = awful.util.table.join(globalkeys, 
			-- Menu
			awful.key({ modkey, }, "v", function () mainmenu:show(true) end),

			-- Tag navigation
			awful.key({ modkey, }, "Left",   awful.tag.viewprev       ),
			awful.key({ modkey, }, "Right",  awful.tag.viewnext       ),
			awful.key({ modkey, }, "Tab", awful.tag.history.restore),
			-- Move to another tag
			awful.key({ modkey, "Control" }, "Left",  shifty.send_prev ),
			awful.key({ modkey, "Control" }, "Right", shifty.send_next ),

			-- Client navigation
			awful.key({ modkey, }, "a", function ()
				awful.client.focus.byidx( 1)
				if client.focus then client.focus:raise() end
			end),
			awful.key({ modkey, }, "d", function ()
				awful.client.focus.byidx(-1)
				if client.focus then client.focus:raise() end
			end),

			-- Layout manipulation
			awful.key({ modkey, }, "e", function () awful.client.swap.byidx(  1)    end),
			awful.key({ modkey, }, "q", function () awful.client.swap.byidx( -1)    end),
			awful.key({ modkey, "Shift" }, "a", function () awful.screen.focus_relative( 1) end),
			awful.key({ modkey, "Shift" }, "d", function () awful.screen.focus_relative(-1) end),
			awful.key({ modkey, }, "g", awful.client.urgent.jumpto),
			awful.key({ modkey, }, "Tab", function ()
				awful.client.focus.history.previous()
				if client.focus then
					client.focus:raise()
				end
			end),

			-- Resizing
			awful.key({ modkey, }, "w", function () awful.tag.incmwfact( 0.05) end),
			awful.key({ modkey, }, "s", function () awful.tag.incmwfact(-0.05) end),
			awful.key({ modkey, "Shift"   }, "w", function () awful.tag.incnmaster( 1) end),
			awful.key({ modkey, "Shift"   }, "s", function () awful.tag.incnmaster(-1) end),
			awful.key({ modkey, "Control" }, "w", function () awful.tag.incncol( 1) end),
			awful.key({ modkey, "Control" }, "s", function () awful.tag.incncol(-1) end),
			awful.key({ modkey,        }, "space", function () awful.layout.inc(layouts,  1) end),
			awful.key({ modkey, "Shift"}, "space", function () awful.layout.inc(layouts, -1) end),

			-- Prompt
			awful.key({ modkey }, "r", function () mypromptbox[mouse.screen]:run({ prompt = " Run: "}) end),
			awful.key({ modkey }, "x", function ()
				awful.prompt.run({ prompt = " Run Lua: " },
				mypromptbox[mouse.screen].widget,
				awful.util.eval, nil,
				awful.util.getdir("cache") .. "/history_eval")
			end)
	)

-- {{{ Client key bindings
	clientkeys = awful.util.table.join(
			-- Change apperance
			awful.key({ modkey, }, "F11", function (c) c.fullscreen = not c.fullscreen end),
			awful.key({ modkey, }, "f",  awful.client.floating.toggle),
			awful.key({ modkey, }, "n", function (c) c.minimized = not c.minimized end),
			awful.key({ modkey, }, "m", function (c)
				c.maximized_horizontal = not c.maximized_horizontal
				c.maximized_vertical   = not c.maximized_vertical
			end),
			awful.key({ modkey, }, "t", function (c)
				if   c.titlebar then awful.titlebar.remove(c)
				else awful.titlebar.add(c, titlebar_args) end
			end),
			-- Other functionality
			awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
			awful.key({ modkey, "Control" }, "f", function (c) c:redraw() end),
			awful.key({ modkey, "Shift" }, "c", function (c) c:kill() end),
			awful.key({ modkey, }, "o", awful.client.movetoscreen)
	)
-- }}}

-- {{{ Number keys to tag mappings
	for i=1, ( shifty.config.maxtags or 9 ) do
		globalkeys = awful.util.table.join(globalkeys,
			-- View tag
			awful.key({ modkey, }, i, function ()
				local t = awful.tag.viewonly(shifty.getpos(i))
			end),
			-- Toggle tag
			awful.key({ modkey, "Control" }, i, function ()
				local t = shifty.getpos(i)
				t.selected = not t.selected
			end),
			-- Toggle client on tag
			awful.key({ modkey, "Control", "Shift" }, i, function ()
				if client.focus then
					awful.client.toggletag(shifty.getpos(i))
				end
			end),
			-- Move client to tag
			awful.key({ modkey, "Shift" }, i, function ()
				if client.focus then
					local t = shifty.getpos(i)
					awful.client.movetotag(t)
					awful.tag.viewonly(t)
				end
			end)
		)
	end
-- }}}

-- Set keys
	root.keys(globalkeys)
	shifty.config.globalkeys = globalkeys
	shifty.config.clientkeys = clientkeys
-- }}}

-- {{{ Hooks
	-- Hook function to execute when focusing a client.
	awful.hooks.focus.register(function (c)
			if not awful.client.ismarked(c) then
					c.border_color = beautiful.border_focus
			end
	end)

	-- Hook function to execute when unfocusing a client.
	awful.hooks.unfocus.register(function (c)
		if not awful.client.ismarked(c) then
				c.border_color = beautiful.border_normal
		end
	end)
-- }}}

-- {{{ Signal: a new client appears
client.add_signal("manage", function (c, startup)
    -- Add a titlebar to each floating client
    if awful.client.floating.get(c)
    or awful.layout.get(c.screen) == awful.layout.suit.floating
    and not awful.layout.get(c.screen) == awful.layout.suit.max then
        if not c.titlebar and c.class ~= "Xmessage" then
            --awful.titlebar.add(c, titlebar_args)
        end
        -- Floating clients are always on top
        --c.above = true
    end

    -- Client placement
    if not startup then
        awful.client.setslave(c)

        if  not c.size_hints.user_position
        and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    -- Honor size hints
    --c.size_hints_honor = false

    -- Fix for pre_manage rules patch
    client.focus = c
end)
-- }}}

--naughty.notify({ title = "Awesome", text = "Configuration loaded", timeout = 2 }) 

