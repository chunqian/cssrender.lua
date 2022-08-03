# cssrender.lua 
css in lua

## lua 
```lua
local css_render = require("cssr")
local style = 
cB {
  cB {
    '.disable',
    {
      opacity = .4,
      filter = 'alpha(opacity=40)',
      cursor = 'default',
      MsPointerEvents = 'none',
      PointerEvents = 'none'
    }
  },
  cB {
    'container',
    {
      width = '100%',
    },
    {
      cB {
        '&_left, &_right',
        {
          width = '50%',
        }
      },
      cB {
        '&.dark',
        {
          cB {
            '&_left, &_right',
            {
              backgroundColor = 'black',
            }
          }
        }
      }
    }
  }
}
style:render()
```

## css 
```css
.disable {
  opacity: 0.4;
  filter: alpha(opacity=40);
  cursor: default;
  -ms-pointer-events: none;
  -pointer-events: none;
}

container {
  width: 100%;
}

container_left, container_right {
  width: 50%;
}

container.dark_left, container.dark_right {
  background-color: black;
}
```

Thanks for the inspiration [css-render](https://github.com/07akioni/css-render) has given me.
