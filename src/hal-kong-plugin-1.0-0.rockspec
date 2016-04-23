package = "HAL-kong-plugin"
version = "1.0-0"
source = {
  url = "..."
}
description = {
  summary = "The Kong HAL plugin.",
  license = "MIT/X11"
}
dependencies = {
  "lua ~> 5.1"
  -- If you depend on other rocks, add them here
}
build = {
  type = "builtin",
  modules = {
    ["kong.plugins.hal.handler"] = "/kong/kong/plugins/hal/handler.lua",
    ["kong.plugins.hal.schema"] = "/kong/kong/plugins/hal/schema.lua",
    ["kong.plugins.hal.body_filter"] = "/kong/kong/plugins/hal/body_filter.lua"
  }
}
