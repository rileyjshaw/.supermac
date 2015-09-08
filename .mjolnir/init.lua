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

mash = {"cmd", "alt", "ctrl"}
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

function change_granularity(iswidth, del)
  if iswidth then
    grid.GRIDWIDTH = grid.GRIDWIDTH + del
  else
    grid.GRIDHEIGHT = grid.GRIDHEIGHT + del
  end

  alert.show(tif(iswidth, grid.GRIDWIDTH, grid.GRIDHEIGHT))
end

function centerpoint()
  w = grid.GRIDWIDTH / 2
  h = grid.GRIDHEIGHT / 2
  return { x = w / 2, y = h / 2, w = w, h = h }
end

function fullheightatcolumn(column)
  return { x = column - 1, y = 0, w = 1, h = grid.GRIDHEIGHT }
end

local grid_shortcuts = {
  R = mjolnir.reload,
  [";"] = function() grid.snap(window.focusedwindow()) end,
  up = grid.pushwindow_up,
  left = grid.pushwindow_left,
  right = grid.pushwindow_right,
  down = grid.pushwindow_down,
  A = grid.resizewindow_thinner,
  D = grid.resizewindow_wider,
  W = grid.resizewindow_shorter,
  S = grid.resizewindow_taller,
  space = grid.maximize_window,
  F = grid.pushwindow_nextscreen,
  C = function() grid.set(window.focusedwindow(), centerpoint(), window.focusedwindow():screen()) end,
  H = function() change_granularity(true, 1) end,
  J = function() change_granularity(false, 1) end,
  K = function() change_granularity(false, -1) end,
  L = function() change_granularity(true, -1) end,
  ["1"] = function() grid.set(window.focusedwindow(), fullheightatcolumn(1), window.focusedwindow():screen()) end,
  ["2"] = function() grid.set(window.focusedwindow(), fullheightatcolumn(2), window.focusedwindow():screen()) end,
  ["3"] = function() grid.set(window.focusedwindow(), fullheightatcolumn(3), window.focusedwindow():screen()) end,
  ["4"] = function() grid.set(window.focusedwindow(), fullheightatcolumn(4), window.focusedwindow():screen()) end,
  ["0"] = function() reset_granularity() alert.show(GRIDWIDTH..", "..GRIDHEIGHT) end
}

for key, func in pairs(grid_shortcuts) do
  hotkey.bind(mash, key, func)
end

alert.show(" 🎩\n 💀")
