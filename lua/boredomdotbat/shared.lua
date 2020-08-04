print("shared lol")
local Hooks = {}

function BoredomDotbat.HookIf(case, hookName, name, func)
    BoredomDotbat.LogDebug("Overwrite hook: " .. hookName .. ":" .. name)
    Hooks[hookName .. ":" .. name] = hook.GetTable()[hookName][name]
    PrintTable(Hooks)

    if isfunction(case) and case() or case then
        hook.Add(hookName, name, func)
    end
end

function BoredomDotbat.HookUndo(hookName, name)
    BoredomDotbat.LogDebug("Undo hook: " .. hookName .. ":" .. name)
    if not Hooks[hookName .. ":" .. name] then return end
    hook.Add(hookName, name, Hooks[hookName .. ":" .. name])
end