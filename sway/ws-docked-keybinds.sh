mod=Mod4
disp1=eDP-1
disp2=DP-3
disp3=DP-2
disp4=DP-1

sway bindsym $mod+F1 focus output $disp1
sway bindsym $mod+Shift+F1 move workspace to output $disp1

sway bindsym $mod+F2 focus output $disp2
sway bindsym $mod+Shift+F2 move workspace to output $disp2

sway bindsym $mod+F3 focus output $disp3
sway bindsym $mod+Shift+F3 move workspace to output $disp3

sway bindsym $mod+F4 focus output $disp4
sway bindsym $mod+Shift+F4 move workspace to output $disp4
