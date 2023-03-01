local ROOTNAME = "root"

local path = select(1, ...):match("(.-)[^%.]+$")
local util = require(path .. "util")

local moonblob = require(path .. "libs.moonblob")

local insert = table.insert

local node = { }
node.__index = node

node.new = function(data)
  local newNode = setmetatable({
      children = { },
      data = data,
    }, node)

  local errorString = util.validate.validateString(data, "AlphanumericAndPuncuation")
  if errorString ~= nil then
    return nil, errorString
  end

  return newNode
end

local scenegraph = { }
scenegraph.__index = scenegraph

scenegraph.new = function(root)
  return setmetatable({
      root = root or node.new(ROOTNAME),
    }, scenegraph)
end

local nodeRecursionToData
nodeRecursionToData = function(node)
  local tbl = { 
      data = node.data
    }
  for i, child in ipairs(node.children) do
    tbl[i] = nodeRecursionToData(child)
  end
  return tbl
end

scenegraph.toData = function(self)
  local blob = moonblob.writer("le")
  blob:table(nodeRecursionToData(self.root))
  return blob:tobytedata()
end

local nodeRecursionFromData
nodeRecursionFromData = function(tbl)
  local newNode = node.new(tbl.data)
  for _, child in ipairs(tbl) do
    insert(newNode.children, nodeRecursionFromData(child))
  end
  return newNode
end

scenegraph.fromData = function(data)
  local blob = moonblob.reader(data:getPointer(), "le", data:getSize())
  return scenegraph.new(nodeRecursionFromData(blob:table()))
end

return scenegraph