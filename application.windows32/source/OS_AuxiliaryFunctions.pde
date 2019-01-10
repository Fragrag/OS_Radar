//////////////////////////////////////////
/////     AUXILIARY FUNCTIONS        /////
//////////////////////////////////////////

// This function displays weatherValue and weatherMode in the GUI
void displayReturnedValues() 
{
  DateTime LastUpdateDateTime = DateStringToDateTime(LastUpdate);
  fill (50);
  noStroke();
  //debug stroke drawing:
  //stroke(255,255,255);
  //strokeWeight(1);
  rect(0, 85, width, 65);
  
  fill(255);
  
  //Display time last updated
  CurrentD = nf(day(), 2);
  CurrentM = nf(month(), 2);
  CurrentY = nf(year(), 4);
  CurrentH = nf(hour(), 2);
  CurrentMin = nf(minute(), 2);
  
  text("OS_Radar last updated", 5, 100);
  text(CurrentY + "/" + CurrentM + "/" + CurrentD + " " + CurrentH + "h" + CurrentMin, 5, 115);

  //Convert weatherValue to a string variable and displays it
  weatherValueStr = nf(weatherValue);
  text("Value", 5, 135);
  text(weatherValueStr, 5, 135, 30, 20);

  //Checks weatherMode and displays Snow, Rain or None depending on the conditions
  //weatherModeStr = GetPrecipitationModeFromTable(WeatherIDTable, weatherID);
  text("Mode", 85, 135);
  text(weatherMode, 85, 135, 40, 20);

  text("OWM last updated (GMT)", width/2-25, 100);
  text(LastUpdateDateTime.year + "/" + LastUpdateDateTime.month + "/" + LastUpdateDateTime.day + " " + LastUpdateDateTime.hour + "h" + LastUpdateDateTime.minute, width/2-25, 115);
  
  text("OWM Number", width/2-25, 135);
  text(nf(weatherID), width/2-25, 135, 30, 20);
  
  text("OWM Type", width/2 + 75, 135);
  text(weatherType, width/2 + 75, 135, 150, 20);
  }


// Adds a logger to the program to keep track of changes to Olympia
// Setup logWeatherData as a new Table
void logWeatherDataSetup()
{
  logWeatherData = new Table();
  
  // Add column headers to logWeatherData
  logWeatherData.addColumn("Date");
  logWeatherData.addColumn("Time");
  logWeatherData.addColumn("WeatherOverride");
  logWeatherData.addColumn("WeatherMode");
  logWeatherData.addColumn("WeatherValue");
  logWeatherData.addColumn("Clouds"); 
  logWeatherData.addColumn("Temperature");
  logWeatherData.addColumn("WindDirection"); 
  logWeatherData.addColumn("WindSpeed"); 
}

// Function that will write the values to the log
void logWeatherDataWriteRow()
{ 
  //Define date and time the moment the log entry is written
  CurrentD = nf(day(), 2);
  CurrentM = nf(month(), 2);
  CurrentY = nf(year(), 4);
  CurrentH = nf(hour(), 2);
  CurrentMin = nf(minute(), 2);
  
  String cloudsStr = xmlWeatherData.getChild ("clouds").getString("value");
  String tempValueStr = xmlWeatherData.getChild ("temperature").getString("value");
  String windCodeStr = xmlWeatherData.getChild ("wind").getChild("direction").getString("code");
  String windValueStr = xmlWeatherData.getChild ("wind").getChild("speed").getString("value");
  
  // Check length of table, if it exceeds an amount then delete the first row
  // and write new row after
  if (logWeatherData.getRowCount() >= 2000)
  {
    logWeatherData.removeRow(0);
    TableRow newRow = logWeatherData.addRow();
    
    newRow.setString("Date", CurrentY + "/" + CurrentM + "/" + CurrentD);
    newRow.setString("Time", CurrentH + ":" + CurrentMin);
    newRow.setString("WeatherOverride", str(isOverridden));
    newRow.setString("WeatherMode", weatherMode);
    newRow.setString("WeatherValue", weatherValueStr);
    newRow.setString("Clouds", cloudsStr); 
    newRow.setString("Temperature", tempValueStr);
    newRow.setString("WindSpeed", windValueStr);
    newRow.setString("WindDirection", windCodeStr);
  }
  else
  { 
    TableRow newRow = logWeatherData.addRow();
    newRow.setString("Date", CurrentY + "/" + CurrentM + "/" + CurrentD);
    newRow.setString("Time", CurrentH + ":" + CurrentMin);
    newRow.setString("WeatherOverride", str(isOverridden));
    newRow.setString("WeatherMode", weatherMode);
    newRow.setString("WeatherValue", weatherValueStr);
    newRow.setString("Clouds", cloudsStr); 
    newRow.setString("Temperature", tempValueStr);
    newRow.setString("WindSpeed", windValueStr);
    newRow.setString("WindDirection", windCodeStr);
  }
   
  //Takes the Init* date and time variables as the logfile name
  saveTable(logWeatherData, "log/" + InitY + InitM + InitD + "-" + InitH + "h" + InitMin + ".csv");
}
