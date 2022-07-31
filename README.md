# cssrender.lua 
css in lua

## example 
```lua
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
