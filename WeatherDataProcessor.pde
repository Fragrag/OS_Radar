// This contains a collection of classes which are responsible for
// pulling in the data from the external source, processing it and 
// outputting it.

// Data Class DConfig
class DConfig {  
  String xmlLocation;
  XML xmlConfig;
  int positionX, positionY;
  String xmlURL;
  String xmlSave;
  String imgLoad;
  
  // Constructor
  DConfig(String _xmlLocation) {
    xmlLocation = _xmlLocation;
    xmlConfig = loadXML(xmlLocation);
    positionX = xmlConfig.getChild("imgPosition").getInt("x");
    positionY = xmlConfig.getChild("imgPosition").getInt("y");
    xmlURL = xmlConfig.getChild("xmlWeatherData").getString("url");
    xmlSave = xmlConfig.getChild("xmlSaveLocation").getString("path"); // C:/Users/Administrator/Dropbox/Weatherdata/
    imgLoad = xmlConfig.getChild("imgLoad").getString("path");
  }

}

// Data Class DWeather
class DWeather {
  int Mode;
  float Value;
  float Clouds;

  DWeather(int _Mode, float _Value, float _Clouds) {
    Mode = _Mode;
    Value = _Value;
    Clouds = _Clouds;
  }
}


class CWeatherDataProcessor 
{
  // Input variables
  DConfig Config;
  
  // Local variables
  boolean IsOverridden = false;
  int OverrideWeatherMode;
  float OverrideWeatherValue;
  PImage Image;
  
  // Output variables
  boolean IsImgValid;
  DWeather Weather = new DWeather(0,0,0);
  int WeatherMode;
  
  // Constructor
  CWeatherDataProcessor(DConfig _Config) 
  {
    Config = _Config;
  }
  
  void SetWeatherData() {
   if (IsOverridden == true) 
   {
     Weather = GetOverrideWeatherData();
   }
   else
   {
     Weather = GetAnalyzedWeatherData();
   }
  }
  
  DWeather GetOverrideWeatherData()
  {
    DWeather OverrideWeatherData;
    OverrideWeatherData = new DWeather(0,0,0);
    
    OverrideWeatherData.Mode = OverrideWeatherMode;
    OverrideWeatherData.Value = OverrideWeatherValue;
    OverrideWeatherData.Clouds = 80;
    
    return OverrideWeatherData;
  }
  
  DWeather GetAnalyzedWeatherData()
  {
    color SamplePixel = GetSamplePixel();
    float SampleHue = GetSampleHue(SamplePixel);
    float SampleSaturation = GetSampleSaturation(SamplePixel);
    float SampleBrightness = GetSampleBrightness(SamplePixel);
    DWeather AnalyzedWeatherData;
    AnalyzedWeatherData = new DWeather(0,0,0);
    

    // black screenshot, so set XML date way back
    if (SampleBrightness < 25)
    {
      IsImgValid = false;
      return AnalyzedWeatherData;
    }
    
    // no precipitation
    if (SampleSaturation < 50)
    {
       AnalyzedWeatherData.Mode = 0;
       AnalyzedWeatherData.Value = 0;
       return AnalyzedWeatherData;
    }
     
    // rain
    if (SampleHue <= 120)
    {
       AnalyzedWeatherData.Mode = 1;
       
       if (SampleHue >= 80)
       {
         SampleBrightness = constrain (SampleBrightness, 114, 205);
         AnalyzedWeatherData.Value = map (SampleBrightness, 114, 205, 50, 30);
         AnalyzedWeatherData.Clouds = map (SampleBrightness, 114, 205, 75, 60);
         return AnalyzedWeatherData;
       }
       
       if (SampleHue < 80)
       {
         SampleHue = constrain (SampleHue, 0, 60);
         AnalyzedWeatherData.Value = map (SampleHue, 0, 60, 70, 51);
         AnalyzedWeatherData.Clouds = map (SampleHue, 0, 60, 90, 76);
         return AnalyzedWeatherData;
       }
    }
    
    if (SampleHue >= 200)
    {
      AnalyzedWeatherData.Mode = 1;
      
      AnalyzedWeatherData.Value = 70;
      AnalyzedWeatherData.Clouds = 90;
      return AnalyzedWeatherData;
    }
  
    // snow
    if (SampleHue > 120 && SampleHue < 200)
    {
      AnalyzedWeatherData.Mode = 2;
      
      SampleBrightness = constrain (SampleBrightness, 80, 245);
      AnalyzedWeatherData.Value = map (SampleBrightness, 80, 245, 100, 30);
      AnalyzedWeatherData.Clouds = map (SampleBrightness, 80, 245, 100, 60);
      return AnalyzedWeatherData;
    }
    
    // If nothing of the above triggers, return the previous Weather settings
    return Weather;
  }
  
  // TODO: Create void RefreshImage()
  
  color GetSamplePixel() 
  {
    PImage webImg = null;
    color SamplePixel = color(0,0,0);
    int positionX = Config.positionX;
    int positionY = Config.positionY;
    
    try 
    {
      webImg = loadImage (Config.imgLoad, "png");
    }
    catch (Exception e) 
    {
      IsImgValid = false;
      print ("Image could not be loaded");
    }
    
    if (webImg != null) 
    {
      IsImgValid = true;
      //image (webImg, -(positionX - 200), -(positionY - 220));
      Image = webImg;
      SamplePixel = get (200 , 220);
    }
    
    return SamplePixel;
  }
  
  float GetSampleHue(color Pixel) {return hue(Pixel);}
  
  float GetSampleSaturation(color Pixel) {return saturation(Pixel);}
  
  float GetSampleBrightness(color Pixel) {return brightness(Pixel);}
  
}