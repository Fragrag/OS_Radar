class DateTime {
  int year, month, day;
  int hour, minute, second;
  String[] ymd = new String[3];
  String[] hms = new String[3];
  String YearMonthDay;
  String HourMinuteSecond;
  String[] DateTimeArray = new String[2];
  String DateTimeString;
  
  DateTime(int _year, int _month, int _day, int _hour, int _minute, int _second) {
    year = _year;
    month = _month;
    day = _day;
    hour = _hour;
    minute = _minute;
    second = _second;
    
    ymd[0] = str(year);
    ymd[1] = str(month);
    ymd[2] = str(day);
    
    hms[0] = str(hour);
    hms[1] = str(minute);
    hms[2] = str(second);
    
    YearMonthDay = join(ymd, "-");
    HourMinuteSecond = join(hms, ":");
    
    DateTimeArray[0] = YearMonthDay;
    DateTimeArray[1] = HourMinuteSecond;
    
    DateTimeString = join(DateTimeArray, "T");
  }
  
  void UpdateDateTimeString() {
    ymd[0] = nf(year, 4);
    ymd[1] = nf(month, 2);
    ymd[2] = nf(day, 2);
    
    hms[0] = nf(hour, 2);
    hms[1] = nf(minute, 2);
    hms[2] = nf(second, 2);
    
    YearMonthDay = join(ymd, "-");
    HourMinuteSecond = join(hms, ":");
    
    DateTimeArray[0] = YearMonthDay;
    DateTimeArray[1] = HourMinuteSecond;
    
    DateTimeString = join(DateTimeArray, "T");
  }
  
}

DateTime DateStringToDateTime(String datestring) {
  String[] datesplit = split(datestring, "-");
  String[] daytime = split(datesplit[2], "T");
  String[] time = split(daytime[1], ":");
  
  int year = int(datesplit[0]);
  int month = int(datesplit[1]);
  int day = int(daytime[0]);
  int hour = int(time[0]);
  int minute = int(time[1]);
  int second = int(time[2]);
  
  DateTime OutputDateTime = new DateTime(year, month, day, hour, minute, second);
  
  return OutputDateTime;
}
