-- Lua Library inline imports

local string = string
local table = table

function Tbl(t)
  setmetatable(t, { __index = table })
  return t
end

function Str(s)
  setmetatable(s, { __index = string })
  return s
end

function string.toTable(str)
  local tbl = {}

  for i = 1, string.len(str) do
    tbl[i] = string.sub(str, i, i)
  end

  return tbl
end

local pattern_escape_replacements = {
  ["("] = "%(",
  [")"] = "%)",
  ["."] = "%.",
  ["%"] = "%%",
  ["+"] = "%+",
  ["-"] = "%-",
  ["*"] = "%*",
  ["?"] = "%?",
  ["["] = "%[",
  ["]"] = "%]",
  ["^"] = "%^",
  ["$"] = "%$",
  ["\0"] = "%z"
}

function string.patternSafe(str)
  return (str:gsub(".", pattern_escape_replacements))
end

local totable = string.toTable
local string_sub = string.sub
local string_find = string.find
local string_len = string.len

function string.explode(separator, str, withpattern)
  if (separator == "") then return totable(str) end
  if (withpattern == nil) then withpattern = false end

  local ret = {}
  local current_pos = 1

  for i = 1, string_len(str) do
    local start_pos, end_pos = string_find(str, separator, current_pos, not withpattern)
    if (not start_pos) then break end
    ret[i] = string_sub(str, current_pos, start_pos - 1)
    current_pos = end_pos + 1
  end

  ret[#ret + 1] = string_sub(str, current_pos)

  return ret
end

function string:split(delimiter)
  local ret = string.explode(delimiter, self)
  return Tbl(ret)
end

function string:replace(tofind, toreplace)
  local ret = self
  local tbl = string.explode(tofind, self)
  if (tbl[1]) then
    ret = table.concat(tbl, toreplace)
    return Str(ret)
  end

  return Str(ret)
end

function string:trim(char)
  if (char) then
    char = char:patternSafe()
  else
    char = "%s"
  end
  return string.match(self, "^" .. char .. "*(.-)" .. char .. "*$") or self
end

function string:includes(str)
  local start_pos, _ = string_find(self, str)
  if not start_pos then
    return false
  else
    return true
  end
end

function table.forceInsert(t, v)
  if (t == nil) then t = {} end
  table.insert(t, v)
  return t
end

function table:forEach(funcname)
  for k, v in pairs(self) do
    funcname(k, v)
  end
end

function table:push(v)
  local t = table.forceInsert(self, v)
  return t
end

function table:pop()
  if #self >= 1 then
    table.remove(self, #self)
  end
  return self
end

function table:join(separator)
  local str = ""
  for i, v in pairs(self) do
    if i < #self then
      str = str .. v .. separator
    else
      str = str .. v
    end
  end

  return Str(str)
end

function table:entriesMap(funcname)
  for k, v in pairs(self) do
    funcname(k, v)
  end
end

local function stringAccess(self, index)
  if index >= 0 and index < #self then
    return string.sub(self, index + 1, index + 1)
  end
end

local function objectEntries(obj)
  local result = {}
  local len = 0
  for key in pairs(obj) do
    len = len + 1
    result[len] = {key, obj[key]}
  end
  return Tbl(result)
end

local function objectKeys(obj)
  local result = {}
  local len = 0
  for key in pairs(obj) do
    len = len + 1
    result[len] = key
  end
  return result
end

local function arrayIsArray(value)
  return type(value) == "table" and (value[1] ~= nil or next(value) == nil)
end

local function arraySpread(sparseArray)
  local __unpack = unpack
  if __unpack == nil then
    __unpack = table.unpack
  end
  local _unpack = __unpack
  return _unpack(sparseArray, 1, sparseArray.sparseLength)
end

-- End of Lua Library inline imports

local function ampCount(selector)
  local cnt = 0
  do
    local i = 0
    while i < #selector do
      if stringAccess(selector, i) == "&" then
        cnt = cnt + 1
      end
      i = i + 1
    end
  end
  return cnt
end

-- Don't just use ',' to separate css selector. For example:
-- x:(a, b) {} will be split into 'x:(a' and 'b)', which is not expected.
-- Make sure comma doesn't exist inside parentheses.
-- var separatorRegex = /\s*,(?![^(]*\))\s*/g;
-- var extraSpaceRegex = /\s+/g;

-- selector must includes '&'
-- selector is trimmed
-- every part of amp is trimmed
local function resolveSelectorWithAmp(amp, selector)
  local nextAmp = Tbl({})

  selector = string.gsub(selector, "%s*,%s*", ",")
  selector:split(","):forEach(function(_, partialSelector)

    partialSelector = Str(partialSelector)
    local round = ampCount(partialSelector)
    if not round then
      amp:forEach(function(_, partialAmp)
        nextAmp:push((partialAmp and partialAmp .. " ") .. partialSelector)
      end)
      return
    elseif round == 1 then
      amp:forEach(function(_, partialAmp)
        nextAmp:push(partialSelector:replace("&", partialAmp))
      end)
      return
    end
    local partialNextAmp = Tbl({partialSelector})
    while true do
      local __round = round
      round = __round - 1
      if __round <= 0 then
        break
      end
      local nextPartialNextAmp = Tbl({})
      partialNextAmp:forEach(function(_, selectorItr)
        amp:forEach(function(_, partialAmp)
          nextPartialNextAmp:push(Str(selectorItr):replace("&", partialAmp))
        end)
      end)
      partialNextAmp = nextPartialNextAmp
    end
    partialNextAmp:forEach(function(_, part) return nextAmp:push(part) end)
  end)
  return nextAmp
end
-- selector mustn't includes '&'
-- selector is trimmed

local function resolveSelector(amp, selector)
  local nextAmp = Tbl({})

  selector = string.gsub(selector, "%s*,%s*", ",")
  selector:split(","):forEach(function(_, partialSelector)
    amp:forEach(function(_, partialAmp)
      nextAmp:push((partialAmp ~= "" and partialAmp .. " " or "") .. partialSelector)
    end)
  end)
  return nextAmp
end

local function parseSelectorPath(selectorPaths)
  local amp = Tbl({""})
  selectorPaths:forEach(function(_, selector)
    selector = Str(selector)
    selector = selector and selector:trim()
    if not selector then
      -- if it's a empty selector, do nothing
      return
    end
    if selector:includes("&") then
      amp = resolveSelectorWithAmp(amp, selector)
    else
      amp = resolveSelector(amp, selector)
    end
  end)

  ampStr = amp:join(", ")
  ampStr = string.gsub(ampStr, "%s+", " ")
  return ampStr
end

local function isMediaOrSupports(selector)
  if not selector then
    return false
  end
  local ret = string.match(selector, "^%s*@(m)") or string.match(selector, "^%s*@(s)")
  if ret ~= nil then
    return true
  else
    return false
  end
end

local function kebabCase(pattern)
  patternTbl = string.toTable(pattern)
  pattern = ""
  for _, pat in pairs(patternTbl) do
    local ret = string.match(pat, "%u")
    if ret ~= nil then
      pattern = pattern .. "-" .. string.lower(pat)
    else
      pattern = pattern .. pat
    end
  end
  return pattern
end

local function unwrapProperty(prop, indent)
  if indent == nil then
    indent = "  "
  end
  if type(prop) == "table" and prop ~= nil then
    return " {\n" .. objectEntries(prop):entriesMap(function(_, v)
      return indent .. "  " .. kebabCase(v[1]) .. ": " .. tostring(v[2]) .. ";"
    end):join("\n") .. "\n" .. indent .. "}"
  end
  return ": " .. tostring(prop) .. ";"
end

--- unwrap properties
local function unwrapProperties(props, instance, params)
  if type(props) == "function" then
    return props(nil, {context = instance.context, props = params})
  end
  return props
end

local function createStyle(selector, props, instance, params)
  if not props then
    return ""
  end
  local unwrappedProps = unwrapProperties(props, instance, params)
  if not unwrappedProps then
    return ""
  end
  if type(unwrappedProps) == "string" then
    return (selector .. " {\n") .. unwrappedProps .. "\n}"
  end
  local propertyNames = Tbl(objectKeys(unwrappedProps))
  if #propertyNames == 0 then
    if instance.config.keepEmptyBlock then
      return selector .. " {\n}"
    end
    return ""
  end
  local statements = selector and {selector .. " {"} or {}
  statements = Tbl(statements)
  propertyNames:forEach(function(_, propertyName)
    local property = unwrappedProps[propertyName]
    if propertyName == "raw" then
      statements:push("\n" .. tostring(property) .. "\n")
      return
    end
    propertyName = kebabCase(propertyName)
    if property ~= nil and property ~= nil then
      statements:push("  " .. propertyName .. unwrapProperty(property))
    end
  end)

  if selector then
    statements:push("}")
  end

  return statements:join("\n")
end

local function loopCNodeListWithCallback(children, options, callback)
  children = Tbl(children)
  if not children then
    return
  end
  children:forEach(function(_, child)
    if arrayIsArray(child) then
      loopCNodeListWithCallback(child, options, callback)
    elseif type(child) == "function" then
      local grandChildren = child(nil, options)
      if arrayIsArray(grandChildren) then
        loopCNodeListWithCallback(grandChildren, options, callback)
      elseif grandChildren then
        callback(nil, grandChildren)
      end
    elseif child then
      callback(nil, child)
    end
  end)
end

local function traverseCNode(node, selectorPaths, styles, instance, params, styleSheet)
  local cash = node["$"]
  local blockSelector = nil

  if not cash or type(cash) == "string" then
    if isMediaOrSupports(cash) then
      blockSelector = cash
    else
      selectorPaths:push(cash)
    end
  elseif type(cash) == "function" then
    local selector = cash(nil, {context = instance.context, props = params})
    if isMediaOrSupports(selector) then
      blockSelector = selector
    else
      selectorPaths:push(selector)
    end
  else
    if cash.before then
      cash:before(instance.context)
    end
    if not cash["$"] or type(cash["$"]) == "string" then
      if isMediaOrSupports(cash["$"]) then
        blockSelector = cash["$"]
      else
        selectorPaths:push(cash["$"])
      end
    elseif cash["$"] then
      local selector = cash["$"](cash, {context = instance.context, props = params})
      if isMediaOrSupports(selector) then
        blockSelector = selector
      else
        selectorPaths:push(selector)
      end
    end
  end
  local selector = parseSelectorPath(selectorPaths)
  local style = createStyle(
    selector,
    node.props,
    instance,
    params
  )
  if blockSelector then
    styles:push(blockSelector .. " {")
    if styleSheet and style then
      styleSheet:insertRule(((blockSelector .. " {\n") .. style) .. "\n}\n")
    end
  else
    if styleSheet and style then
      styleSheet:insertRule(style)
    end
    if not styleSheet and #style > 0 then
      styles:push(style)
    end
  end
  if node.children then
    loopCNodeListWithCallback(
      node.children,
      {context = instance.context, props = params},
      function(_, childNode)
        if type(childNode) == "string" then
          local style = createStyle(
            selector,
            {raw = childNode},
            instance,
            params
          )
          if styleSheet then
            styleSheet:insertRule(style)
          else
            styles:push(style)
          end
        else
          traverseCNode(
            childNode,
            selectorPaths,
            styles,
            instance,
            params,
            styleSheet
          )
        end
      end
    )
  end
  selectorPaths:pop()
  if blockSelector then
    styles:push("}")
  end
  if cash and cash.after then
    cash:after(instance.context)
  end
end

local function render(node, instance, props, insertRule)
  if insertRule == nil then
    insertRule = false
  end
  local styles = Tbl({})
  local __traverseCNode = traverseCNode
  __traverseCNode(node, Tbl({}), styles, instance, props)
  if insertRule then
    return ""
  end
  return styles:join("\n\n")
end

local function wrappedRender(self, props)
  return render(self, self.instance, props)
end

--- CNode
local function createCNode(instance, cash, props, children)
  return {
    instance = instance,
    ["$"] = cash,
    props = props,
    children = children,
    els = {},
    render = wrappedRender
  }
end

local function c(instance, cash, props, children)
  if arrayIsArray(cash) then
    return createCNode(
      instance,
      {["$"] = nil},
      nil,
      cash
    )
  elseif arrayIsArray(props) then
    return createCNode(
      instance,
      cash,
      nil,
      props
    )
  elseif arrayIsArray(children) then
    return createCNode(
      instance,
      cash,
      props,
      children
    )
  else
    return createCNode(
      instance,
      cash,
      props,
      nil
    )
  end
end

local function CssRender(config)
  if config == nil then
    config = {}
  end
  local cssr
  cssr = {
    c = function(args)
      arg_type = args ~= nil and #args >= 1 and type(args[1]) or nil
      if arg_type ~= nil and arg_type == "string" then
        return c(cssr, arraySpread(args))
      else
        return c(cssr, args)
      end
    end,
    use = function(plugin, args)
      return plugin:install(cssr, arraySpread(args))
    end,
    context = {},
    config = config
  }
  return cssr
end

return CssRender
