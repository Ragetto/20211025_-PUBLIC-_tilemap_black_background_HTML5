local M = {}
-------------------------------------------------------


----------============---------
----====== FUNCTIONAL =====-----
----------============---------

M.G_DEBUG = 1 -- JC 24/01/2021 00:08 # 0/1 => debug text displayed or not


----------============----
-----
----====== GAMEPLAY =====-----
----------============---------

-- tilemap

M.TILEMAP_URL = "/tilemaps#tilemap-32x32-001-Tilemap-32x32-001"


-- Camera
M.SCROLLING_MAX_NB_FRAMES = 3 -- JC 29/09/2021 21:02 # Used in the map scrolling (nb of frames recorded / inserted into a table)
M.SCROLLING_SENSIVITY = 0.75  -- from 0.5 to 1
M.SCROLLING_X = 0 -- 0: no / 1: yes
M.SCROLLING_Y = 1 -- 0: no / 1: yes


----------=====================---------
-----====== MESSAGE VARIABLES =====-----
----------=====================---------
M.GO_URL_MAIN_CONTROLLER = "/main_controller"
M.GO_URL_GUI = "/gui#gui"
M.GO_URL_GAMESAVE = "/gamesave#gamesave"


return M