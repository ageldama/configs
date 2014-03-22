import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig
import XMonad.Config.Gnome
import System.IO
import XMonad.Config.Desktop (desktopLayoutModifiers)


--
main = xmonad gnomeConfig
        { modMask = mod4Mask -- Use Super instead of Alt
        , layoutHook = desktopLayoutModifiers (Tall 1 0.03 0.5 ||| Full)
        }