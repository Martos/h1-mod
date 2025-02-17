local Lobby = luiglobals.Lobby
local MPLobbyOnline = LUI.mp_menus.MPLobbyOnline

game:addlocalizedstring("LUA_MENU_SERVERLIST", "SERVER LIST")

function LeaveLobby(f5_arg0)
    LeaveXboxLive()
    if Lobby.IsInPrivateParty() == false or Lobby.IsPrivatePartyHost() then
        LUI.FlowManager.RequestLeaveMenuByName("menu_xboxlive")
        Engine.ExecNow("clearcontrollermap")
    end
end

function menu_xboxlive(f16_arg0, f16_arg1)
    local menu = LUI.MPLobbyBase.new(f16_arg0, {
        menu_title = "@PLATFORM_UI_HEADER_PLAY_MP_CAPS",
        memberListState = Lobby.MemberListStates.Prelobby
    })

    menu:setClass(LUI.MPLobbyOnline)

    local serverListButton = menu:AddButton("@LUA_MENU_SERVERLIST", function(a1, a2)
        LUI.FlowManager.RequestAddMenu(a1, "menu_systemlink_join", true, nil)
    end)
    serverListButton:setDisabledRefreshRate(500)
    if Engine.IsCoreMode() then
        menu:AddCACButton()
        menu:AddBarracksButton()
        menu:AddPersonalizationButton()
        -- menu:AddDepotButton()
    end

    serverListButton = menu:AddButton("@MENU_PRIVATE_MATCH", MPLobbyOnline.OnPrivateMatch,
        MPLobbyOnline.disablePrivateMatchButton)
    serverListButton:rename("menu_xboxlive_private_match")
    serverListButton:setDisabledRefreshRate(500)
    if not Engine.IsCoreMode() then
        local leaderboardButton = menu:AddButton("@LUA_MENU_LEADERBOARD", "OpLeaderboardMain")
        leaderboardButton:rename("OperatorMenu_leaderboard")
    end

    menu:AddOptionsButton()
    local natType = Lobby.GetNATType()
    if natType then
        local natTypeText = Engine.Localize("NETWORK_YOURNATTYPE", natType)
        local properties = CoD.CreateState(nil, nil, 2, -62, CoD.AnchorTypes.BottomRight)
        properties.width = 250
        properties.height = CoD.TextSettings.BodyFontVeryTiny.Height
        properties.font = CoD.TextSettings.BodyFontVeryTiny.Font
        properties.color = luiglobals.Colors.white
        properties.alpha = 0.25
        local self = LUI.UIText.new(properties)
        self:setText(natTypeText)
        menu:addElement(self)
    end

    menu.isSignInMenu = true
    menu:registerEventHandler("gain_focus", LUI.MPLobbyOnline.OnGainFocus)
    menu:registerEventHandler("player_joined", luiglobals.Cac.PlayerJoinedEvent)
    menu:registerEventHandler("exit_live_lobby", LeaveLobby)

    if Engine.IsCoreMode() then
        Engine.ExecNow("eliteclan_refresh", Engine.GetFirstActiveController())
    end

    return menu
end

LUI.MenuBuilder.m_types_build["menu_xboxlive"] = menu_xboxlive
