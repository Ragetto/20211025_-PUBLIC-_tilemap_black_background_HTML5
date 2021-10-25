return {
  version = "1.5",
  luaversion = "5.1",
  tiledversion = "1.7.2",
  orientation = "orthogonal",
  renderorder = "right-up",
  width = 14,
  height = 7,
  tilewidth = 32,
  tileheight = 32,
  nextlayerid = 7,
  nextobjectid = 1,
  properties = {},
  tilesets = {
    {
      name = "Tilemap-32x32-001",
      firstgid = 1,
      filename = "workfiles/32x32/Tilemap-32x32-001.tsx",
      exportfilename = "tilemap-32x32-001-tiles.lua"
    }
  },
  layers = {
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 14,
      height = 7,
      id = 3,
      name = "ground",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 14,
      height = 7,
      id = 2,
      name = "walls",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        224, 163, 163, 163, 163, 163, 163, 163, 163, 163, 163, 163, 163, 184,
        201, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 201,
        201, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 201,
        201, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 201,
        201, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 201,
        201, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 201,
        163, 163, 163, 163, 163, 163, 163, 163, 163, 163, 163, 163, 163, 204
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 14,
      height = 7,
      id = 4,
      name = "Items",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 298, 299, 0, 0, 0, 0, 0, 0, 0, 0, 296, 297, 0,
        0, 318, 319, 0, 334, 334, 334, 334, 334, 334, 0, 316, 317, 0,
        0, 0, 0, 0, 354, 354, 354, 354, 354, 354, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 336, 0, 0, 0, 0, 0, 0, 0, 0, 335, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    }
  }
}
