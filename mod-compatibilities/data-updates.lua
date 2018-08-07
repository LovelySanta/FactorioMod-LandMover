
for _, modName in pairs({
  "angelsrefining",
}) do
  require("mod-compatibilities."..modName..".data-updates")
end
