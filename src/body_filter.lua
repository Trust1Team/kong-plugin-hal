local utils = require "kong.tools.utils"
local stringy = require "stringy"
local cjson = require "cjson"

local BodyFilter = {}

----------------------- 
-- Utility functions --
-----------------------

local function to_json(body)
    local status, res = pcall(cjson.decode, body)
    if status then
      return res
    end

    return nil
end

local function remove_ending_slash(url)
	local len = string.len(url)
	local char = string.sub(url, len, len)
	if char == "/" then
		return string.sub(url, 0, len - 1)
	end

	return url
end

local function escape_pattern(pattern)
  local matches =
  {
    ["^"] = "%^";
    ["$"] = "%$";
    ["("] = "%(";
    [")"] = "%)";
    ["%"] = "%%";
    ["."] = "%.";
    ["["] = "%[";
    ["]"] = "%]";
    ["*"] = "%*";
    ["+"] = "%+";
    ["-"] = "%-";
    ["?"] = "%?";
  }

  return string.gsub(pattern, ".", matches)
end

local function replace_url(json, upstream_url, downstream_url) 
  	if utils.table_size(json) > 0 then
    		for key, value in pairs(json) do
			if type(value) == "table" then
				json[key] = replace_url(value, upstream_url, downstream_url)
			else
				json[key] = string.gsub(value, upstream_url, downstream_url)
			end
    		end
  	end

	return json
end

---------------------------
-- Filter implementation --
---------------------------

function BodyFilter.execute(body, upstream_url, downstream_url)
	if upstream_url and downstream_url then
		local json_body = to_json(body)
		if json_body then
			return cjson.encode(replace_url(json_body, escape_pattern(remove_ending_slash(upstream_url)), remove_ending_slash(downstream_url)))
		end

	end

	return body
end

return BodyFilter 
