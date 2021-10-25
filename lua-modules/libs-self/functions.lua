---========================---
---== LUA MODULE IMPORTS ==---
---========================---
local debugdraw = require("lua-modules.libs-defold.debug-draw.debug-draw")
local defmath = require("lua-modules.libs-defold.defmath.defmath")
local lume = require("lua-modules.libs-external.lume.lume")
local c = require("lua-modules.gamedata.constants")
local color1 = require("lua-modules.libs-external.color-converter.convertcolor")

----------------------------------------------------------------

---================================---
-----=== GENERIC/COMMON FUNCTIONS ===----
---================================---

----------------------------------
-- Returns length of a LUA table (nb of entries)
----------------------------------
function tablelength(table)
	local count = 0
	for _ in pairs(table) do count = count + 1 end
	return count
end

----------------------------------
-- Empties a table
----------------------------------
function emptytable(table)
	for k,v in pairs(table) do table[k]=nil end
end

----------------------------------
-- Splits a string (using a separator, ex: "|") and insert the pieces into a table
----------------------------------
function mysplit (inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end
----------------------------------
-- Classic average of numbered values in a TABLE
----------------------------------
function math.average(t)
	local sum = 0
	for _,v in pairs(t) do -- Get the sum of all numbers in t
		sum = sum + v
	end
	return sum / #t
end

----------------------------------
-- Average of vector values in a table too
----------------------------------
function average_table_vector3(table)
	local max = tablelength(table)
	local sum_x = 0
	local sum_y = 0
	local sum_z = 0
	local avg_x = 0
	local avg_y = 0
	local avg_z = 0

	for i=1,max do
		sum_x = sum_x + table[i].x
		sum_y = sum_y + table[i].y
		sum_z = sum_z + table[i].z
	end

	if max == 0 then
		avg_x = 0
		avg_y = 0
		avg_z = 0		
	else
		avg_x = sum_x / max
		avg_y = sum_y / max
		avg_z = sum_z / max
	end

	return avg_x,avg_y,avg_z

end

---========================---
---=== TABLE FUNCTIONS ===----
---========================---

----------------------------------
-- Table initialization - Returns a 2D table filled with given value
----------------------------------
function create_2d_table(nb_columns, nb_rows, value)

	local table = {}

	for i=1,nb_columns do
		table[i] = {}

		for j=1,nb_rows do
			table[i][j] = value
		end

	end
	
	return table
	
end


----------------------------------
-- GENERIC / Turns a 1-dimension array into a 2-dimensions array (with nb of rows & columns specified)
----------------------------------
function table_1d_to_2d(table_1d, nb_columns, nb_rows)

	local table_2d = {} -- 2d table that will be returned by the function
	local nb_values = tablelength(table_1d)
	
	for i=1,nb_columns do
		table_2d[i] = {}
		for j=1,nb_rows do
			index = i + (nb_values - j * nb_columns) -- cette fois le point de départ doit partir dans l'autre sens ... 981 > 961 > ... > 81 > 61 > 41 > 21
			table_2d[i][j] = table_1d[index]
		end
	end

	return table_2d
end


----------------------------------
-- GENERIC / Adds a given value to all the entry of a 2d table (may also work for 1d table?? to be tested)
----------------------------------
function operation_2d_table_all_entries(table, operation, value)
	-- Operations:
	-- ">" (replace)  
	-- "+" (add)
	-- "-" (substract)
	-- "*" (multiply)
	-- "/" (add)

	local table_final = table
	
	for i=1,#table_final do
		for j=1,#table_final[i] do
			if operation == ">" then
				table_final[i][j] = value
			elseif operation == "+" then
				table_final[i][j] = table[i][j] + value
			elseif operation == "-" then
				table_final[i][j] = table[i][j] - value
			elseif operation == "*" then
				table_final[i][j] = table[i][j] * value
			elseif operation == "/" then
				table_final[i][j] = table[i][j] / value
			end
		end		
	end

	return table
	
end


---========================---
---=== TILEMAP FUNCTIONS ===---
----------- Tiled ---
--- https://www.mapeditor.org/ ---
---========================---

----------------------------------
-- Returns the nb columns/rows and tiles width/height (.lua layers file exported from Tiled)
----------------------------------
function get_tilemap_and_tiles_dimensions(lua_layers_table)

	return lua_layers_table.width, lua_layers_table.height, lua_layers_table.tilewidth, lua_layers_table.tileheight

end


----------------------------------
-- Returns the world coordinates of a tilemap's column/row
----------------------------------
function get_tile_world_position(lua_layers_table, tilemap_url, column, row)

	-- lua_layers_table is  used to get the basic info light nb of columns/rows of the timelmap + width/height of each tile
	-- tilemap_url is used to get the position of the tilemap
	
	local pos_tile = vmath.vector3() -- what we will return
	local pos_tilemap = go.get_world_position(tilemap_url)
	local tilemap_nb_columns, tilemap_nb_rows, tile_width, tile_height = get_tilemap_and_tiles_dimensions(lua_layers_table)
	
	local tilemap_width = tilemap_nb_columns * tile_height
	local tilemap_height = tilemap_nb_rows * tile_width

	pos_tile.x = tile_width/2 + tile_width * (column-1)
	pos_tile.y = tile_height/2 + tile_height * (row-1)

	return pos_tile

end


----------------------------------
-- Creates the layers grid with tiles ids (not the "walkable" values yet)
-- (= turns the raw .lua table (exported from Tiled) into a big but usable/formated lua table)
----------------------------------
----------------------------------
function create_layers_table_with_tile_ids(lua_layers_table, lua_tileset_table)

	--------------------
	--- Part 1 > Create the layer structure, with the unformatted grids

	local layers_table_final = {}

	local nb_layers = tablelength(lua_layers_table)
	for i=1,nb_layers do
		layers_table_final[i] = {}
		layers_table_final[i].id = lua_layers_table[i].id
		layers_table_final[i].name = lua_layers_table[i].name
		layers_table_final[i].data = table_1d_to_2d(lua_layers_table[i].data,lua_layers_table[i].width,lua_layers_table[i].height)
	end

	for i=1,nb_layers do -- we substract 1 so it can be consistent with tile IDs (since Tiled add +1 to the tilemap data by default)
		layers_table_final[i].data = operation_2d_table_all_entries(layers_table_final[i].data,"-",1)
	end

	return layers_table_final

end


----------------------------------
-- Creates an empty layers table with init values (layers[i].data[j][k].walkable = 1 etc.)
-- So we can use this table in the "final" version of the table
----------------------------------

function create_layers_table_EMPTY(table_layers_with_ids, value_tile_id, value_slot, value_walkable)

	local nb_layers = tablelength(table_layers_with_ids)
	local nb_columns = tablelength(table_layers_with_ids[1].data)
	local nb_rows = tablelength(table_layers_with_ids[1].data[1])
	
	local table_layers = {
		data = {}
	}

	for i=1,nb_layers do
		table_layers[i] =
			{
				data = {}
			}
			
		for j=1,nb_columns do
			table_layers[i].data[j] = {}

			for k=1,nb_rows do
				table_layers[i].data[j][k] = {
					tile_id = value_tile_id,
					slot = value_slot,
					walkable = value_walkable
				}
				
			end
			
		end
		
	end

	return table_layers

end


----------------------------------
-- Creates the final version of the layers table (with the actual values for tile_id, slot and walkable (24/10/2021)
----------------------------------
function create_layers_table_FINAL(lua_layers_table, lua_tileset_table)

	-- First we create an empty table_layers, with the same structure as the final one but empty values (that we will replace later)
	local table_layers_tile_ids = create_layers_table_with_tile_ids(lua_layers_table, lua_tileset_table)
	local table_layers_final = create_layers_table_EMPTY(table_layers_tile_ids, -1 , 0 ,1)
	
	-- Then we will the empty table with values from the tileset table (ile_id, slot, walkable for now 24/10/2021)
	for i=1,#table_layers_tile_ids do -- we go through the first big table => layers (ex: length 4)	
		for j=1,#table_layers_tile_ids[i].data do -- then we enter the "data" table and scan the rows (of the 2d table)
			for k=1,#table_layers_tile_ids[i].data[j] do -- then we scan the columns to get the actual value
				local nb_tiles = tablelength(lua_tileset_table)
				local grid_value = table_layers_tile_ids[i].data[j][k]
				
				for l=1,nb_tiles do
					if lua_tileset_table[l].id == grid_value then --  then we compare the tile id and the value in the layer data table
						table_layers_final[i].data[j][k].tile_id = tonumber(lua_tileset_table[l].id)
						table_layers_final[i].data[j][k].slot = tonumber(lua_tileset_table[l].properties.slot)
						table_layers_final[i].data[j][k].walkable = tonumber(lua_tileset_table[l].properties.walkable)
					end
					
				end
			end
		end
	end

	return table_layers_final -- JC 24/10/2021 01:31 " Sauf que là c'est le final qu'on retournera"

end


----------------------------------
-- Creates an empty level grid, assigning initial values for the pathfinding (walkable) and the building slots
-- JC 24/10/20201 19:07 # Some other parameters my be added in the future
----------------------------------

function create_level_grid_EMPTY(layers_table, value_slot, value_walkable)

	local level_grid = {}

	for i=1,#layers_table[1].data do
		level_grid[i] = {}

		for j=1,#layers_table[1].data[1] do
			level_grid[i][j] = {
				slot = value_slot,
				walkable = value_walkable
			}

		end

	end

	return level_grid

end

----------------------------------
-- Create the final pathfinding grid from the layers table (by replacing by "walkable" if similar value in tileset_table) 
----------------------------------

function create_level_grid(layers_table)

	local nb_columns = tablelength(layers_table[1].data)
	local nb_rows = tablelength(layers_table[1].data[1])
	local nb_slots = 0
		
	local level_grid = create_level_grid_EMPTY(layers_table,0,1) -- "empty grid" with all "slot" at 0 and all "walkable" at 1
	
	-- first we traverse the n layers to check the "slot" and "walkable" value to build the level_grid
	for k=1,#layers_table do
		for i=1,nb_columns do
			for j=1,nb_rows do
				
				if layers_table[k].data[i][j].slot == 1 then
					level_grid[i][j].slot = layers_table[k].data[i][j].slot
					nb_slots = nb_slots + 1
					--print("slot = 1!!")
				end

				if layers_table[k].data[i][j].walkable == 0 then
					level_grid[i][j].walkable = layers_table[k].data[i][j].walkable
					--print("walkable = 0!!")
				end
				
			end
		end
	end


	-- then we just replace the "1" value for each "slot" by a number (from 1 to nb of slots)
	-- could be a  function but specific & simple enough to have it here...
	-- note: we must do it separately since before that we didn't know the max nb of "slots"
	for i=1,#level_grid do
		for j=1,#level_grid[i] do
			if level_grid[i][j].slot == 1 then
				level_grid[i][j].slot = nb_slots
				nb_slots = nb_slots - 1
			end
		end

	end		
	
	return level_grid
	
end


----------------------------------
-- Counts occurrence of a given SLOT value in the level_grid
-- Will be used to finalized the level_grid (by assigning a number to each slot)
----------------------------------
function count_level_grid_slots(table, value)

	local counter = 0

	for i=1,#table do
		for j=1,#table[i] do
			if table[i][j].slot == value then
				counter = counter + 1
			end
		end

	end

	return counter

end


---========================---
-----=== GUI FUNCTIONS ===----
---========================---

----------------------------------
-- 
----------------------------------
function gui_button_state(node_img, node_txt, button_id, state_target)
	-- Image
	local node = gui.get_node(node_img) -- node_img => the button shape
	gui.set_texture(node, "gui") -- texture = atlas in this case
	gui.play_flipbook(node, button_id.."_state"..state_target) -- button_id => 001 (standard), 002, 003 etc.
	-- Text outline
	local node = gui.get_node(node_txt) -- node_img => the main text written on the button (ex: "PLAY")
	local R,G,B,A = 0,0,0,0
	if state_target == 0 then
		R,G,B,A = 100,100,100,1
	elseif state_target == 1 then
		R,G,B,A = 0,51,0,1
	end
	local color = vmath.vector4(R/255, G/255, B/255, A)
	gui.set_outline(node,color)
end

----------------------------------
-- 
---------------------------------
function gui_node2node_position(node2move_id, target_node_id)
	-- based on this: https://forum.defold.com/t/gui-set-screen-position-and-gui-screen-pos-to-node-pos/47365
	-- get screen position of the node
	local node = gui.get_node(target_node_id)
	local screen_pos_TEST = gui.get_screen_position(node)

	-- set screen position for another node
	local node = gui.get_node(node2move_id)	
	gui.set_screen_position(node, screen_pos_TEST)
end

----------------------------------
-- 
---------------------------------
function gui_color_text(node_id, text_color, outline_color)
	local node = gui.get_node(node_id)
	gui.set_color(node, text_color)
	gui.set_outline(node, outline_color)
end


---========================---
----=== TEST FUNCTIONS ===----
---========================---

----------------------------------
-- 
---------------------------------
function addition(param1,param2)  -- JC 16/01/2021 19:21 # Just a quick test to see how to import functions from external modules
	local result = param1 + param2
	return result
end


---========================---
---=== DEBUG FUNCTIONS ===----
---========================---

----------------------------------
-- 
---------------------------------
function DEBUG_print_2d_array_info(table, type)

	-- JC 21/10/2021 00:05 # The function now takes into account the "column as 1st dimension - i" to print it with the right orientaion
	-- (which was not the case before that - cf below)

	-- JC 23/10/2021 23:25 # Type; 0: value (ex: number) / 1: table.tile_id (#) / 2: table.slot (1/0) / 3: table.walkable (1/0)
	
	local nb_columns = tablelength(table)
	local nb_rows = tablelength(table[1])

	if type == 0 then
		print("Value type: basic")
	elseif type == 1 then
		print("Value type: table.tile_id")
	elseif type == 2 then
		print("Value type: table.slot")
	elseif type == 3 then
		print("Value type: table.walkable")
	end


	local text = ""

	for j=1,nb_rows do
		text = ""
		for i=1,nb_columns do
			if type == 0 then
				text = text.."["..table[i][nb_rows-j+1].."]"
			elseif type == 1 then
				text = text.."["..table[i][nb_rows-j+1].tile_id.."]"
			elseif type == 2 then
				text = text.."["..table[i][nb_rows-j+1].slot.."]"
			elseif type == 3 then
				text = text.."["..table[i][nb_rows-j+1].walkable.."]"
			end
			
			if i == nb_columns then
				print(text)
			end	
		end
		print("---")
	end
end

-----------------------------------
-- Draw the pathfinding squares
function DEBUG_draw_pathfinding_grid_squares(lua_layers_table, tilemap_url, level_grid)
	
	local tilemap_nb_columns, tilemap_nb_rows, tile_width, tile_height = get_tilemap_and_tiles_dimensions(lua_layers_table)

	for i=1,#level_grid do
		for j=1,#level_grid[i] do
			local column_square = i
			local row_square = j
			local tile_pos = get_tile_world_position(lua_layers_table, tilemap_url, column_square, row_square)
			if level_grid[i][j].walkable == 0 then
				color = debugdraw.COLORS.red
			else
				color = debugdraw.COLORS.green
			end
			debugdraw.box(tile_pos.x, tile_pos.y, tile_width-1, tile_height-1, color)
		end
	end
	local color = debugdraw.COLORS.yellow
	debugdraw.text("", 0, 0, color)
	
end


----------------------------------
-- 
---------------------------------
function DEBUGdrawsquare(center_x,center_y,square_width,square_height,color)
	debugdraw.line(center_x-square_width/2, center_y+square_height/2, center_x+square_width/2, center_y+square_height/2, color)
	debugdraw.line(center_x-square_width/2, center_y-square_height/2, center_x+square_width/2, center_y-square_height/2, color)
	debugdraw.line(center_x+square_width/2, center_y+square_height/2, center_x+square_width/2, center_y-square_height/2, color)
	debugdraw.line(center_x-square_width/2, center_y+square_height/2, center_x-square_width/2, center_y-square_height/2, color)
end