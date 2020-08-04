Hooks = Hooks or {}

-- A Way to only overwrite a hook if "case" is true
function BoredomDotbat.HookIf(case, hookName, name, func)
    BoredomDotbat.LogDebug("Overwrite hook: " .. hookName .. ":" .. name)

    -- Preserve it for later
    if not Hooks[hookName .. ":" .. name] then
        Hooks[hookName .. ":" .. name] = hook.GetTable()[hookName][name]
    end

    if isfunction(case) and case() or case then
        hook.Add(hookName, name, func)
    end
end

-- A Way to undo a overwrite (will do nothing if not overwritten with HookIf before)
function BoredomDotbat.HookUndo(hookName, name)
    BoredomDotbat.LogDebug("Undo hook: " .. hookName .. ":" .. name)
    if not Hooks[hookName .. ":" .. name] then return end
    hook.Add(hookName, name, Hooks[hookName .. ":" .. name])
    Hooks[hookName .. ":" .. name] = nil
end

-- A Way to enable/disable a Module
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
        BoredomDotbat.LogDebug("Module " .. name .. " Toggled.", enabled)
    end
end