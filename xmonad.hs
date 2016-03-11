-- Fix this : https://wiki.haskell.org/Xmonad/Frequently_asked_questions#XMonad_is_frozen.21
import Graphics.X11.ExtraTypes.XF86
import System.IO
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Config.Desktop
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Run(spawnPipe)
import XMonad.Layout.NoBorders
import XMonad.Actions.WorkspaceNames
import XMonad.Prompt
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.Tabbed
import XMonad.Layout.Accordion
import XMonad.Actions.FindEmptyWorkspace
import XMonad.Actions.GridSelect
import XMonad.Util.Scratchpad
import XMonad.StackSet as W
import XMonad.Actions.CycleWS
--http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Util-EZConfig.html
--Note that, unlike in xmonad 0.4 and previous, you can't use
--modMask to refer to the modMask you configured earlier. You must
--specify mod1Mask (or whichever), or add your own myModMask =
--mod1Mask line.
my_mod_mask=mod4Mask
altMask=mod1Mask
{- my_terminal="gnome-terminal" -}
my_terminal="xterm"

myManageHook = composeAll [
    manageDocks
    , className =? "Gimp"      --> doFloat
    , className =? "Vncviewer" --> doFloat
    , className =? "Yakuake" --> doFloat
    , className =? "Tilda" --> doFloat
    -- http://iaindunning.com/blog/experiences-with-xmonad-and-ubuntu-12.html
    , resource =? "trayer" --> doFloat
    {- , resource =? "cairo-dock" --> doFloat -}
    , isFullscreen --> doFullFloat
    , manageHook defaultConfig
    ] <+> manageScratchPad

{- https://pbrisbin.com/posts/xmonad_scratchpad/ -}
-- then define your scratchpad management separately:
manageScratchPad :: ManageHook
manageScratchPad = scratchpadManageHook (W.RationalRect l t w h)
  where

    h = 0.3     -- terminal height, 30%
    w = 1       -- terminal width, 100%
    t = 0.02       -- distance from top edge, 2% i.e just below xmobar
    l = 1 - w   -- distance from left edge, 0%

{- shubham x = getWorkspaceNames -}

{- http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Doc-Extending.html#Editing_the_layout_hook -}
{- http://stackoverflow.com/questions/940382/haskell-difference-between-dot-and-dollar-sign -}
{- my_layout_hook = smartBorders  $ avoidStruts $ (Full ||| tabbed shrinkText defaultTheme ||| Accordion) -}
{- http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Layout-ToggleLayouts.html -}
{- toggleLayouts will toggle between its two arguments witch can be 2 list of layouts -}
{- layoutHook defaultConfig will get default for layoutHook -}
{- my_layout_hook =  smartBorders  $ avoidStruts $ toggleLayouts Full $  layoutHook defaultConfig -}
{- my_layout_hook =  noBorders  $ avoidStruts $ toggleLayouts Full $  layoutHook defaultConfig -}

{- When avoidStruts is there the windows avoid covering xmobar and trayer. When we -}
{- remove it the windows will completly ignore it -}
my_layout_hook =  noBorders  $ avoidStruts $ toggleLayouts Full $  layoutHook defaultConfig
{- my_layout_hook =  noBorders $ toggleLayouts Full $  layoutHook defaultConfig -}


main = do
    xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmobarrc"
    xmonad $ defaultConfig
        {
            manageHook = myManageHook
            , layoutHook = my_layout_hook
            , logHook = dynamicLogWithPP xmobarPP{
                            ppOutput = hPutStrLn xmproc
                            {- , ppHidden = getWorkspaceNames -}
                            , ppTitle = xmobarColor "green" "" . shorten 50
                }
            {- http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Config-Desktop.html#g:5 -}
            {- https://github.com/xmonad/xmonad/issues/18 -}
            {- http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Hooks-ManageDocks.html -}
            {- Solves the problem where avoidStruts was not working on first -}
            {- workspce we need to press Mod+b twice to make it work -}
            , handleEventHook = docksEventHook <+> handleEventHook desktopConfig
            , modMask = my_mod_mask     -- Rebind Mod to the Windows key
            , startupHook = setWMName "LG3D"
            , terminal = my_terminal
        }
        `additionalKeys`[
            ((my_mod_mask .|. shiftMask, xK_z), spawn "dm-tool lock")
            , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
            , ((0, xF86XK_AudioRaiseVolume), spawn "amixer -D pulse sset Master 5%+")
            , ((0, xF86XK_AudioLowerVolume), spawn "amixer -D pulse sset Master 5%-")
            , ((0, xF86XK_AudioMute), spawn "amixer -D pulse sset Master toggle")
            , ((my_mod_mask .|. shiftMask, xK_r), renameWorkspace defaultXPConfig)
            , ((0, 0x1008ffa9), spawn "bash -c \"if [ $(synclient -l | grep TouchpadOff | awk '{print $3}') == 1 ];  then synclient touchpadoff=0; else synclient touchpadoff=1; fi\"")
            , ((my_mod_mask, xK_slash), spawn "bash -c \"xdg-open ~/xmonad_cheatsheet.png & exit\"")
            , ((my_mod_mask .|. shiftMask, xK_b), spawn "bash -c \"xdg-open ~/Xmbindings.png & exit \"")
            , ((my_mod_mask .|. shiftMask, xK_f), sendMessage (Toggle "Full"))
            {- , ((my_mod_mask,                xK_m    ), viewEmptyWorkspace) -- Go to an empty workspace not much useful this key combo is used for focusing master window -}
            , ((my_mod_mask .|. shiftMask,  xK_m    ), tagToEmptyWorkspace) --send current window to an empty workspace
            , ((my_mod_mask, xK_g), goToSelected defaultGSConfig)
            , ((my_mod_mask .|. shiftMask, xK_g), spawn "google-chrome-stable")
            , ((0, xK_Print), spawn "scrot -q 1 $(xdg-user-dir PICTURES)/screenshots/%Y-%m-%d-%H:%M:%S.png")
            , ((altMask, xK_Print), spawn "scrot -u -q 1 $(xdg-user-dir PICTURES)/screenshots/%Y-%m-%d-%H:%M:%S.png")
            , ((shiftMask, xK_Print), spawn "bash -i -c \"scrot -s -q 1 $(xdg-user-dir PICTURES)/screenshots/%Y-%m-%d-%H:%M:%S.png\"") -- not working
            , ((my_mod_mask .|. shiftMask, xK_h), spawn "pcmanfm") --replaced nautilus as it was causing problem with search
            , ((my_mod_mask, xK_c), spawn "xclip -sel clip < ~/macros.cpp")
            , ((my_mod_mask, xK_i), spawn "bash -i -c gproxy") -- alias works only in interactive shell
            {- , ((my_mod_mask, xK_s), scratchpadSpawnActionTerminal "uxterm") -- gnome-terminal does not allow setting resource. -} --Not needed
            , ((my_mod_mask, xK_p), spawn "dmenu-recent-aliases")
            , ((my_mod_mask .|. shiftMask, xK_p), spawn "j4-dmenu-desktop")
            , ((my_mod_mask, xK_d), spawn "ydb")
            , ((my_mod_mask .|. shiftMask, xK_d), spawn "dmenu_extended_run")
            , ((my_mod_mask, xK_o), spawn "bash -i -c \"hd_o\"") --open google_chrome with optirun
            , ((my_mod_mask, xK_z), toggleWS) --toggle between 2 workspaces
            , ((my_mod_mask, xK_b), sendMessage ToggleStruts) --hides xmobar etc
            , ((my_mod_mask .|. shiftMask, xK_a), spawn my_terminal) --easier to press
        ]
