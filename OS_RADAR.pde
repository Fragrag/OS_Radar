// Initializing global variables
int timer = 15;

// Initializing instances
DConfig Config;
CWeatherDataProcessor WeatherDataProcessor;
CGUI GUI;
ControlP5 cp5;

void setup() 
{
  size (450, 450);
  fill (50);
  rect (0, 0, width, 100);

  // Starting instances
  Config = new DConfig("config.xml");
  WeatherDataProcessor = new CWeatherDataProcessor(Config);
  cp5 = new ControlP5(this);
  GUI = new CGUI(WeatherDataProcessor, cp5);
  
  GUI.SetupGUI();
  RefreshWeatherData();
  
  println(GUI.WeatherModeStr);
  
}

void draw() 
{
  SetTimer();
  
  if (timer <= 0 && GUI.Override == false)
  {
    timer = 15;
    GUI.NumberBoxTimerOverride.setValue(timer);
    WeatherDataProcessor.IsOverridden = false;
    
    RefreshWeatherData();
  }
}

void SetTimer() 
{
  if (second() == 0)
  {
    delay(2000);
    timer --;
    GUI.NumberBoxTimerOverride.setValue(timer);
    
    if (timer <= 0 && GUI.Override == true)
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