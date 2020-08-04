Hooks = Hooks or {}

function BoredomDotbat.LoadConfig()
    if file.Exists("boredomdotbat.txt", "DATA") then
        local data = util.JSONToTable(file.Read("boredomdotbat.txt")) or {}
        net.Start("BoredomDotBat:SendConfig")
        net.WriteUInt(table.Count(BoredomDotbat.Modules), 7)

        for name, enabled in pairs(data) do
            local Module = BoredomDotbat.Modules[name]

            if Module then
                print(name, enabled)
                Module.Enabled = enabled
                net.WriteString(name)
                net.WriteBool(enabled)
            end
        end

        net.Broadcast()
    end
end

function BoredomDotbat.SaveConfig()
    local data = {}

    for i, v in pairs(BoredomDotbat.Modules) do
        data[i] = v.Enabled or false
    end

    file.Write("boredomdotbat.txt", util.TableToJSON(data))
end

function BoredomDotbat.HookIf(case, hookName, name, func)
    BoredomDotbat.LogDebug("Overwrite hook: " .. hookName .. ":" .. name)

    if not Hooks[hookName .. ":" .. name] then
        Hooks[hookName .. ":" .. name] = hook.GetTable()[hookName][name]
    end

    if isfunction(case) and case() or case then
        hook.Add(hookName, name, func)
    end
end

function BoredomDotbat.HookUndo(hookName, name)
    BoredomDotbat.LogDebug("Undo hook: " .. hookName .. ":" .. name)
    if not Hooks[hookName .. ":" .. name] then return end
    hook.Add(hookName, name, Hooks[hookName .. ":" .. name])
    Hooks[hookName .. ":" .. name] = nil
end

function BoredomDotbat.EnableModule(name, enabled)
    local Module = BoredomDotbat.Modules[name]
    Module.Enabled = enabled

    if enabled then
        Module.OnEnable()
    else
        Module.OnDisable()
    end

    if SERVER then
        net.Start("BoredomDotBat:ModuleToggled")
        net.WriteString(name)
        net.WriteBool(enabled)
        net.Broadcast()
        BoredomDotbat.SaveConfig()
        BoredomDotbat.Log("Module " .. name .. " Toggled.", enabled)
    end
end