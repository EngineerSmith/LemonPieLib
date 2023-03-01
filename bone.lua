local path = select(1, ...):match("(.-)[^%.]+$")
local util = require(path .. "util")

local moonblob = require(path .. "libs.moonblob")

local bone = { }
bone.__index = bone

bone.new = function(name, startPointX, startPointY, endPointX, endPointY)
  local newBone = setmetatable({
      name = name,
      startPointX = startPointX,
      startPointY = startPointY,
      endPointX = endPointX,
      endPointY = endPointY,
    }, bone)
  -- Validation
    -- Name
  local errorString = util.validate.validateString(name, "AlphanumericAndPuncuation")
  if errorString ~= nil then
    return nil, errorString
  end
    --StartPoint
  local errorString = util.validate.NumberBetween(startPointX, 0, 1)
  if errorString ~= nil then
    return nil, errorString
  end
  local errorString = util.validate.NumberBetween(startPointY, 0, 1)
  if errorString ~= nil then
    return nil, errorString
  end
    --EndPoint
  local errorString = util.validate.NumberBetween(endPointX, 0, 1)
  if errorString ~= nil then
    return nil, errorString
  end
  local errorString = util.validate.NumberBetween(endPointY, 0, 1)
  if errorString ~= nil then
    return nil, errorString
  end
  return newBone
end

bone.toData = function(self) -- improvement, write directly to data; moonblob will need to change for this
  local nameLength = #self.name
  local blob = moonblob.writer("le", nameLength + 4*4)
  blob:string(self.name, nameLength)
  blob:f32(self.startPointX) 
  blob:f32(self.startPointY)
  blob:f32(self.endPointX)
  blob:f32(self.endPointY) -- update constructor if adding new enteries [parmeter, size]
  return blob:tobytedata()
end

bone.fromData = function(data)
  local blob = moonblob.reader(data:getPointer(), "le", data:getSize())
  return bone.new(
      blob:string(),
      blob:f32(),
      blob:f32(),
      blob:f32(),
      blob:f32()
    )
end

return bone