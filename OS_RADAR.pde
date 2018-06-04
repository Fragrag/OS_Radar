// Initializing global variables

// Initializing instances
DConfig Config;
CWeatherDataProcessor WeatherDataProcessor;
CGUI GUI;
ControlP5 CP5;

void setup() 
{
  size (450, 450);
  fill (50);
  rect (0, 0, width, 100);

  // Starting instances
  Config = new DConfig("config.xml");
  WeatherDataProcessor = new CWeatherDataProcessor(Config, GUI);
  CP5 = new ControlP5(this);
  GUI = new CGUI(WeatherDataProcessor, CP5);
  
  GUI.SetupGUI();
  RefreshWeatherData();
  
}

void draw() 
{
  SetTimer();
  
  if (GUI.Timer <= 0 && GUI.Override == false)
  {
    GUI.Timer = 15;
    GUI.NumberBoxTimerOverride.setValue(GUI.Timer);
    WeatherDataProcessor.IsOverridden = false;
    
    RefreshWeatherData();
  }
  
}

void SetTimer() 
{
  if (second() == 0)
  {
    delay(2000);
    GUI.Timer --;
    GUI.NumberBoxTimerOverride.setValue(GUI.Timer);
    
    if (GUI.Timer <= 0 && GUI.Override == true)
    {
      GUI.ToggleOverride.setValue(false);
    }
  }
}

void RefreshWeatherData()
{
  WeatherDataProcessor.SetWeatherData();
  GUI.DisplayValues();
  WeatherDataProcessor.ExportWeatherData();
}