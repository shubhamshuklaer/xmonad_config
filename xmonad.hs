import Graphics.X11.ExtraTypes.XF86
import System.IO
import XMonad
import XMonad.Hooks.DynamicLog
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

myManageHook = composeAll [
    manageDocks
    , className =? "Gimp"      --> doFloat
    , className =? "Vncviewer" --> doFloat
    , isFullscreen --> doFullFloat
    , manageHook defaultConfig
    ]

{- shubham x = getWorkspaceNames -}

{- http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Doc-Extending.html#Editing_the_layout_hook -}
{- http://stackoverflow.com/questions/940382/haskell-difference-between-dot-and-dollar-sign -}
{- my_layout_hook = smartBorders  $ avoidStruts $ (Full ||| tabbed shrinkText defaultTheme ||| Accordion) -}
{- http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Layout-ToggleLayouts.html -}
{- toggleLayouts will toggle between its two arguments witch can be 2 list of layouts -}
{- layoutHook defaultConfig will get default for layoutHook -}
my_layout_hook =  smartBorders  $ avoidStruts $ toggleLayouts Full $  layoutHook defaultConfig
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
            , modMask = mod4Mask     -- Rebind Mod to the Windows key
            , startupHook = setWMName "LG3D"
        }
        `additionalKeys`[
            ((mod4Mask .|. shiftMask, xK_z), spawn "gnome-screensaver-command -l")
            , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
            , ((0, xF86XK_AudioRaiseVolume), spawn "amixer -D pulse sset Master 5%+")
            , ((0, xF86XK_AudioLowerVolume), spawn "amixer -D pulse sset Master 5%-")
            , ((0, xF86XK_AudioMute), spawn "amixer -D pulse sset Master toggle")
            , ((mod4Mask .|. shiftMask, xK_r), renameWorkspace defaultXPConfig)
            , ((0, 0x1008ffa9), spawn "bash -c \"if [ $(synclient -l | grep TouchpadOff | awk '{print $3}') == 1 ];  then synclient touchpadoff=0; else synclient touchpadoff=1; fi\"")
            , ((mod4Mask, xK_slash), spawn "bash -c \"xdg-open ~/xmonad_cheatsheet.jpg & exit\"")
            , ((mod4Mask .|. shiftMask, xK_f), sendMessage (Toggle "Full"))
            , ((mod4Mask,                xK_m    ), viewEmptyWorkspace) -- Go to an empty workspace
            , ((mod4Mask .|. shiftMask,  xK_m    ), tagToEmptyWorkspace) --send current window to an empty workspace
        ]






