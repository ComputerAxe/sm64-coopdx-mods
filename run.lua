-- name: Ultimate Run Mod
-- incompatible: moveset
-- description: Crappy remake of the Run Mod. Default button to Run is the Y button.\n\nDespite the fact that this is supposed to be a remake, it somehow turned out even crappier.

function mario_update(m)
    if (m.controller.buttonDown & Y_BUTTON) ~= 0 then
        if (m.action == ACT_WALKING and m.forwardVel > 28) then
            m.forwardVel = 75
        elseif (m.action == ACT_JUMP or m.action == ACT_DOUBLE_JUMP or m.action == ACT_TRIPLE_JUMP) then
            m.forwardVel = 50
        end
    end
end

hook_event(HOOK_MARIO_UPDATE, mario_update)