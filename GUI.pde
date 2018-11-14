import controlP5.*;

class CGUI 
{
  CWeatherDataProcessor WeatherDataProcessor;
  int Timer = 15;
  
  int TimerOverride;
  float OverrideValue = 85;
  boolean Override = false;
  boolean Rain_Snow = false;
  String WeatherValueStr;
  String WeatherModeStr;
  color SampledPixelColor;
    
  ControlP5 CP5;
  Toggle ToggleOverride, ToggleOverrideType;
  Numberbox NumberBoxTimerOverride;
  Slider WeatherOverrideValue;
  
  CGUI (CWeatherDataProcessor _WeatherDataProcessor, ControlP5 _CP5)
  {
    WeatherDataProcessor = _WeatherDataProcessor;
    CP5 = _CP5;
  }
  
  void SetupGUI() 
  {
    // Setup GUI elements
    ToggleOverride = CP5.addToggle("Override")
                        .setPosition(10, 15)
                        .setSize(40, 20)
                        .setValue(false);
                        
    ToggleOverrideType = CP5.addToggle("Rain_Snow")
                            .setPosition(80, 15)
                            .setSize(40, 20)
                            .setValue(true)
                            .setMode(ControlP5.SWITCH);
                            
    NumberBoxTimerOverride = CP5.addNumberbox("TimerOverride")
                                .setPosition(160, 15)
                                .setSize(80, 20)
                                .setRange(0, 300)
                                .setLabel("Timer")
                                .setValue(Timer);
    
    WeatherOverrideValue = CP5.addSlider("OverrideValue")
                              .setPosition(10, 60)
                              .setSize(100, 20)
                              .setLabel("Amount")
                              .setRange(30, 100)
                              .setValue(60);

    // Adding UI Callbacks
    
     ToggleOverride.addCallback(new CallbackListener()
     {
       public void controlEvent(CallbackEvent theEvent)
       {
         if (theEvent.getAction()==ControlP5.ACTION_RELEASE && Override == true)
         {
           WeatherDataProcessor.IsOverridden = true;
           SetOverrideWeatherData();
           Timer = TimerOverride;
         }
         
         if (theEvent.getAction()==ControlP5.ACTION_RELEASE && Override == false)
         {
           Timer = 0;
           WeatherDataProcessor.IsOverridden = false;
         }
       }
     });
     
     ToggleOverrideType.addCallback(new CallbackListener() 
     {
       public void controlEvent(CallbackEvent theEvent)
       {
         if (theEvent.getAction()==ControlP5.ACTION_RELEASE && Override == true)
         {
           SetOverrideWeatherData();
         }
       }
     });
     
     WeatherOverrideValue.addCallback(new CallbackListener()
     {
       public void controlEvent(CallbackEvent theEvent)
       {
         if((theEvent.getAction()==ControlP5.ACTION_RELEASE || theEvent.getAction()==ControlP5.ACTION_RELEASE_OUTSIDE) && Override == true)
         {
           SetOverrideWeatherData();
         }
       }
     });

     
     NumberBoxTimerOverride.addCallback(new CallbackListener()
	   {
		 public void controlEvent(CallbackEvent theEvent)
		 {
			if ((theEvent.getAction()==ControlP5.ACTION_RELEASE || theEvent.getAction()==ControlP5.ACTION_RELEASE_OUTSIDE))
			{
				Timer = TimerOverride;
			}
		 }
	 });

  }
  
  void DisplayValues()
  {
    fill (50);
    noStroke();
    rect(260, 10, 360, 35);
    
    fill(255);
    
    // Display the WeatherValue
    WeatherValueStr = nf(WeatherDataProcessor.Weather.Value);
    text(WeatherValueStr, 260, 10, 30, 20);
    text("WeatherValue", 260, 35);
    
    // Display the WeatherMode
    if (WeatherDataProcessor.Weather.Mode == 1)
    {
      WeatherModeStr = "Rain";
    }
    else if (WeatherDataProcessor.Weather.Mode == 2)
    {
      WeatherModeStr = "Snow";
    }
    else
    {
      WeatherModeStr = "None";
    }
    
    text(WeatherModeStr, 360, 10, 40, 20);
    text("WeatherMode", 360, 35);
    
    // Display the sampled pixel
    SampledPixelColor = WeatherDataProcessor.Weather.SampledPixel;
    fill(SampledPixelColor);
    rect(400, 50, 40, 40);
  }
  
  void SetOverrideWeatherData()
  {
    Override = true;
    
    if (Rain_Snow == true)
    {
      WeatherDataProcessor.OverrideWeatherMode = 1;
    }
    else
    {
      WeatherDataProcessor.OverrideWeatherMode = 2;
    }
    
    WeatherDataProcessor.OverrideWeatherValue = OverrideValue;
    WeatherDataProcessor.Weather.Clouds = map(OverrideValue, 30, 100, 60, 100);
    
    WeatherDataProcessor.SetWeatherData();
  }
  
}