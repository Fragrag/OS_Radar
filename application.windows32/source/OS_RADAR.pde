//////////////////////////////////
//////     OS_RADAR v3.1    //////
//////////////////////////////////

/*
Date 2017/07/06

Created by Jasper Janssens for OLYMPIA STADION
a video installation by David Claerbout

This is a Processing v3.3.5 script written in Java
using the controlP5 library for the user interface

-----
Date 2018/02/05
v3.1 release

This version was reworked by Haryo Sukmawanto and reviewed by Jasper Janssens for OLYMPIA STADION
a video installation by David Claerbout

OS_Radar now displays the weatherValues and weatherMode in the GUI. 
It now also has a logger that will record these values for each session 
for up three weeks in a .csv file found in log/
*/

// import controlP5 library for UI
import controlP5.*;

// some general variables
PImage webImg;
XML xmlWeatherData;
public int timer;

// variables for loading, using & saving config.xml
XML xmlConfig;
int positionX, positionY;
String xmlUrl;
String xmlWeatherDataFallback;
String xmlSave;
String imgLoad;
String imgLoadFallback;
String CurrentweatherMode;

// variables for analyzing the sampled pixel
float sampleH;
float sampleS;
float sampleB;

// variables for modifying the weather data
boolean isImgValid;
String weatherMode;
int weatherID;
float weatherValue;
float weatherClouds;
String LastUpdate;
String weatherType;

// variables for creation of UI controls
ControlP5 cp5;
Toggle t1, t2;
Numberbox n1;
Slider s1;

// variables for weather override, assigned to UI controls
boolean on_off = false;
boolean rain_snow = false;
boolean isOverridden = false;
float sliderValue = 50;
int timerOverride;;

// variables for logging
// Current* strings are set in logWeatherDataWriteRow()
// Init* Strings are used to set the start time of the log
Table logWeatherData;
String CurrentD, CurrentM, CurrentY, CurrentH, CurrentMin;
String InitD = nf(day(), 2);
String InitM = nf(month(), 2);
String InitY = nf(year(), 4);
String InitH = nf(hour(), 2);
String InitMin = nf(minute(), 2);
String weatherValueStr, weatherModeStr;

//////////////////////////////////
//////    SETUP FUNCTION    //////
//////////////////////////////////
// runs when you start the program

void setup ()  
{
  // set timer to 5 minute countdown
  timer = 15;
  
  // initialize variable
  isImgValid = true;
  
  // setup canvas width & height
  size (400,400);
  
  fill (50);
  rect (0, 0, width, 150);

  //////////////////////////////////
  //////   ADD UI CONTROLS    //////
  //////////////////////////////////
  // using ControlP5 library
 
 // initialize UI class
  cp5 = new ControlP5(this);  
  
  // add toggle for ON/OFF
  t1 = cp5.addToggle("on_off")
          .setPosition (10, 15)
          .setSize (40, 20)
          .setValue(false);
     
  // add toggle for rain or snow
  t2 = cp5.addToggle("rain_snow")
          .setPosition (80, 15)
          .setSize (40, 20)
          .setValue(true)
          .setMode(ControlP5.SWITCH);
     
  // add numberbox for setting the t mer
  n1 = cp5.addNumberbox("timerOverride")
          .setPosition(160,15)
          .setSize(80,20)
          .setRange(0,300)
          .setLabel ("Timer")
          .setValue(timer);
  
  // add slider for amount of precipitation
  s1 = cp5.addSlider ("sliderValue")
          .setPosition (10, 60)
          .setSize (100, 20)
          .setLabel ("Amount")
          .setRange (30,100);
          
  //////////////////////////////////
  //////   ADD UI CALLBACKS   //////
  //////////////////////////////////
  // using ControlP5 library
  // these functions allow interaction with the UI during runtime and give the UI controls their function
  
  // If toggle ON/OFF is activated, overwrite XML with set variables & set timer to timer override variable
  // if toggle ON/OFF is deactivated, reset timer to zero & let the normal process resume 
  t1.addCallback(new CallbackListener() 
  {
    public void controlEvent(CallbackEvent theEvent) 
    {
      if (theEvent.getAction()==ControlP5.ACTION_RELEASE && on_off == true) 
      {
        weatherOverride ();
        modifyWeatherData (true, weatherMode, weatherValue, weatherClouds);
        timer = timerOverride;
        displayReturnedValues ();
        logWeatherDataWriteRow();
      }
      
      if (theEvent.getAction()==ControlP5.ACTION_RELEASE && on_off == false) 
      {
        timer = 0;
      }
    }
  });
  
  // if toggle RAIN/SNOW is changed and toggle ON/OFF is activated, overwrite XML with set variables
  t2.addCallback(new CallbackListener() 
  {
    public void controlEvent(CallbackEvent theEvent) 
    {
      if (theEvent.getAction()==ControlP5.ACTION_RELEASE && on_off == true) 
      {
        weatherOverride ();
        modifyWeatherData (true, weatherMode, weatherValue, weatherClouds);
        displayReturnedValues ();
        logWeatherDataWriteRow();
      }
    }
  });
  
  // if slider VALUE is changed and toggle ON/OFF is activated, overwrite XML with set variables 
  s1.addCallback(new CallbackListener() 
  {
    public void controlEvent(CallbackEvent theEvent) 
    {
      if ((theEvent.getAction()==ControlP5.ACTION_RELEASE || theEvent.getAction()==ControlP5.ACTION_RELEASE_OUTSIDE) && on_off == true) 
      {
        weatherOverride ();
        modifyWeatherData (true, weatherMode, weatherValue, weatherClouds);
        displayReturnedValues ();
        logWeatherDataWriteRow();
      }
    }
  });
  
  // if numberbox TIMER OVERRIDE is changed and toggle ON/OFF is activated, set timer to new value
  n1.addCallback(new CallbackListener() 
  {
    public void controlEvent(CallbackEvent theEvent) 
    {
      if ((theEvent.getAction()==ControlP5.ACTION_RELEASE || theEvent.getAction()==ControlP5.ACTION_RELEASE_OUTSIDE)) 
      {
        timer = timerOverride;
      }
    }
  });
  
  ///////////////////////////////////////
  //////   RUN SCRIPT FIRST TIME   //////
  ///////////////////////////////////////
  loadWeatherIDTable();
  loadConfig ();
  logWeatherDataSetup();
  runScript ();
}

/////////////////////////////
//////   LOAD CONFIG   //////
/////////////////////////////

void loadConfig ()
{
  xmlConfig = loadXML ("config.xml");
  
  positionX = xmlConfig.getChild("imgPosition").getInt("x");
  positionY = xmlConfig.getChild("imgPosition").getInt("y");
  xmlUrl = xmlConfig.getChild("xmlWeatherData").getString("url");
  xmlWeatherDataFallback = xmlConfig.getChild("xmlWeatherDataFallback").getString("path");
  xmlSave = xmlConfig.getChild("xmlSaveLocation").getString("path"); // C:/Users/Administrator/Dropbox/Weatherdata/
  imgLoad = xmlConfig.getChild("imgLoad").getString("path");
  imgLoadFallback = xmlConfig.getChild("imgLoadFallback").getString("path"); 
}

/////////////////////////////////////
//////   RUN SCRIPT FUNCTION   //////
/////////////////////////////////////

void runScript ()
{
  if (webImg != null)
  {
    modifyWeatherData (isImgValid, weatherMode, weatherValue, weatherClouds);
  }
  else
  {
    modifyWeatherData (false, "no", 0, 0);
  }
  
  // run displayReturnedValues here after sampleImage is called and values are set
  displayReturnedValues ();
  
  // Log the weather data
  logWeatherDataWriteRow();
}

////////////////////////////////////////////////
//////    UI WEATHER OVERRIDE FUNCTION    //////
////////////////////////////////////////////////
// converts the variables set in the UI to variables used to modify the weather data XML

void weatherOverride ()
{
  // Set isOverridden boolean value
  isOverridden = true;
  
  if (rain_snow == true)
  { 
    weatherMode = "rain";
  }  
  else
  {
    weatherMode = "snow";
  }
        
  weatherValue = sliderValue;
  weatherClouds = map (sliderValue, 30, 100, 60, 100);
}

///////////////////////////////
//////   DRAW FUNCTION   //////
///////////////////////////////
// updates every frame

void draw ()
{
  // run TIMER FUNCTION
  setTimer ();
  
  // when timer runs out & weather override is OFF, reset timer & RUN SCRIPT FUNCTION
  if (timer <= 0 && on_off == false)
  {
    timer = 15;
    n1.setValue (timer);
    
    // Set isOverridden boolean value
    isOverridden = false;
    
    runScript ();
  }
}

//////////////////////////////////
//////    TIMER FUNCTION    //////
//////////////////////////////////

void setTimer ()
{
  // when the computer clock starts a new minute, decrease the timer value by 1
  if (second () == 0)
  {
    delay (2000);
    timer --;
    n1.setValue (timer);
    
    // if the weather override is ON, set it to OFF when the timer runs out
    if (timer <= 0 && on_off == true)
    {
      t1.setValue (false);
    }
  }
}

////////////////////////////////////////////////
//////    MODIFY WEATHER DATA FUNCTION    //////
////////////////////////////////////////////////
// loads the XML file from OpenWeatherMap and changes the precipitation & clouds elements to the new variables

void modifyWeatherData (boolean isImgValid, String mode, float value, float clouds)
{
  // Load XML file from OpenWeatherMap. If not valid, load xmlWeatherDataFallback
  // Try loading xmlWeatherData. 
  try {
    xmlWeatherData = loadXML(xmlUrl);
  }
  catch(Exception e) {
    print("xmlWeatherData could not be loaded");
    print("loading fallback data");
    xmlWeatherData = loadXML(xmlWeatherDataFallback);
  }
  
  LastUpdate = xmlWeatherData.getChild("lastupdate").getString("value");
  
  // If override is active, set weatherMode and weatherValue to designated values
  // If not, get weather code from XML, look it up on the table and assign corresponding weatherMode and weatherValue
  if (isOverridden == true) {
    XML xmlPrecipitation = xmlWeatherData.getChild ("precipitation");
    xmlPrecipitation.setString("mode", weatherMode);
    xmlPrecipitation.setString("value", nf(weatherValue));
  }
  else {
    // set mode of precipitation and value of precipitation
    XML xmlWeather = xmlWeatherData.getChild("weather");
    XML xmlPrecipitation = xmlWeatherData.getChild ("precipitation");
    
    weatherType = xmlWeather.getString("value");
    weatherID = int(xmlWeather.getString("number"));
    weatherMode = GetPrecipitationModeFromTable(WeatherIDTable, weatherID);
    weatherValue = float(GetValueFromTable(WeatherIDTable, weatherID));
    
    // set mode of precipitation and value of precipitation
    xmlPrecipitation.setString("mode", weatherMode);
    xmlPrecipitation.setString("value", nf(weatherValue));
  }
  // save altered XML file
  saveXML (xmlWeatherData, xmlSave);
}
