-- ==========================================
-- STARTUP APPLICATIONS (Native Standard)
-- ==========================================
hl.on("hyprland.start", function()
    -- Native execution of the polkit agent
    hl.exec_cmd("quickshell")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'diinki-retro-dark'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")
end)
