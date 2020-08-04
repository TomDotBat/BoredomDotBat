Hooks = Hooks or {}

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
        BoredomDotbat.Log("Module " .. name .. " Toggled.", enabled)
    end
end