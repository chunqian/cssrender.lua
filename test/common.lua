--[[---------------------------------------------------------
    name: common.lua
    author: shenchunqian
    created: 2022-07-27
-----------------------------------------------------------]]

local css_render = require("../cssr")
local cR = css_render().c

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
  local function leave(opt)
    local leaveStr = "opacity "
                    ..opt.duration.." "..style.cubicBezierEaseIn..", "
                    .."transform "
                    ..opt.duration.." "..style.cubicBezierEaseIn.." "
    if opt.originalTransition ~= "" then
      leaveStr = leaveStr
                ..", "
                ..opt.originalTransition
    end
    return leaveStr
  end

  local function enter(opt)
    local enterStr = "opacity "
                    ..opt.duration.." "..style.cubicBezierEaseOut..", "
                    .."transform "
                    ..opt.duration.." "..style.cubicBezierEaseOut.." "
    if opt.originalTransition ~= "" then
      enterStr = enterStr
                ..", "
                ..opt.originalTransition
    end
    return enterStr
  end

  local cnodeList = {
    cR {
      "&.fade-in-scale-up-transition-leave-active",
      {
        transformOrigin = options.transformOrigin,
        transition = leave(options),
      }
    },
    cR {
      "&.fade-in-scale-up-transition-enter-active",
      {
        transformOrigin = options.transformOrigin,
        transition = enter(options),
      }
    },
    cR {
      "&.fade-in-scale-up-transition-enter-from, &.fade-in-scale-up-transition-leave-to",
      {
        opacity = 0,
        transform = options.originalTransform.." ".."scale("..options.enterScale..")"
      }
    },
    cR {
      "&.fade-in-scale-up-transition-leave-from, &.fade-in-scale-up-transition-enter-to",
      {
        opacity = 1,
        transform = options.originalTransform.." ".."scale(1)"
      }
    }
  }

  return cnodeList
end

return common
