package.path = package.path .. ';/usr/local/share/lua/5.4/?.lua;/opt/homebrew/share/lua/5.4/?.lua'
package.cpath = package.cpath .. ';/usr/local/lib/lua/5.4/?.so;/opt/homebrew/lib/lua/5.4/?.so'

local griderr, grid  = pcall(function() return require "mjolnir.bg.grid" end)
local windowerr, window = pcall(function() return require "mjolnir.window" end)
local hotkeyerr, hotkey = pcall(function() return require "mjolnir.hotkey" end)
local alerterr, alert = pcall(function() return require "mjolnir.alert" end)
local fnutilserr, fnutils = pcall(function() return require "mjolnir.fnutils" end)

function print_if_not_table(var)
	if not(type(var) == "table") then print(var) end
end

if not griderr or not windowerr or not hotkeyerr or not alerterr then
	mjolnir.showerror("Some packages appear to be missing.")
	print("At least one package was missing. Have you installed the packages? See README.md.")
	print_if_not_table(grid)
	print_if_not_table(window)
	print_if_not_table(hotkey)
	print_if_not_table(alert)
	print_if_not_table(fnutils)
end

hyper = {"cmd", "alt", "ctrl", "shift"}
MARGIN = 2
GRIDWIDTH = 12
GRIDHEIGHT = 9

grid.MARGINX = MARGIN
grid.MARGINY = MARGIN

-- ternary if
function tif(cond, a, b)
	if cond then return a else return b end
end

function reset_granularity()
	grid.GRIDWIDTH = GRIDWIDTH
	grid.GRIDHEIGHT = GRIDHEIGHT
end

reset_granularity()

function change_granularity(iswidth, delta)
	if iswidth then
		grid.GRIDWIDTH = grid.GRIDWIDTH + delta
	else
		grid.GRIDHEIGHT = grid.GRIDHEIGHT + delta
	end

	alert.show(grid.GRIDWIDTH.." x "..grid.GRIDHEIGHT)
end

function centerpoint()
	w = grid.GRIDWIDTH - 2
	h = grid.GRIDHEIGHT - 2
	return { x = 1, y = 1, w = w, h = h }
end

function fullheightatcolumn(column)
	return { x = column - 1, y = 0, w = 1, h = grid.GRIDHEIGHT }
end

function ifwin(fn)
	return function()
		local win = window.focusedwindow()
		if win then fn(win) end
	end
end

function toggle_desktop_visibility()
	local handle = io.popen("defaults read com.apple.finder CreateDesktop -bool")
	local result = handle:read("*a")
	handle:close()
	if string.sub(result, 1, 1) == "1" then
		os.execute("defaults write com.apple.finder CreateDesktop -bool false")
	else os.execute("defaults write com.apple.finder CreateDesktop -bool true")
	end
	os.execute("killall Finder")
end

local grid_shortcuts = {
	-- Move the active window
	[";"] = ifwin(grid.snap),
	up = ifwin(grid.pushwindow_up),
	left = ifwin(grid.pushwindow_left),
	right = ifwin(grid.pushwindow_right),
	down = ifwin(grid.pushwindow_down),
	F = ifwin(grid.pushwindow_nextscreen),
	-- Resize the active window
	A = ifwin(grid.resizewindow_thinner),
	D = ifwin(grid.resizewindow_wider),
	W = ifwin(grid.resizewindow_shorter),
	S = ifwin(grid.resizewindow_taller),
	space = ifwin(grid.maximize_window),
	E = ifwin(function(win) grid.set(win, centerpoint(), win:screen()) end),
	-- Change number of grid snap-points
	["["] = function() change_granularity(true, -1) end,
	["-"] = function() change_granularity(false, -1) end,
	["="] = function() change_granularity(false, 1) end,
	["]"] = function() change_granularity(true, 1) end,
	["0"] = function() reset_granularity() alert.show(GRIDWIDTH.." x "..GRIDHEIGHT) end,
	-- Misc
	R = mjolnir.reload,
	H = toggle_desktop_visibility,
	-- ` reserved for Dash
	-- 4 reserved for CleanShot scrolling capture
	-- T reserved for Pixelsnap
	-- P reserved for Pika
	-- C reserved for Paste
	-- V reserved for Paste
}

for key, func in pairs(grid_shortcuts) do
	hotkey.bind(hyper, key, func)
end

alert.show(" 👑\n 💀")
