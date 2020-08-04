local Module = {}
Module.Name = "Test Module"
Module.Description = "?"
Module.CanEnable = function() return true end

Module.OnEnable = function()
    print("Test Enabled")
end

Module.OnDisable = function()
    print("Test Disabled")
end

return Module