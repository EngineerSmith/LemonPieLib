local util = { }

util.validate = { 
    ["Alphanumeric And Puncuation"] = "[^%w%p]+",
    ["Alphanumeric"] = "[^%w]+",
    ["Digits"] = "[^%d]+",
  }

util.validate.validateString =  function(str, option)
  if type(str) ~= "string" then return "Given value for string is not string" end
  if str == "" then return "String is empty" end

  option = option or "AlphanumericAndPuncuation"

  local i, j = string.find(str, util.validate[option] or option)
  if i == nil then return nil end
  return "Given string is not valid. ["..tostring(str).."] which only accepts ["..tostring(option).."] option\n\tThe issue is found between positions [ "..tostring(i)..", "..tostring(j).."] which is ["..string.sub(tostring(str), i, j).."]", option
end

util.validate.NumberBetween = function(num, lower, upper)
  lower = lower or 0
  upper = upper or 1
  if num < lower then
    return "Given number is not valid. ["..tostring(num).."] which is lower than ["..tostring(lower).."]", "lower"
  end
  if num > upper then
    return "Given number is not valud. ["..tostring(num).."] which is higher than ["..tostring(upper).."]", "upper"
  end
  return nil
end

return util