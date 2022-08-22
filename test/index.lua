--[[---------------------------------------------------------
    name: index.lua
    author: shenchunqian
    created: 2022-07-27
-----------------------------------------------------------]]

-- add path
package.path = package.path .. ";../?.lua"

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
print(style:render())
