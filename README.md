# cssrender.lua 
css in lua

## lua 
```lua
local css_render = require("../cssr")
local cashC = css_render().c

local common = require("common")

local style = 
cashC {
  cashC {
    "data-table", {
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
      cashC {
        "data-table-wrapper", {
          flexGrow = 1,
          display = "flex",
          flexDirection = "column",
        }
      },
      cashC {
        "flex-height", {
          cashC {
            ">", {
              cashC {
                "data-table-wrapper", {
                  cashC {
                    ">", {
                      cashC {
                        "data-table-base-table", {
                          display = "flex",
                          flexDirection = "column",
                          flexGrow = 1,
                        },
                        {
                          cashC {
                            ">", {
                              cashC {
                                "data-table-base-table-body", {
                                  flexBasis = 0,
                                },
                                {
                                  cashC {
                                    "&:last-child", {
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
      cashC {
        ">", {
          cashC {
            "base-loading", {
              color = "var(--n-loading-color)",
              fontSize = "var(--n-loading-size)",
              position = "absolute",
              left = "50%",
              top = "50%",
              transform = "translateX(-50%) translateY(-50%)",
              transition = "color .3s var(--n-bezier)",
            },
            {
              common.fadeInScaleUpTransition {
                transformOrigin = "inherit",
                duration = ".2s",
                enterScale = .9,
                originalTransform = "translateX(-50%) translateY(-50%)",
                originalTransition = "",
              }
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

data-table > base-loading.fade-in-scale-up-transition-leave-active {
  transform-origin: inherit;
  transition: opacity .2s cubic-bezier(.4, 0, 1, 1), transform .2s cubic-bezier(.4, 0, 1, 1);
}

data-table > base-loading.fade-in-scale-up-transition-enter-active {
  transform-origin: inherit;
  transition: opacity .2s cubic-bezier(0, 0, .2, 1), transform .2s cubic-bezier(0, 0, .2, 1);
}

data-table > base-loading.fade-in-scale-up-transition-enter-from, data-table > base-loading.fade-in-scale-up-transition-leave-to {
  opacity: 0;
  transform: translateX(-50%) translateY(-50%) scale(.9);
}

data-table > base-loading.fade-in-scale-up-transition-leave-from, data-table > base-loading.fade-in-scale-up-transition-enter-to {
  opacity: 1;
  transform: translateX(-50%) translateY(-50%) scale(1);
}
```

Thanks for the inspiration [css-render](https://github.com/07akioni/css-render) has given me.
