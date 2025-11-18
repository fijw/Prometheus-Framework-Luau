--[[
    @Banner
    ```
        ▀▀▀    ▀▀▀    ▀▀▀    ▀▀▀    ▀▀▀    ▀▀▀    ▀▀▀    ▀▀▀    ▀▀▀    ▀▀▀  
                                                                            
                                                                            
                                                                            
                                                                            
        █           ▄    ▄          ▀                                  █   
        █           █  ▄▀   ▄▄▄   ▄▄▄     ▄ ▄▄   ▄▄▄    ▄▄▄            █   
        █           █▄█    ▀   █    █     █▀  ▀ █▀ ▀█  █   ▀           █   
        █           █  █▄  ▄▀▀▀█    █     █     █   █   ▀▀▀▄           █   
        █           █   ▀▄ ▀▄▄▀█  ▄▄█▄▄   █     ▀█▄█▀  ▀▄▄▄▀           █   
        █                                                              █   
                                                                            
                                                                            
                                                                            
                                                                            
                                                                            
        ▀▀▀    ▀▀▀    ▀▀▀    ▀▀▀    ▀▀▀    ▀▀▀    ▀▀▀    ▀▀▀    ▀▀▀    ▀▀▀  

        @Author Kairos (Roblox @: roblox_user_5618502527)
        @Version 1.0.9
    ```

    @Description Registry is a data management library for Roblox.

    @Description This library depends on another external library called
    @Description "ProfileStore" for clean, efficient, and secure data
    @Description storage.

    @Example
    ```luau
        local Record = Registry(player)
        if not Record then return end
        
        Record:toClassifyFormat()

        print(Record, "RECORD (CLASSIFIED DATA)")

        -- Increment the player's coins.
        do
            print(Record.coins(), "COINS BEFORE INCREMENT")

            local NewQuantity = Record.coins() + 155
            Record.coins(NewQuantity)

            print(Record.coins(), "COINS AFTER INCREMENT")
        end

        Record:toSavableFormat()

        print(Record, "RECORD (SAVABLE DATA)")
    ```
]]
--!strict
--!optimize 2


--[[ @section Imports ]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local DataTypes = require(ReplicatedStorage.SharedSchemas.Types.DataTypes)
local FrameworkSettings = require(ReplicatedStorage.SharedSchemas.FrameworkSettings)

local Classify = require(ServerScriptService.ServerLibs.UtilityLibs.Classify)

local ProfileStore = require(script.ProfileStore)
local DataCompression = require(script.DataCompression)
--[[ @end_section Imports ]]


--[[ @section Types ]]
type ProfileType<T> = ProfileStore.Profile<T>
type Class<T> = Classify.Class<T>


type ItemSchema = DataTypes.ItemSchema


type RecordSchema
= {
    CommandsData
    : {
        _reservedCode: (Class<string> | buffer)?,

        _banned: Class<boolean> | buffer,
        _kicked: Class<boolean> | buffer,

        _banReason: (Class<string> | buffer)?,
        _kickReason: (Class<string> | buffer)?,

        _dataWiped: Class<boolean> | buffer,
    },

    SchemaData
    : {
        rebirths: Class<number> | buffer,

        Materials: Class<{ string }> | buffer,
        Items: Class<{ ItemSchema }> | buffer,

        coins: Class<number> | buffer,
    },

    RecordData
    : {
        Purchases
        : {
            Gamepasses: Class<{ number }> | buffer,
            DeveloperProducts: Class<{ number }> | buffer
        } | buffer,

        status: string | buffer
    }
}

type RecordInheritanceSchema
= {
    toSavableFormat: (self: RecordType) -> (),
    toClassifyFormat: (self: RecordType) -> (),

    wipe: (self: RecordType) -> ()
}

export type RecordType = setmetatable
<
    RecordSchema
    & {
        CommandsData
        : {
            _reservedCode: Class<string>?,

            _banned: Class<boolean>,
            _kicked: Class<boolean>,

            _banReason: Class<string>?,
            _kickReason: Class<string>?,

            _dataWiped: Class<boolean>,
        },

        SchemaData
        : {
            rebirths: Class<number>,

            Materials: Class<{ string }>,
            Items: Class<{ ItemSchema }>,

            coins: Class<number>,
        },

        RecordData
        : {
            Purchases
            : {
                Gamepasses: Class<{ number }>,
                DeveloperProducts: Class<{ number }>
            },

            status: string
        }
    },

    { __index: RecordInheritanceSchema }
>
--[[ @end_section Types ]]


--[[ @section Variables ]]
local StoredRecords: { [number]: ProfileType<RecordType> } = {}


local ConstructorSchema = {}
local RecordInheritanceSchema = {} :: RecordInheritanceSchema

local Registry = {}


local PLAYER_DATA_TEMPLATE
= {
    CommandsData
    = {
        _banned = DataCompression(false),
        _kicked = DataCompression(false),

        _dataWiped = DataCompression(false),
    },

    SchemaData
    = {
        rebirths = DataCompression(0),

        Materials = DataCompression({}),
        Items = DataCompression({}),

        coins = DataCompression(0),
    },

    RecordData
    = {
        Purchases
        = DataCompression(
            {
                Gamepasses = DataCompression({}),
                DeveloperProducts = DataCompression({})
            }
        ),

        status = DataCompression(0)
    }
} :: RecordSchema

local PROFILES_STORAGE = ProfileStore.New(`Registry Profiles [tag: {FrameworkSettings.registryProfileStorageTag}]`, PLAYER_DATA_TEMPLATE :: any)
--[[ @end_section Variables ]]


--[[
    @usage Removes a players cached record from the registry.

    @param player Player
    
    @return
]]
function Registry.removeCache(player: Player)
    local StoredRecord = StoredRecords[player.UserId]
    if not StoredRecord then return end

    StoredRecords[player.UserId] = nil

    StoredRecord:EndSession()
end


--[[ @section Registry Constructor ]]
--[[
    @usage Creates a new record for a player.

    @param player Player | number

    @return RecordType?
]]
function ConstructorSchema:__call(player: Player | number): RecordType?
    if not ServerScriptService.ServerComponents.Interactive:FindFirstChild("Pragma") then return nil end

    local id = typeof(player) == "number" and player or player.UserId

    local Record = StoredRecords[id]
    if Record then return Record.Data end

    Record = PROFILES_STORAGE:StartSessionAsync(`{id}`, {})   
    if not Record then return nil end
    
    Record:Reconcile()
	Record:AddUserId(id)

    setmetatable(Record.Data, { __index = RecordInheritanceSchema })

    StoredRecords[id] = Record :: ProfileType<RecordType>?

    return Record.Data :: RecordType
end

setmetatable(Registry, { __call = ConstructorSchema.__call })
--[[ @end_section Registry Constructor ]]


--[[ @section Record Transformations ]]
--[[
    @usage Transforms a record to a savable format.

    @param self RecordType

    @return
]]
function RecordInheritanceSchema:toSavableFormat()
    if typeof(self.RecordData.status) ~= "number" then return end

    -- Declassify all values.
    do
        for i: string, v: Class<any> in pairs(self.CommandsData :: { [string]: Class<any> }) do
            self.CommandsData[i] = (v :: Class<any>)()
        end

        for i: string, v: Class<any> in pairs(self.SchemaData :: { [string]: Class<any> }) do
            self.SchemaData[i] = (v :: Class<any>)()
        end

        for i: string, v: Class<any> in pairs(self.RecordData.Purchases) do
            self.RecordData.Purchases[i] = (v :: Class<any>)()
        end
    end

    -- Compress all values.
    do
        for i: string, v: any in pairs(self.CommandsData :: { [string]: any }) do
            self.CommandsData[i] = DataCompression(v)
        end

        for i: string, v: any in pairs(self.SchemaData :: { [string]: any }) do
            self.SchemaData[i] = DataCompression(v)
        end

        for i: string, v: any in pairs(self.RecordData.Purchases) do
            self.RecordData.Purchases[i] = DataCompression(v)
        end

        for i: string, v: any in pairs(self.RecordData :: { [string]: any }) do
            self.RecordData[i] = DataCompression(v)
        end
    end
end

--[[
    @usage Transforms a record to a classify format.

    @param self RecordType

    @return
]]
function RecordInheritanceSchema:toClassifyFormat()
    if typeof(self.RecordData.status) ~= "buffer" then return end

    -- Decompress all values.
    do
        for i: string, v: buffer in pairs(self.CommandsData :: { [string]: buffer }) do
            self.CommandsData[i] = DataCompression(v, "decompress")
        end

        for i: string, v: buffer in pairs(self.SchemaData :: { [string]: buffer }) do
            (self.SchemaData :: { [string]: buffer })[i] = DataCompression(v, "decompress")
        end

        for i: string, v: buffer in pairs(self.RecordData :: { [string]: buffer }) do
            (self.RecordData :: { [string]: buffer })[i] = DataCompression(v, "decompress")
        end

        for i: string, v: buffer in pairs(self.RecordData.Purchases :: { [string]: buffer }) do
            (self.RecordData.Purchases :: { [string]: buffer })[i] = DataCompression(v, "decompress")
        end
    end

    -- Classify all values.
    do
        for i: string, v: any in pairs(self.CommandsData :: { [string]: any }) do
            self.CommandsData[i] = Classify(v)
        end

        for i: string, v: any in pairs(self.SchemaData :: { [string]: any }) do
            (self.SchemaData :: { [string]: any })[i] = Classify(v)
        end

        for i: string, v: any in pairs(self.RecordData.Purchases :: { [string]: any }) do
            (self.RecordData.Purchases :: { [string]: any })[i] = Classify(v)
        end
    end
end
--[[ @end_section Record Transformations ]]


--[[
    @usage Wipes the record.

    @param self RecordType

    @return
]]
function RecordInheritanceSchema:wipe()
    -- Decompress all values.
    for i: string, v: buffer in pairs(self.SchemaData :: { [string]: buffer }) do
        local templateValue = (PLAYER_DATA_TEMPLATE :: any)[i]
        if not templateValue then continue end

        (self.SchemaData :: { [string]: buffer })[i] = DataCompression(templateValue, "decompress")
    end

    -- Classify all values.
    for i: string, v: any in pairs(self.SchemaData :: { [string]: any }) do
        (self.SchemaData :: { [string]: any })[i] = Classify(v)
    end
end


table.freeze(Registry)
return Registry