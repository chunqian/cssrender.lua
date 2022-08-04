# cssrender.lua 
css in lua

## lua 
```lua
local css_render = require("cssr")
local cR = css_render().c
local style = 
cR {
  cR {
    "data-table",
    {
      width = "100%",
      fontSize = "var(--n-font-size)",
      display = "flex",
      position = "relative",
      ["--n-merged-th-color"] = "var(--n-th-color)",
      ["--n-merged-td-color"] = "var(--n-td-color)",
      ["--n-merged-border-color"] = "var(--n-border-color)",
      ["--n-merged-th-color-hover"] = "var(--n-th-color-hover)",
      ["--n-merged-td-color-hover"] = "var(--n-td-color-hover)",
      ["--n-merged-td-color-striped"] = "var(--n-td-color-striped)",
    },
    {
      cR {
        "data-table-wrapper",
        {
          flexGrow = 1,
          display = "flex",
          flexDirection = "column",
        }
      },
      cR {
        "flex-height",
        {
          cR {
            ">",
            {
              cR {
                "data-table-wrapper",
                {
                  cR {
                    ">",
                    {
                      cR {
                        "data-table-base-table",
                        {
                          display = "flex",
                          flexDirection = "column",
                          flexGrow = 1,
                        },
                        {
                          cR {
                            ">",
                            {
                              cR {
                                "data-table-base-table-body",
                                {
                                  flexBasis = 0,
                                },
                                {
                                  cR {
                                    "&:last-child",
                                    {
                                      flexGrow = 1,
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      },
      cR {
        ">",
        {
          cR {
            "base-loading",
            {
              color = "var(--n-loading-color)",
              fontSize = "var(--n-loading-size)",
              position = "absolute",
              left = "50%",
              top = "50%",
              transform = "translateX(-50%) translateY(-50%)",
              transition = "color .3s var(--n-bezier)",
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
data-table {
  width: 100%;
  font-size: var(--n-font-size);
  display: flex;
  position: relative;
  --n-merged-th-color: var(--n-th-color);
  --n-merged-td-color: var(--n-td-color);
  --n-merged-border-color: var(--n-border-color);
  --n-merged-th-color-hover: var(--n-th-color-hover);
  --n-merged-td-color-hover: var(--n-td-color-hover);
  --n-merged-td-color-striped: var(--n-td-color-striped);
}

data-table data-table-wrapper {
  flex-grow: 1;
  display: flex;
  flex-direction: column;
}

data-table flex-height > data-table-wrapper > data-table-base-table {
  display: flex;
  flex-direction: column;
  flex-grow: 1;
}

data-table flex-height > data-table-wrapper > data-table-base-table > data-table-base-table-body {
  flex-basis: 0;
}

data-table flex-height > data-table-wrapper > data-table-base-table > data-table-base-table-body:last-child {
  flex-grow: 1;
}

data-table > base-loading {
  color: var(--n-loading-color);
  font-size: var(--n-loading-size);
  position: absolute;
  left: 50%;
  top: 50%;
  transform: translateX(-50%) translateY(-50%);
  transition: color .3s var(--n-bezier);
}
```

Thanks for the inspiration [css-render](https://github.com/07akioni/css-render) has given me.
