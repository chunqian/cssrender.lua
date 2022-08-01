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

```json
{
  "instance": {
    "context": {},
    "config": {},
    "__styleSheet": {}
  },
  "$": {
    "$": null
  },
  "props": null,
  "children": [
    {
      "instance": {
        "context": {},
        "config": {},
        "__styleSheet": {}
      },
      "$": ".disabled",
      "props": {
        "opacity": 0.4,
        "filter": "alpha(opacity=40)",
        "cursor": "default",
        "MsPointerEvents": "none",
        "PointerEvents": "none"
      },
      "children": null,
      "els": []
    },
    {
      "instance": {
        "context": {},
        "config": {},
        "__styleSheet": {}
      },
      "$": "container",
      "props": {
        "width": "100%"
      },
      "children": [
        {
          "instance": {
            "context": {},
            "config": {},
            "__styleSheet": {}
          },
          "$": "&_left, &_right",
          "props": {
            "width": "50%"
          },
          "children": null,
          "els": []
        },
        {
          "instance": {
            "context": {},
            "config": {},
            "__styleSheet": {}
          },
          "$": "&.dark",
          "props": null,
          "children": [
            {
              "instance": {
                "context": {},
                "config": {},
                "__styleSheet": {}
              },
              "$": "&_left, &_right",
              "props": {
                "backgroundColor": "black"
              },
              "children": null,
              "els": []
            }
          ],
          "els": []
        }
      ],
      "els": []
    }
  ],
  "els": []
}
```
