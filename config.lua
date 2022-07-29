Config = {}
Config.MenuImg = "https://i.imgur.com/lfjibrs.png"

Config.Craft = {
    [1] = {
        config = {
            job = 'ambulance', -- Job NAME or false
            coords = vector3(2387.61, -1362.98, 46.55),
            blip = {
                active = true,
                name = 'EMS Craft',
                hash = 'blip_ambient_lower',
            },
            ped = {
                active = true,
                coords = vector3(2387.61, -1362.98, 46.55 -1), -- ADD -1 to Z for good spawn
                heading = 179.54,
                model = 'CS_SDDoctor_01'
            },
        },
        CraftItems = {
            [1] = {
                info = {                          
                    craftedItem = "firstaid", -- Item to craft
                    count = 1, -- Number of item
                    time = 1000, -- 1000 = 1sec
                    reqcraftingrep = 10,
                    addcraftingrep = 1,
                    Recipe = { 
                        [1] = {reqitem = "bandage", count = 1},
                        [2] = {reqitem = "painkillers", count = 1}
                    }
                }
            },
            [2] = {
                info = {                          
                    craftedItem = "painkillers", -- Item to craft
                    count = 5, -- Number of item
                    time = 1000, -- 1000 = 1sec
                    reqcraftingrep = 0,
                    addcraftingrep = 1,
                    Recipe = { 
                        [1] = {reqitem = "blueberry", count = 1},
                        [2] = {reqitem = "water_bottle", count = 1}
                    }
                }
            },
        },
    },
    [2] = {
        config = {
            job = false, -- Job NAME or false
            coords = vector3(2384.73, -1371.62, 46.55),
            blip = {
                active = true,
                name = 'Test craft public',
                hash = 'blip_ambient_lower',
            },
            ped = {
                active = true,
                coords = vector3(2384.73, -1371.62, 46.55 -1), -- ADD -1 to Z for good spawn
                heading = 332.06,
                model = 'A_F_M_SDFancyWhore_01'
            },
        },
        CraftItems = {
            [1] = {
                info = {                          
                    craftedItem = "sandwich", -- Item to craft
                    count = 2, -- Number of item
                    time = 1000, -- 1000 = 1sec
                    reqcraftingrep = 0,
                    addcraftingrep = 1,
                    Recipe = { 
                        [1] = {reqitem = "bread", count = 1},
                        [2] = {reqitem = "game", count = 1}
                    }
                }
            },
            [2] = {
                info = {                          
                    craftedItem = "cigar", -- Item to craft
                    count = 1, -- Number of item
                    time = 1000, -- 1000 = 1sec
                    reqcraftingrep = 0,
                    addcraftingrep = 1,
                    Recipe = { 
                        [1] = {reqitem = "cigarette", count = 3},
                    }
                }
            },
        },
    },
}

