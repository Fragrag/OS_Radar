/*

OpenWeatherMap Parser
Weather condition codes to Precipitation Mode and Value

Looks at the weather number value, looks it up in the table csv and outputs the precipitation mode and value
*/

Table WeatherIDTable;

void loadWeatherIDTable() {
  WeatherIDTable = loadTable("WeatherIDTable.csv", "header");
}

String GetPrecipitationModeFromTable(Table WeatherIDTable, int WeatherID) {
  // If input WeatherIDTable is null, return no. Otherwise find the row with the matching WeatherID Code variable
  // and return the corresponding PrecipitationMode
  if (WeatherIDTable == null) {
    return "no";
  }
  else {
    TableRow result = WeatherIDTable.findRow(nf(WeatherID), "Code");
    println(result.getString("PrecipitationMode"));
    return result.getString("PrecipitationMode");
  }
}

int GetValueFromTable(Table WeatherIDTable, int WeatherID) {
  // If input WeatherIDTable is null, return no. Otherwise find the row with the matching WeatherID Code variable
  // and return the corresponding Value
  if (WeatherIDTable == null) {
    return 0;
  }
  else {
    TableRow result = WeatherIDTable.findRow(nf(WeatherID), "Code");
    println(result.getString("Value"));
    return int(result.getString("Value"));
  }
}
