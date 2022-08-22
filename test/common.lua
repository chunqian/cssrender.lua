--[[---------------------------------------------------------
    name: common.lua
    author: shenchunqian
    created: 2022-07-27
-----------------------------------------------------------]]

local css_render = require("../cssr")
local cashC = css_render().c

local function cash(f)
  return f[1]()
end

local common = {}

local style = {
  fontFamily =
    'v-sans, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol"',
  fontFamilyMono = 'v-mono, SFMono-Regular, Menlo, Consolas, Courier, monospace',

  fontWeight = '400',
  fontWeightStrong = '500',

  cubicBezierEaseInOut = 'cubic-bezier(.4, 0, .2, 1)',
  cubicBezierEaseOut = 'cubic-bezier(0, 0, .2, 1)',
  cubicBezierEaseIn = 'cubic-bezier(.4, 0, 1, 1)',

  borderRadius = '3px',
  borderRadiusSmall = '2px',

  fontSize = '14px',
  fontSizeMini = '12px',
  fontSizeTiny = '12px',
  fontSizeSmall = '14px',
  fontSizeMedium = '14px',
  fontSizeLarge = '15px',
  fontSizeHuge = '16px',

  lineHeight = '1.6',

  heightMini = '16px', -- private now, it's too small
  heightTiny = '22px',
  heightSmall = '28px',
  heightMedium = '34px',
  heightLarge = '40px',
  heightHuge = '46px'
}

common.fadeInScaleUpTransition = function(options)
  local cnodeList = {
    cashC {
      "&.fade-in-scale-up-transition-leave-active", {
        transformOrigin = options.transformOrigin,
        transition = cash {
          function ()
            local leaveStr = "opacity "..options.duration.." "..style.cubicBezierEaseIn..", "
                            .."transform "..options.duration.." "..style.cubicBezierEaseIn.." "
            if options.originalTransition ~= "" then
              leaveStr = leaveStr..", "..options.originalTransition
            end
            return leaveStr
          end
        },
      }
    },
    cashC {
      "&.fade-in-scale-up-transition-enter-active", {
        transformOrigin = options.transformOrigin,
        transition = cash {
          function()
            local enterStr = "opacity "..options.duration.." "..style.cubicBezierEaseOut..", "
                            .."transform "..options.duration.." "..style.cubicBezierEaseOut.." "
            if options.originalTransition ~= "" then
              enterStr = enterStr..", "..options.originalTransition
            end
            return enterStr
          end
        },
      }
    },
    cashC {
      "&.fade-in-scale-up-transition-enter-from, &.fade-in-scale-up-transition-leave-to", {
        opacity = 0,
        transform = options.originalTransform.." ".."scale("..options.enterScale..")"
      }
    },
    cashC {
      "&.fade-in-scale-up-transition-leave-from, &.fade-in-scale-up-transition-enter-to", {
        opacity = 1,
        transform = options.originalTransform.." ".."scale(1)"
      }
    }
  }

  return cnodeList
end

return common
