-- wget run http://localhost:8080/main.lua
-- !!!CURRENT START PARAMS!!!
-- turtle lol
-- diamond pick
-- crafting table
-- tons of fuel (amount to be calculated)

local sb = {}
sb.ITEMS = {}
sb.ITEMS.ANDESITE = "minecraft:andesite"
-- sb.ITEMS.CHEST = "minecraft:chest"
sb.ITEMS.COBBLESTONE = "minecraft:cobblestone"
sb.ITEMS.COBBLESTONE_CHEST = "stonechest:chest_cobblestone"
sb.ITEMS.COBBLESTONE_PART = "stonechest:part_cobblestone"
sb.ITEMS.COGWHEEL = "create:cogwheel"
sb.ITEMS.DIRT = "minecraft:dirt"
sb.ITEMS.EMPTY_SLOT = "minecraft:air"
sb.ITEMS.GRAVEL = "minecraft:gravel"
sb.ITEMS.HAND_CRANK = "create:hand_crank"
sb.ITEMS.MILLSTONE = "create:millstone"
sb.ITEMS.OAK_BUTTON = "minecraft:oak_button"
sb.ITEMS.OAK_LOG = "minecraft:oak_log"
sb.ITEMS.OAK_PLANKS = "minecraft:oak_planks"
sb.ITEMS.OAK_SAPLING = "minecraft:oak_sapling"
sb.ITEMS.POLISHED_ANDESITE = "minecraft:polished_andesite"
sb.ITEMS.RAW_IRON = "minecraft:raw_iron"
sb.ITEMS.STONE_CROOK = "ftbsbc:stone_crook"
sb.ITEMS.STONE_HAMMER = "ftbsbc:stone_hammer"
sb.ITEMS.STONE_ROD = "ftbsbc:stone_rod"

sb.CRAFT_2x2 = {
  1, 2,
  5, 6
}
sb.CRAFT_3x3 = {
  1, 2, 3,
  5, 6, 7,
  9, 10, 11
}

sb.RECIPES = {}

-- load the recipes as defined into the sb.RECIPES table
function sb.load_recipes()
  local _ = sb.ITEMS.EMPTY_SLOT
  local a, b, c, d, e, f, g, h, i, j, k, l, m
  local n, o, p, q, r, s, t, u, v, w, x, y, z

  c = sb.ITEMS.COBBLESTONE_PART
  sb.RECIPES.COBBLESTONE_CHEST = {
    grid = {
      c, c, _,
      c, c, _,
      _, _, _,
    },
    result = sb.ITEMS.COBBLESTONE_CHEST,
    count = 1
  }

  c = sb.ITEMS.COBBLESTONE
  sb.RECIPES.COBBLESTONE_PART = {
    grid = {
      c, _, _,
      _, c, _,
      _, _, _,
    },
    result = sb.ITEMS.COBBLESTONE_PART,
    count = 1
  }

  a = sb.ITEMS.POLISHED_ANDESITE
  b = sb.ITEMS.OAK_BUTTON
  sb.RECIPES.COGWHEEL = {
    grid = {
      b, b, b,
      b, a, b,
      b, b, b,
    },
    result = sb.ITEMS.COGWHEEL,
    count = 1
  }

  a = sb.ITEMS.POLISHED_ANDESITE
  p = sb.ITEMS.OAK_PLANKS
  r = sb.ITEMS.STONE_ROD
  sb.RECIPES.HAND_CRANK = {
    grid = {
      _, r, _,
      p, p, p,
      _, _, a,
    },
    result = sb.ITEMS.HAND_CRANK,
    count = 1
  }

  a = sb.ITEMS.POLISHED_ANDESITE
  c = sb.ITEMS.COGWHEEL
  p = sb.ITEMS.OAK_PLANKS
  sb.RECIPES.MILLSTONE = {
    grid = {
      _, p, _,
      a, c, a,
      _, a, _,
    },
    result = sb.ITEMS.MILLSTONE,
    count = 1
  }

  p = sb.ITEMS.OAK_PLANKS
  sb.RECIPES.OAK_BUTTON = {
    grid = {
      p, _, _,
      _, _, _,
      _, _, _,
    },
    result = sb.ITEMS.OAK_BUTTON,
    count = 1
  }

  l = sb.ITEMS.OAK_LOG
  sb.RECIPES.OAK_PLANKS = {
    grid = {
      l, _, _,
      _, _, _,
      _, _, _,
    },
    result = sb.ITEMS.OAK_PLANKS,
    count = 1
  }

  a = sb.ITEMS.ANDESITE
  sb.RECIPES.POLISHED_ANDESITE = {
    grid = {
      a, a, _,
      a, a, _,
      _, _, _,
    },
    result = sb.ITEMS.POLISHED_ANDESITE,
    count = 1
  }

  r = sb.ITEMS.STONE_ROD
  sb.RECIPES.STONE_CROOK = {
    grid = {
      r, r, _,
      _, r, _,
      _, r, _,
    },
    result = sb.ITEMS.STONE_CROOK,
    count = 1
  }

  c = sb.ITEMS.COBBLESTONE
  r = sb.ITEMS.STONE_ROD
  sb.RECIPES.STONE_HAMMER = {
    grid = {
      c, r, c,
      _, r, _,
      _, r, _,
    },
    result = sb.ITEMS.STONE_HAMMER,
    count = 1
  }

  c = sb.ITEMS.COBBLESTONE
  sb.RECIPES.STONE_ROD = {
    grid = {
      c, _, _,
      c, _, _,
      _, _, _,
    },
    result = sb.ITEMS.STONE_ROD,
    count = 2
  }
end

sb.load_recipes()

-- forward  is  +z
-- left     is  +x
-- up       is  +y
sb.pos = {x = 0, y = 0, z = 0}

-- phases of operation
sb.phases = {}

function sb.safe_up()
  while not turtle.up() do
    turtle.digUp()
  end
end

function sb.safe_forward()
  while not turtle.forward() do
    turtle.dig()
  end
end

function sb.safe_down()
  while not turtle.down() do
    turtle.digDown()
  end
end

-- moves the turtle relative to its current position
-- order is x -> z -> y
function sb.move(x, y, z)
  if x > 0 then
    turtle.turnLeft()
    while x > 0 do
      sb.safe_forward()
      x = x - 1
      sb.pos.x = sb.pos.x + 1
    end
    turtle.turnRight()
  end
  if x < 0 then
    turtle.turnRight()
    while x < 0 do
      sb.safe_forward()
      x = x + 1
      sb.pos.x = sb.pos.x - 1
    end
    turtle.turnLeft()
  end
  while z > 0 do
    sb.safe_forward()
    z = z - 1
    sb.pos.z = sb.pos.z + 1
  end
  if z < 0 then
    turtle.turnLeft()
    turtle.turnLeft()
    while z < 0 do
      sb.safe_forward()
      z = z + 1
      sb.pos.z = sb.pos.z - 1
    end
    turtle.turnLeft()
    turtle.turnLeft()
  end
  while y > 0 do
    sb.safe_up()
    y = y - 1
    sb.pos.y = sb.pos.y + 1
  end
  while y < 0 do
    sb.safe_down()
    y = y + 1
    sb.pos.y = sb.pos.y - 1
  end
end

-- moves the turtle to the specified position
-- order is x -> z -> y
function sb.move_to(x, y, z)
  sb.move(x - sb.pos.x, y - sb.pos.y, z - sb.pos.z)
end

-- moves the turtle to the specified position
-- using the elevation column at 0, 0
-- order is x[0] -> z[0] -> y -> z -> x
function sb.move_to_ele(x, y, z)
  -- move to elevation column and adjust y level
  sb.move_to(0, y, 0)
  -- move to correct z position
  sb.move(0, 0, z)
  -- move to correct x position
  sb.move(x, 0, 0)
end

-- returns the turtle to the origin
function sb.move_origin()
  sb.move_to_ele(0, 0, 0)
end

-- returns true if the turtle has the specified item in its inventory
function sb.inv_has(item_name)
  for i = 1, 16 do
    local item = turtle.getItemDetail(i)
    if item and item.name == item_name then
      return true
    end
  end
  return false
end

-- returns the slot number of the specified item in the turtle's inventory or -1 if not found
function sb.inv_where(item_name, start_index)
  if not start_index then start_index = 1 end
  for i = start_index, 16 do
    local item = turtle.getItemDetail(i)
    if item and item.name == item_name then
      return i
    end
  end
  return -1
end

-- returns the number of the specified item in the turtle's inventory
function sb.inv_count(item_name)
  local count = 0
  for i = 1, 16 do
    local item = turtle.getItemDetail(i)
    if item and item.name == item_name then
      count = count + item.count
    end
  end
  return count
end

-- selects the specified item in the turtle's inventory and returns the slot selected or -1 if not found
function sb.inv_select(item_name)
  local slot = sb.inv_where(item_name)
  if slot > 0 then
    turtle.select(slot)
  end
  return slot
end

-- returns the name of the item in the specified slot or sb.ITEMS.EMPTY_SLOT if the slot is empty
function sb.inv_what(slot)
  local item = turtle.getItemDetail(slot)
  if item then
    return item.name
  else
    return sb.ITEMS.EMPTY_SLOT
  end
end

-- moves items to fill as few of the first slots in the inventory as possible
function sb.inv_organize()
  for i = 1, 16 do
    if turtle.getItemCount(i) ~= 0 then
      turtle.select(i)

      local to = 1
      while to < i and not turtle.transferTo(to, 1) do
        to = to + 1
      end
    end
  end
end

-- move all items in the inventory to storage
function sb.inv_clear()
  sb.move_to_ele(0, -1, 0)

  for i = 1, 16 do
    if turtle.getItemCount(i) > 0 then
      turtle.select(i)
      turtle.drop()
    end
  end
end

-- suck all items from in front of turtle
function sb.suck()
  turtle.select(1)
  while turtle.suck() do end
end

-- craft a stone chest using limited resources
function sb.craft_stone_chest()
  if sb.inv_count(sb.ITEMS.COBBLESTONE) < 8 then
    return false
  end

  for i = 1, 16 do
    local item = sb.inv_what(i)
    if item == sb.ITEMS.COBBLESTONE then
      turtle.select(i)
      turtle.dropUp()
    elseif item ~= sb.ITEMS.EMPTY_SLOT then
      turtle.select(i)
      turtle.drop()
    end
  end

  -- craft cobblestone chest parts
  -- top left
  turtle.select(sb.CRAFT_2x2[1])
  turtle.suckUp(4)
  -- bottom right
  turtle.select(sb.CRAFT_2x2[4])
  turtle.suckUp(4)

  turtle.select(sb.CRAFT_2x2[1])
  turtle.craft(4)

  -- craft cobblestone chest
  turtle.transferTo(sb.CRAFT_2x2[2], 1)
  turtle.transferTo(sb.CRAFT_2x2[3], 1)
  turtle.transferTo(sb.CRAFT_2x2[4], 1)

  turtle.craft(1)

  if turtle.getItemCount(1) == 0 then
    return false
  end

  while turtle.suck() do end
  while turtle.suckUp() do end

  return true
end

-- craft items as defined by a recipe
function sb.craft_basic(recipe)
  local grid = recipe.grid
  local reqs = {}
  for _, v in ipairs(grid) do
    if v ~= sb.ITEMS.EMPTY_SLOT then
      if reqs[v] then
        reqs[v] = reqs[v] + 1
      else
        reqs[v] = 1
      end
    end
  end

  for k, v in pairs(reqs) do
    local needed = sb.inv_count(k)
    if needed < v then
      return false, {
        ["missing"] = k,
        ["count"] = v - needed
      }
    end
  end

  -- move in front of overflow crafting chest
  sb.move_to_ele(0, -1, 0)
  for i = 1, 16 do
    local item = sb.inv_what(i)
    if reqs[item] then
      local count = turtle.getItemCount(i)
      local excess = count - reqs[item]

      if excess > 0 then
        -- drop excess items into chest
        turtle.select(i)
        turtle.drop(excess)
      end

      -- adjust remaining required items
      reqs[item] = reqs[item] - count
      if reqs[item] < 0 then reqs[item] = 0 end
    else
      if turtle.getItemCount(i) > 0 then
        turtle.select(i)
        turtle.drop()
      end
    end
  end

  sb.inv_organize()

  for i = 1, 9 do
    local item = grid[i]
    local grid_slot = sb.CRAFT_3x3[i]

    if item ~= sb.ITEMS.EMPTY_SLOT then
      local where = sb.inv_where(item)
      while where % 4 > 0 and where < grid_slot and turtle.getItemCount(where) == 1 do
        where = sb.inv_where(item, where + 1)
      end

      turtle.select(where)
      if not turtle.transferTo(grid_slot, 1) then
        turtle.select(grid_slot)
        for j = grid_slot + 1, 16 do
          turtle.transferTo(j)
        end

        turtle.select(where)
        turtle.transferTo(grid_slot, 1)
      end
    else
      if turtle.getItemCount(grid_slot) > 0 then
        turtle.select(grid_slot)
        for j = i + 1, 9 do
          turtle.transferTo(sb.CRAFT_3x3[j])
        end
      end
    end
  end

  turtle.select(1)
  local result = turtle.craft()

  return result
end

-- get requirements and craft items as defined by a recipe
function sb.craft(recipe)
  local grid = recipe.grid

  -- calculate required items
  local reqs = {}
  for _, v in ipairs(grid) do
    if v ~= sb.ITEMS.EMPTY_SLOT then
      if reqs[v] then
        reqs[v] = reqs[v] + 1
      else
        reqs[v] = 1
      end
    end
  end

  sb.find_keep(reqs)

  local result, err = sb.craft_basic(recipe)

  return result, err
end

-- find and keep items requested
function sb.find_keep(items_to_keep)
  local items = {}
  for k, v in pairs(items_to_keep) do items[k] = v end

  sb.inv_clear()

  sb.move(1, 0, 0)

  turtle.select(1)
  while turtle.suck() do
    turtle.dropDown()
  end

  while turtle.suckDown() do
    local found = sb.inv_what(1)
    if items[found] and items[found] > 0 then
      items[found] = items[found] - turtle.getItemCount(1)
      if items[found] < 0 then
        -- drop excess items
        turtle.drop(-items[found])
        items[found] = 0
      end

      -- move to next available slot
      local i = 2
      while not turtle.transferTo(i) and i < 16 do
        i = i + 1
      end
    else
      turtle.drop()
    end
  end

  sb.inv_organize()
end

-- harvests a tree
function sb.harvest_tree()
  sb.find_keep({
    [sb.ITEMS.OAK_SAPLING] = 2,
    [sb.ITEMS.DIRT] = 1,
  })

  sb.move_to_ele(0, -1, -1)
  sb.inv_select(sb.ITEMS.DIRT)
  turtle.place()
  sb.move(0, 1, 0)
  sb.inv_select(sb.ITEMS.OAK_SAPLING)
  turtle.place()

  -- wait for tree to grow
  local _, inspect = turtle.inspect()
  while inspect.name ~= "minecraft:oak_log" do
    _, inspect = turtle.inspect()
  end

  -- wait for new oak sapling
  while not sb.inv_has(sb.ITEMS.OAK_SAPLING) do end

  -- chop down tree
  -- up to 8 log blocks
  sb.move(0, 0, 1)
  _, inspect = turtle.inspectUp()
  while inspect.name == "minecraft:oak_log" do
    sb.move(0, 1, 0)
    _, inspect = turtle.inspectUp()
  end

  -- grab remaining dirt block
  sb.move_to_ele(0, -1, 0)
end

-- displays the start message
function sb.phases.start()
  print("*** Time to beat Stoneblock 3 lol ***")

  print("Phase: start")
end

-- collects 8 andesite and some cobblestone along the way
function sb.phases.initial_andesite()
  print("Phase: initial_andesite")

  -- get some cobble and andesite
  sb.move(0, -60, 0)

  -- collect andesite
  while sb.inv_count(sb.ITEMS.ANDESITE) < 8 do
    sb.move(0, 0, 1)
  end

  sb.move_origin()
end

-- crafts a stone chest
function sb.phases.initial_chest()
  print("Phase: initial_chest")

  -- dig out independant crafting area
  sb.move_to_ele(0, -3, 2)

  turtle.dig()
  turtle.digUp()

  sb.craft_stone_chest()

  sb.move_to_ele(0, -1, 0)
  turtle.dig()
  sb.inv_select(sb.ITEMS.COBBLESTONE_CHEST)
  turtle.place()

  sb.move_origin()
end

-- crafts a stone crook and hammer
function sb.phases.stone_crook_hammer()
  print("Phase: stone_crook_hammer")

  -- crafting a stone crook and hammer
  sb.craft_basic(sb.RECIPES.STONE_ROD)   -- x2
  sb.suck()
  sb.craft_basic(sb.RECIPES.STONE_ROD)   -- x2
  sb.suck()
  sb.craft_basic(sb.RECIPES.STONE_ROD)   -- x2
  sb.suck()
  sb.craft_basic(sb.RECIPES.STONE_ROD)   -- x2
  sb.suck()
  sb.craft_basic(sb.RECIPES.STONE_CROOK) -- x1
  sb.suck()
  sb.craft_basic(sb.RECIPES.STONE_HAMMER) -- x1
  sb.suck()
end

-- obtains an oak sapling
function sb.phases.oak_sapling()
  print("Phase: oak_sapling")

  sb.move_to_ele(0, -1, 0)
  sb.inv_select(sb.ITEMS.STONE_HAMMER)
  turtle.drop()
  sb.inv_select(sb.ITEMS.STONE_CROOK)
  turtle.drop()

  sb.move_to_ele(0, -2, 0)

  -- oak sapling has a 50% chance of dropping
  -- run until that chance succeeds
  while not sb.inv_has(sb.ITEMS.OAK_SAPLING) do
    -- place cobble to become gravel
    sb.inv_select(sb.ITEMS.COBBLESTONE)
    turtle.placeUp()

    turtle.select(1)
    while not turtle.suckUp() do end
    while turtle.suckUp() do end

    -- place gravel to become dirt
    sb.inv_select(sb.ITEMS.GRAVEL)
    turtle.placeUp()

    turtle.select(1)
    while not turtle.suckUp() do end
    while turtle.suckUp() do end

    -- place dirt to be crooked
    sb.inv_select(sb.ITEMS.DIRT)
    turtle.placeUp()

    turtle.select(1)
    while not turtle.suckUp() do end
    while turtle.suckUp() do end
  end

  -- get dirt to plant sapling on

  -- place cobble to become gravel
  sb.inv_select(sb.ITEMS.COBBLESTONE)
  turtle.placeUp()

  turtle.select(1)
  while not turtle.suckUp() do end
  while turtle.suckUp() do end

  -- place gravel to become dirt
  sb.inv_select(sb.ITEMS.GRAVEL)
  turtle.placeUp()

  turtle.select(1)
  while not turtle.suckUp() do end
  while turtle.suckUp() do end
end

-- creates two chests to filter with
function sb.phases.filter_setup()
  print("Phase: filter_setup")

  sb.craft_basic(sb.RECIPES.COBBLESTONE_PART)
  sb.suck()
  sb.craft_basic(sb.RECIPES.COBBLESTONE_PART)
  sb.suck()
  sb.craft_basic(sb.RECIPES.COBBLESTONE_PART)
  sb.suck()
  sb.craft_basic(sb.RECIPES.COBBLESTONE_PART)
  sb.suck()
  sb.craft_basic(sb.RECIPES.COBBLESTONE_PART)
  sb.suck()
  sb.craft_basic(sb.RECIPES.COBBLESTONE_PART)
  sb.suck()
  sb.craft_basic(sb.RECIPES.COBBLESTONE_PART)
  sb.suck()
  sb.craft_basic(sb.RECIPES.COBBLESTONE_PART)
  sb.suck()
  sb.craft_basic(sb.RECIPES.COBBLESTONE_CHEST)
  sb.suck()
  sb.craft_basic(sb.RECIPES.COBBLESTONE_CHEST)
  sb.suck()

  sb.move_to_ele(1, -1, 0)
  turtle.dig()
  turtle.digDown()
  sb.inv_select(sb.ITEMS.COBBLESTONE_CHEST)
  turtle.place()
  sb.inv_select(sb.ITEMS.COBBLESTONE_CHEST)
  turtle.placeDown()

  sb.inv_clear()
end

-- harvests the first trees
function sb.phases.first_trees()
  -- harvest 4 trees for a minimum of 16 oak logs
  sb.harvest_tree()
  sb.harvest_tree()
  sb.harvest_tree()
  sb.harvest_tree()
end

-- crafts and sets up a millstone
function sb.phases.millstone_setup()
  -- -8 andesite
  -- +8 polished andesite
  sb.craft(sb.RECIPES.POLISHED_ANDESITE)
  sb.craft(sb.RECIPES.POLISHED_ANDESITE)

  -- -5 logs
  -- +20 oak planks
  sb.craft(sb.RECIPES.OAK_PLANKS)
  sb.craft(sb.RECIPES.OAK_PLANKS)
  sb.craft(sb.RECIPES.OAK_PLANKS)
  sb.craft(sb.RECIPES.OAK_PLANKS)
  sb.craft(sb.RECIPES.OAK_PLANKS)

  -- -16 oak planks
  -- +16 oak buttons
  sb.craft(sb.RECIPES.OAK_BUTTON)
  sb.craft(sb.RECIPES.OAK_BUTTON)
  sb.craft(sb.RECIPES.OAK_BUTTON)
  sb.craft(sb.RECIPES.OAK_BUTTON)
  sb.craft(sb.RECIPES.OAK_BUTTON)
  sb.craft(sb.RECIPES.OAK_BUTTON)
  sb.craft(sb.RECIPES.OAK_BUTTON)
  sb.craft(sb.RECIPES.OAK_BUTTON)
  sb.craft(sb.RECIPES.OAK_BUTTON)
  sb.craft(sb.RECIPES.OAK_BUTTON)
  sb.craft(sb.RECIPES.OAK_BUTTON)
  sb.craft(sb.RECIPES.OAK_BUTTON)
  sb.craft(sb.RECIPES.OAK_BUTTON)
  sb.craft(sb.RECIPES.OAK_BUTTON)
  sb.craft(sb.RECIPES.OAK_BUTTON)
  sb.craft(sb.RECIPES.OAK_BUTTON)

  -- -16 oak buttons
  -- -2 polished andesite
  -- +2 cogwheel
  sb.craft(sb.RECIPES.COGWHEEL)
  sb.craft(sb.RECIPES.COGWHEEL)

  -- -1 stone rod
  -- -3 oak planks
  -- -1 polished andesite
  sb.craft(sb.RECIPES.HAND_CRANK)

  -- -1 oak planks
  -- -1 cogwheel
  -- -3 polished andesite
  sb.craft(sb.RECIPES.MILLSTONE)

  -- place milling setup
  sb.find_keep({
    [sb.ITEMS.MILLSTONE] = 1,
    [sb.ITEMS.COGWHEEL] = 1,
    [sb.ITEMS.HAND_CRANK] = 1,
  })
  sb.move_to_ele(2, 0, 0)

  -- place cogwheel
  sb.move(0, 0, 2)
  turtle.select(1)
  turtle.digDown()
  sb.inv_select(sb.ITEMS.COGWHEEL)
  turtle.placeDown()

  -- place hand crank
  sb.move(0, 0, -1)
  sb.inv_select(sb.ITEMS.HAND_CRANK)
  turtle.place()

  -- place millstone
  turtle.select(1)
  turtle.digDown()
  sb.inv_select(sb.ITEMS.MILLSTONE)
  turtle.placeDown()

  sb.move_origin()
end

function sb.phases.first_iron()
  sb.find_keep({
    [sb.ITEMS.COBBLESTONE] = 64,
  })

  sb.move_to_ele(2, -1, 0)

  sb.inv_select(sb.ITEMS.COBBLESTONE)
  turtle.placeUp()

  turtle.select(1)
  local suck_up = turtle.suckUp()

  -- mill gravel until raw iron is obtained
  while sb.inv_count(sb.ITEMS.RAW_IRON) < 10 do
    while not suck_up do suck_up = turtle.suckUp() end
    while suck_up do suck_up = turtle.suckUp() end

    -- place cobble to become gravel
    -- sb.move_to_ele(0, -2, 0)

    sb.inv_select(sb.ITEMS.GRAVEL)
    turtle.drop()

    sb.inv_select(sb.ITEMS.COBBLESTONE)
    turtle.placeUp()

    turtle.select(1)
    local suck_forward = turtle.suck()
    while not suck_forward and not suck_up do
      suck_forward = turtle.suck()
      suck_up = turtle.suckUp()
    end
    while suck_forward do suck_forward = turtle.suck() end
  end

  turtle.digUp()
  sb.move_origin()
end

-- next phase
function sb.phases.test_phase()
  print("*** OBTAIN IRON ***")

end

term.clear()
term.setCursorPos(1, 1)

-- sb.phases.start()
-- sb.phases.initial_andesite()
-- sb.phases.initial_chest()
-- sb.phases.stone_crook_hammer()
-- sb.phases.oak_sapling()
-- sb.phases.filter_setup()
-- sb.phases.first_trees()
-- sb.phases.millstone_setup()
-- sb.phases.first_iron()

local status, err = pcall(sb.phases.test_phase)
if not status then
  print("ERROR: " .. err)
end

-- RETURN TO ORIGIN!!!
sb.move_origin()
