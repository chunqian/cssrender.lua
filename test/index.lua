--[[---------------------------------------------------------
    name: index.lua
    author: shenchunqian
    created: 2022-07-27
-----------------------------------------------------------]]

-- add path
package.path = package.path .. ";../?.lua"

local css_render = require("../cssr")
local C = css_render().c

local common = require("common")

local style = 
C {
  C {
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
      C {
        "data-table-wrapper", {
          flexGrow = 1,
          display = "flex",
          flexDirection = "column",
        }
      },
      C {
        "flex-height", {
          C {
            ">", {
              C {
                "data-table-wrapper", {
                  C {
                    ">", {
                      C {
                        "data-table-base-table", {
                          display = "flex",
                          flexDirection = "column",
                          flexGrow = 1,
                        },
                        {
                          C {
                            ">", {
                              C {
                                "data-table-base-table-body", {
                                  flexBasis = 0,
                                },
                                {
                                  C {
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
      C {
        ">", {
          C {
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
