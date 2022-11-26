---- // Bypass Job limit DarkRP v2.0
----------- // SCRIPT BY INJ3
----------- // SCRIPT BY INJ3
----------- // SCRIPT BY INJ3
---- // https://steamcommunity.com/id/Inj3/

--- Configuration / (Restart your server if you add new groups.)
local ipr = {

        ["Chef Pizza"] = { --- Example // add your job that will not be affected by the job limit.
            limit_reached = {
                ["superadmin"] = 0, --- '0' has no limit to access a job if it's full.
                ["vip"] = 1,
                ["admin"] = 1,
            }
        },

        ["SDF"] = { --- Example
            limit_reached = {
                ["superadmin"] = 0,
                ["vip"] = 1,
                ["admin"] = 5,
            }
        },

        ["Marchand Noir"] = { --- Example
            limit_reached = {
                ["superadmin"] = 0,
                ["vip"] = 1,
                ["admin"] = 2,
                ["vip +"] = 2,
            }
        },

}
---

---- // Do not touch the code below at the risk of breaking the gamemode ! 
if (CLIENT) then
    ipr_ovr_jb = ipr_ovr_jb or {}

    function ipr_ovr_jb.f_maxjob(t) --- function for the F4 menu, check the description on github to know how it works (if '-1' you have not correctly added the player table RPExtraTeams !)
        return (t and (t.max_fk or t.max)) or -1
    end

    local function ipr_0()
        local ipr_player = LocalPlayer()
        if not IsValid(ipr_player) then
            return
        end
        local ipr_grp = ipr_player:GetUserGroup()

        if not ipr_ovr_jb.grp or (ipr_grp ~= ipr_ovr_jb.grp) then
            for _, t in ipairs(RPExtraTeams) do
                if (t.max_fk) then
                    t.max = t.max_fk
                    t.max_fk = nil
                end

                local ipr_n = ipr[t.name]
                if not ipr_n then
                   continue
                end
                local ipr_g = ipr_n.limit_reached[ipr_grp]
                if not ipr_g then
                   continue
                end

                if (t.max > 0) then
                    t.max_fk = t.max
                    t.max = (ipr_g == 0) and 0 or t.max + ipr_g
                end
            end
            ipr_ovr_jb.grp = ipr_grp
        end
    end

    net.Receive("ipr_update_job_ov", ipr_0)
    hook.Add("InitPostEntity", "ipr_override_darkrp_job", ipr_0)
else
    local function ipr_up(p)
        net.Start("ipr_update_job_ov")
        net.Send(p)
    end
    
    local function ipr_t0_(tj, n, g)
        for t, f in pairs(tj) do
            if (t ~= n) then
               continue
            end
            for p in pairs(f.limit_reached) do
                if (p ~= g) then
                    continue
                end
                return true
            end
            break
        end
        return false
    end    
    
    local function ipr_0()
        local ipr_meta, ipr_meta_n = FindMetaTable("Player"), {["ChangeTeam"] = true, ["changeTeam"] = true}

        do
            local ipr_cache, ipr_act = ipr_meta.SetUserGroup, "ipr_ovr_job_up"
            ipr_meta.SetUserGroup = function(s, str)
                local ipr_ac = s:SteamID64()

                if timer.Exists(ipr_act ..ipr_ac) then
                    timer.Remove(ipr_act ..ipr_ac)
                end
                timer.Create(ipr_act ..ipr_ac, 0.2, 1, function()
                    if IsValid(s) then
                        ipr_up(s)
                    end
                end)
                ipr_cache(s, str)
            end
        end
        for n in pairs(ipr_meta) do
            if ipr_meta_n[n] then
                local ipr_cache = ipr_meta[n]
                ipr_meta[n] = function(s, id, f, v, g)
                    local ipr_t, ipr_grp = team.GetName(id), s:GetUserGroup()

                    if not f and ipr_t0_(ipr, ipr_t, ipr_grp) then
                        local ipr_f = ipr[ipr_t].limit_reached[ipr_grp]

                        for _, t in ipairs(RPExtraTeams) do
                            if (t.name ~= ipr_t) then
                               continue
                            end
                            if (t.max > 0) then
                                local tbl_cache = t.max
                                t.max = (ipr_f == 0) and 0 or t.max + ipr_f
                                ipr_cache(s, id, f, v, g)
                                t.max = tbl_cache
                                break
                            elseif (t.max == 0) then
                                ipr_cache(s, id, f, v, g)
                                break
                            end
                        end
                        return
                    end
                    ipr_cache(s, id, f, v, g)
                end
                break
            end
        end
    end

    print("Bypass Job limit DarkRP v2.0 by Inj3 loaded !")
    util.AddNetworkString("ipr_update_job_ov")
    hook.Add("InitPostEntity", "ipr_override_darkrp_job", ipr_0)
end
