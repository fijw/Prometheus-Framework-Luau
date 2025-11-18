--!strict
--!optimize 2


local HttpService = game:GetService("HttpService")


--[[ @section Variables ]]
local DataCompressionConstructor = {}

local DataCompression = {}
--[[ @end_section Variables ]]


--[[ @section Buffer Functions ]]
--[[
    @usage Convert string to buffer.

    @param str string
    
    @return buffer
]]
local function stringToBuffer(str: string): buffer
    local buf = buffer.create(#str)

    for i = 1, #str do
        local byte = string.byte(str, i)
        buffer.writeu8(buf, i - 1, byte)
    end

    return buf
end

--[[
    @usage Convert buffer to string.

    @param buf buffer

    @return string
]]
local function bufferToString(buf: buffer): string
    local size = buffer.len(buf)
    local OutputTable = table.create(size)

    for i = 0, size - 1 do
        local bufChar = buffer.readu8(buf, i)
        OutputTable[i + 1] = string.char(bufChar)
    end

    local concat = table.concat(OutputTable)
    return concat
end
--[[ @end_section Buffer Functions ]]


--[[ @section Compression Constructor ]]
--[[
    @usage Compress / Decompress data. If compressionMode is true,
    @usage data will be decompressed.

    @param data any | buffer
    @param compressionMode "decompress"?

    @return any | buffer
]]
function DataCompressionConstructor:__call(data: any | buffer, compressionMode: "decompress"?): any | buffer
    if not compressionMode or compressionMode ~= "decompress" then
        local TemporaryWrappedTable = {} :: { any }
        local EncodedData: string

        -- If data is a table, wrap it in a table
        if typeof(data) == "table" then
            for i: unknown, v: unknown in pairs(data :: { [any]: any }) do
                local WrappedValues = { i, v }
                table.insert(TemporaryWrappedTable, WrappedValues)
            end

            EncodedData = HttpService:JSONEncode(TemporaryWrappedTable)
        else EncodedData = HttpService:JSONEncode(data) end

        local strToBuffer = stringToBuffer(EncodedData)
        return strToBuffer
    else
        local bufToString = bufferToString(data)
        local DecodedData = HttpService:JSONDecode(bufToString)

        -- If decoded data is a table, unwrap it
        if typeof(DecodedData) == "table" then
            local UnwrappedTable = {}

            for i: unknown, v: unknown in pairs(DecodedData :: { any }) do
                local key, value = v[1], v[2]
                UnwrappedTable[key] = value
            end

            return UnwrappedTable
        end

        return DecodedData
    end
end

setmetatable(DataCompression, { __call = DataCompressionConstructor.__call })
--[[ @end_section Compression Constructor ]]


table.freeze(DataCompression)
return DataCompression