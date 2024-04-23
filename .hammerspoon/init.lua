hyper = {"cmd", "alt", "ctrl", "shift"}
MARGIN = 2
GRIDWIDTH = 12
GRIDHEIGHT = 9

hs.grid.MARGINX = MARGIN
hs.grid.MARGINY = MARGIN
hs.window.animationDuration = 0

-- ternary if
function tif(cond, a, b)
	if cond then return a else return b end
end

function resetGranularity()
	hs.grid.GRIDWIDTH = GRIDWIDTH
	hs.grid.GRIDHEIGHT = GRIDHEIGHT
end

resetGranularity()

function changeGranulatiry(iswidth, delta)
	if iswidth then
		hs.grid.GRIDWIDTH = math.max(hs.grid.GRIDWIDTH + delta, 1)
	else
		hs.grid.GRIDHEIGHT = math.max(hs.grid.GRIDHEIGHT + delta, 1)
	end

	hs.alert.show(hs.grid.GRIDWIDTH.." x "..hs.grid.GRIDHEIGHT)
end

function centerPoint()
	w = hs.grid.GRIDWIDTH - 2
	h = hs.grid.GRIDHEIGHT - 2
	return { x = 1, y = 1, w = w, h = h }
end

function fullHeightAtColumn(column)
	return { x = column - 1, y = 0, w = 1, h = hs.grid.GRIDHEIGHT }
end

function ifWin(fn)
	return function()
		local win = hs.window.focusedWindow()
		if win then fn(win) end
	end
end

function toggleDesktopVisibility()
	local handle = io.popen("defaults read com.apple.finder CreateDesktop -bool")
	local result = handle:read("*a")
	handle:close()
	if string.sub(result, 1, 1) == "1" then
		os.execute("defaults write com.apple.finder CreateDesktop -bool false")
	else os.execute("defaults write com.apple.finder CreateDesktop -bool true")
	end
	os.execute("killall Finder")
end

local gridShortcuts = {
	-- Move the active window
	[";"] = ifWin(hs.grid.snap),
	up = ifWin(hs.grid.pushWindowUp),
	left = ifWin(hs.grid.pushWindowLeft),
	right = ifWin(hs.grid.pushWindowRight),
	down = ifWin(hs.grid.pushWindowDown),
	F = ifWin(function(win) win:moveToScreen(win:screen():next()) end),
	-- Resize the active window
	A = ifWin(hs.grid.resizeWindowThinner),
	D = ifWin(hs.grid.resizeWindowWider),
	W = ifWin(hs.grid.resizeWindowShorter),
	S = ifWin(hs.grid.resizeWindowTaller),
	space = ifWin(hs.grid.maximizeWindow),
	E = ifWin(function(win) hs.grid.set(win, centerPoint(), win:screen()) end),
	-- Change number of grid snap-points
	["["] = function() changeGranulatiry(true, -1) end,
	["-"] = function() changeGranulatiry(false, -1) end,
	["="] = function() changeGranulatiry(false, 1) end,
	["]"] = function() changeGranulatiry(true, 1) end,
	["0"] = function() resetGranularity() hs.alert.show(GRIDWIDTH.." x "..GRIDHEIGHT) end,
	-- First Order Retrievability (maxbittker.com/first-order-retrievability, thanks Max!)
	["1"] = function() hs.application.launchOrFocus("Visual Studio Code") end,
	["2"] = function() hs.application.launchOrFocus("Firefox Developer Edition") end,
	["3"] = function() hs.application.launchOrFocus("iTerm") end,
	-- Misc
	R = hs.reload,
	H = toggleDesktopVisibility,
	-- ` reserved for Dash
	-- 4 reserved for CleanShot scrolling capture
	-- T reserved for Pixelsnap
	-- P reserved for Pika
	-- C reserved for Paste
	-- V reserved for Paste
}

for key, func in pairs(gridShortcuts) do
	hs.hotkey.bind(hyper, key, func)
end

hs.alert.show(" 👑\n 💀")
