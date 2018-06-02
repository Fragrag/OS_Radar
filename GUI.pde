import controlP5.*;

class CGUI 
{
  CWeatherDataProcessor WeatherDataProcessor;
  public int timer;
  int TimerOverride;
  boolean Override = false;
  boolean Rain_Snow = false;
  String WeatherValueStr, WeatherModeStr;
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
    timer = 15;
    
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
                       .setValue(timer);
    
    WeatherOverrideValue = CP5.addSlider("sliderValue")
                              .setPosition(10, 60)
                              .setSize(100, 20)
                              .setLabel("Amount")
                              .setRange(30, 100);

    // Adding UI Callbacks
    
     ToggleOverride.addCallback(new CallbackListener()
     {
       public void controlEvent(CallbackEvent theEvent)
       {
         if (theEvent.getAction()==ControlP5.ACTION_RELEASE && Override == true)
         {
           WeatherDataProcessor.IsOverridden = true;
           WeatherDataProcessor.SetWeatherData();
           timer = TimerOverride;
         }
         
         if (theEvent.getAction()==ControlP5.ACTION_RELEASE && Override == false)
         {
           WeatherDataProcessor.IsOverridden = false;
           timer = 0;
         }
       }
     });
     
     ToggleOverrideType.addCallback(new CallbackListener() 
     {
       public void controlEvent(CallbackEvent theEvent)
       {
         if (theEvent.getAction()==ControlP5.ACTION_RELEASE && Override == true)
         {
           WeatherDataProcessor.IsOverridden = true; //Might be unneccesary due to this action already done by ToggleOverride
           WeatherDataProcessor.SetWeatherData();
         }
       }
     });
     
     NumberBoxTimerOverride.addCallback(new CallbackListener()
	 {
		 public void controlEvent(CallbackEvent theEvent)
		 {
			if ((theEvent.getAction()==ControlP5.ACTION_RELEASE || theEvent.getAction()==ControlP5.ACTION_RELEASE_OUTSIDE))
			{
				timer = TimerOverride;
			}
		 }
	 });
  }
  
  void DisplayValues()
  {
    fill (50);
    noStroke();
    rect(160, 50, 160, 40);
    
    fill(255);
    
    // Display the WeatherValue
    WeatherValueStr = nf(WeatherDataProcessor.Weather.Value);
    text(WeatherValueStr, 160, 60, 30, 20);
    text("WeatherValue", 160, 85);
    
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
    
    text(WeatherModeStr, 240, 60, 40, 20);
    text("WeatherMode", 240, 85);
    
    // Display the sampled pixel
    SampledPixelColor = WeatherDataProcessor.Weather.SampledPixel;
    fill(SampledPixelColor);
    rect(350, 15, 70, 70);
  }
  
}