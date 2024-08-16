import json
import os
import re
import shlex

from pathlib import Path
import subprocess

from collections import defaultdict
from dataclasses import dataclass
from datetime import datetime
from typing import DefaultDict

from libqtile import bar, layout, qtile, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.backend.wayland import InputConfig
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from qtile_extras import widget
from qtile_extras.widget.decorations import BorderDecoration

# home patch
home = str(Path.home())

# zshell integration
shell = "/bin/zsh "

# file manager
fm = "yazi"

# Super key
mod = "mod4"

# alt key
alt = "mod1"

if qtile.core.name == "wayland":  
    os.environ["XDG_SESSION_DESKTOP"] = "qtile:wlroots"
    os.environ["XDG_CURRENT_DESKTOP"] = "qtile:wlroots"

#terminal = guess_terminal()
if qtile.core.name == "x11":
    term = "alacritty"
elif qtile.core.name == "wayland":
    term = "foot"


keys = [
    # audio Command
    Key([], "XF86AudioMute", lazy.spawn("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+")),

    # player command
    Key([mod], "n", lazy.spawn("playerctl next"), desc="player command next track"),
    Key([mod], "b", lazy.spawn("playerctl previous"), desc="player command previous track"),
    Key([mod], "m", lazy.spawn("playerctl play-pause"), desc="player command play and stop current track"),

    # clipboard
    Key([mod], "f1", lazy.spawn(shell + home + "/.local/bin/clip_run"), desc="clipboard selector"),
    Key([mod], "f2", lazy.spawn(shell + home + "/.local/bin/clip_delete"), desc="clipboard delete"),

    # device menu
    Key([mod], "f3", lazy.spawn(shell + home + "/.local/bin/device-menu"), desc="device menu (mount/umount devices)"),

    # emoji menu
    Key([mod], "f4", lazy.spawn(shell + home + "/.local/bin/emojimenu"), desc="emoji selector menu"),

    # file manager
    Key([mod], "f5", lazy.spawn(term + " " + fm)),

    # lock screen
    Key([alt], "l", lazy.spawn(shell + home + "/.config/qtile/script/lockscreen.sh"), desc="lockscreen"),
    # Control + alt + delete keybinding
    Key([alt, "control"], "delete", lazy.spawn(shell + home + "/.config/qtile/script/powermenu.sh"), desc="power menu"),
    # screen bachlight
    Key([], 'XF86MonBrightnessUp',   lazy.spawn("brightnessctl set +5%")),
    Key([], 'XF86MonBrightnessDown', lazy.spawn("brightnessctl set 5%-")),
    # App launcher
    Key([mod], "d", lazy.spawn("rofi -show drun"), desc="rofi application launcher"),
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(term), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod, "shift"], "c", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod, "Shift"], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
]

# Add key bindings to switch VTs in Wayland.
# We can't check qtile.core.name in default config as it is loaded before qtile is started
# We therefore defer the check until the key binding is run by using .when(func=...)
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )


groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend(
        [
            # mod + group number = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod + shift + group number = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod + shift + group number = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

layouts = [
    layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=2, margin=5),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    layout.Stack(num_stacks=2),
    layout.Bsp(),
    layout.Matrix(),
    layout.MonadTall(),
    layout.MonadWide(),
    layout.RatioTile(),
    layout.Tile(),
    layout.TreeTab(),
    layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="Terminus",
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        wallpaper = '~/Immagini/sfondo27.png',
        wallpaper_mode = 'fill', 
        top=bar.Bar(
            [
                widget.GroupBox(highlight_method='line'),
                #widget.CurrentLayout(),
                widget.CurrentLayoutIcon(),
                widget.Prompt(),
                widget.WindowName(),
                widget.MemoryGraph(graph_color = "#af0707"),
                widget.CPUGraph(),
                widget.Sep(),
                widget.Volume(emoji = True),
                #widget.ALSAWidget(),
                widget.Sep(),
                widget.Battery(),
                widget.Sep(),
                widget.Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                #widget.TextBox("default config", name="default"),
                #widget.TextBox("Press &lt;M-r&gt; to spawn", foreground="#d75f5f"),
                #xs NB Systray is incompatible with Wayland, consider using StatusNotifier instead
                #widget.Wlan(format='{essid} {percent:2.0%}'),
                widget.WiFiIcon(),
                widget.Sep(),
                #widget.Systray(),
                widget.StatusNotifier(),
                widget.Sep(),
                widget.Clock(format="%a %I:%M %p %Y-%m-%d"),
                #widget.QuickExit(),
            ],
            24,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
        # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
        # By default we handle these events delayed to already improve performance, however your system might still be struggling
        # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
        # x11_drag_polling_rate = 60,
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button2", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button1", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# xcursor theme (string or None) and size (integer) for Wayland backend
wl_xcursor_theme = None
wl_xcursor_size = 24

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"

@hook.subscribe.startup_once
def autostart():
    home = Path('~/.config/qtile/autostart.sh').expanduser()
    subprocess.run(home)

# mouse
wl_input_rules = {
    "2:8:AlpsPS/2 ALPS GlidePoint": InputConfig(left_handed=True, tap=True, natural_scroll=True),
    "*": InputConfig(left_handed=True, pointer_accel=True),
    "type:keyboard": InputConfig(kb_layout="us", kb_variant="altgr-intl", kb_options="compose:ralt"),
}
