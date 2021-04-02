String select(String _classItem) {
  String img;
  switch (_classItem) {
    case "income":
      {
        img = "images/incomeIcon.svg";
      }
      break;
    case "transfer":
      {
        img = "images/transferIcon.svg";
      }
      break;
    case "food":
      {
        img = "images/Food.svg";
      }
      break;
    case "entertainment":
      {
        img = "images/Entertainment.svg";
      }
      break;
    case "residence":
      {
        img = "images/Residence.svg";
      }
      break;
    case "household":
      {
        img = "images/Household.svg";
      }
      break;
    case "health":
      {
        img = "images/Health.svg";
      }
      break;
    case "travel":
      {
        img = "images/Travel.svg";
      }
      break;
    case "shopping":
      {
        img = "images/Shopping.svg";
      }
      break;
    default:
      {
        img = "images/Shopping.svg";
      }
      break;
  }
  return img;
}
