const planSize = 7;

final Map<String, dynamic> diabetes1Body = {
  "size": planSize,
  "plan": {
    "accept": {
      "all": [
        {
          "diet": ["BALANCED"]
        }
      ]
    },
    "fit": {
      "ENERC_KCAL": {"min": 1000, "max": 2000},
      "FIBTG": {"min": 5, "max": 10}
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

const Map<String, dynamic> diabetes2Body = {
  // Add the appropriate key-value pairs here
};

const Map<String, dynamic> hipertensionBody = {
  // Add the appropriate key-value pairs here
};
