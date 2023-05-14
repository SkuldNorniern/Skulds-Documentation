local plugin_root = ...
local M = {}

local category = {
  ".meta",
  -- ".completion",
  -- ".editing",
  -- ".mason",
  -- ".project",
  -- ".ricing",
  -- ".tools",
}

for _, cat in ipairs(category) do
  local dir = plugin_root .. cat
  local spec = require(dir .. ".spec")
  local conf = require(dir .. ".conf")

  for name, spec in pairs(spec) do
    spec[1] = name
    spec.config = conf[name]
    M[#M+1] = spec
  end
end

return M
