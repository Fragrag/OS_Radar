class CLogger {
  
  Table WeatherDataLog;
  String CurrentD, CurrentM, CurrentY, CurrentH, CurrentMin;
  String InitD = nf(day(), 2);
  String InitM = nf(month(), 2);
  String InitY = nf(year(), 4);
  String InitH = nf(hour(), 2);
  String InitMin = nf(minute(), 2);
  String weatherValueStr, weatherModeStr;
  
}