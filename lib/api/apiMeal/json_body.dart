const planSize = 7;

final Map<String, dynamic> diabetes1Body = {
  "size": planSize,
  "plan": {
    "accept": {
      "all": [
        {
          "diet": ["BALANCED", "HIGH_FIBER"]
        }
      ]
    },
    "fit": {
      "ENERC_KCAL": {"min": 1000, "max": 2000},
    },
    "sections": {
      "Breakfast": {
        "accept": {
          "all": [
            {
              "dish": ["main course"]
            },
            {
              "meal": ["breakfast"]
            }
          ]
        },
        "fit": {
          "ENERC_KCAL": {"min": 100, "max": 600}
        }
      },
      "Lunch": {
        "accept": {
          "all": [
            {
              "dish": ["main course"]
            },
            {
              "meal": ["lunch/dinner"]
            }
          ]
        },
        "fit": {
          "ENERC_KCAL": {"min": 300, "max": 900}
        }
      },
      "Dinner": {
        "accept": {
          "all": [
            {
              "dish": ["main course"]
            },
            {
              "meal": ["lunch/dinner"]
            }
          ]
        },
        "fit": {
          "ENERC_KCAL": {"min": 200, "max": 900}
        }
      },
      "Snack": {
        "accept": {
          "all": [
            {
              "dish": ["main course"]
            },
            {
              "meal": ["snack"]
            }
          ]
        },
        "fit": {
          "ENERC_KCAL": {"min": 100, "max": 400}
        }
      }
    }
  }
};

final Map<String, dynamic> diabetes2Body = {
  "size": 7,
  "plan": {
    "accept": {
      "all": [
        {
          "diet": ["BALANCED", "HIGH_FIBER"],
        },
        {
          "health": ["DASH"]
        }
      ]
    },
    "fit": {
      "ENERC_KCAL": {"min": 1000, "max": 2000},
      "FAMS": {"min": 10, "max": 30},
      "FIBTG": {"min": 10, "max": 50},
      "FAPU": {"min": 10, "max": 30},
    },
    "sections": {
      "Breakfast": {
        "accept": {
          "all": [
            {
              "dish": ["main course"]
            },
            {
              "meal": ["breakfast"]
            }
          ]
        },
        "fit": {
          "ENERC_KCAL": {"min": 100, "max": 600}
        }
      },
      "Lunch": {
        "accept": {
          "all": [
            {
              "dish": ["main course"]
            },
            {
              "meal": ["lunch/dinner"]
            }
          ]
        },
        "fit": {
          "ENERC_KCAL": {"min": 300, "max": 900}
        }
      },
      "Dinner": {
        "accept": {
          "all": [
            {
              "dish": ["main course"]
            },
            {
              "meal": ["lunch/dinner"]
            }
          ]
        },
        "fit": {
          "ENERC_KCAL": {"min": 200, "max": 900}
        }
      },
      "Snack": {
        "accept": {
          "all": [
            {
              "dish": ["main course"]
            },
            {
              "meal": ["snack"]
            }
          ]
        },
        "fit": {
          "ENERC_KCAL": {"min": 100, "max": 400}
        }
      }
    }
  }
};

final Map<String, dynamic> hipertensionBody = {
  "size": 7,
  "plan": {
    "accept": {
      "all": [
        {
          "health": ["DASH"]
        },
      ]
    },
    "fit": {
      "ENERC_KCAL": {"min": 1000, "max": 2000},
    },
    "sections": {
      "Breakfast": {
        "accept": {
          "all": [
            {
              "dish": ["main course"]
            },
            {
              "meal": ["breakfast"]
            }
          ]
        },
        "fit": {
          "ENERC_KCAL": {"min": 100, "max": 600}
        }
      },
      "Lunch": {
        "accept": {
          "all": [
            {
              "dish": ["main course"]
            },
            {
              "meal": ["lunch/dinner"]
            }
          ]
        },
        "fit": {
          "ENERC_KCAL": {"min": 300, "max": 900}
        }
      },
      "Dinner": {
        "accept": {
          "all": [
            {
              "dish": ["main course"]
            },
            {
              "meal": ["lunch/dinner"]
            }
          ]
        },
        "fit": {
          "ENERC_KCAL": {"min": 200, "max": 900}
        }
      },
      "Snack": {
        "accept": {
          "all": [
            {
              "dish": ["main course"]
            },
            {
              "meal": ["snack"]
            }
          ]
        },
        "fit": {
          "ENERC_KCAL": {"min": 100, "max": 400}
        }
      }
    }
  }
};
