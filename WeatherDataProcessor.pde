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
  color SampledPixel;

  DWeather(int _Mode, float _Value, float _Clouds, color _SampledPixel) {
    Mode = _Mode;
    Value = _Value;
    Clouds = _Clouds;
    SampledPixel = _SampledPixel;
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
  DWeather Weather = new DWeather(0,0,0, color(50,50,50));
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
  
  void ExportWeatherData()
  {
    // TODO: Check if this calls the correct file
    XML xmlWeatherData = loadXML(Config.xmlURL);
    
    if (IsImgValid == false)
    {
      XML xmlDate = xmlWeatherData.getChild("lastupdate");
      xmlDate.setString("value", "2016-01-01T00:00:00");
    }
    
    XML xmlMode = xmlWeatherData.getChild("precipitation");
    
    switch (Weather.Mode)
    {
      case 0:
        xmlMode.setString("mode", "no");
        break;
      case 1: 
        xmlMode.setString("mode", "rain");
        break;
      case 2:
        xmlMode.setString("mode", "snow");
        break;
    }
    
    if (Weather.Mode > 0)
    {
      // Set amount of precipitation
      xmlMode.setString("value", Float.toString(Weather.Value));
      
      // Check if there are enough clouds and if not, set them to calculated value
      XML xmlClouds = xmlWeatherData.getChild("clouds");
      float currentClouds = xmlClouds.getFloat("value");
      if (currentClouds < Weather.Clouds)
      {
        xmlClouds.setFloat("value", Weather.Clouds);
      }
    }
    
    saveXML(xmlWeatherData, Config.xmlSave);
  }
  
  DWeather GetOverrideWeatherData()
  {
    DWeather OverrideWeatherData;
    OverrideWeatherData = new DWeather(0,0,0, color(50,50,50));
    
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
    DWeather AnalyzedWeatherData = new DWeather(0,0,0, SamplePixel);    

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
      image (webImg, -(positionX - 225), -(positionY - 285));
      
      Image = webImg;
      SamplePixel = get (225 , 285);
      
      // Draw target indicating location of sampled pixel
      stroke(100);
      strokeWeight(3);
      line(190, 285, 260, 285); // Horizontal line
      line (225, 250, 225, 320); // Vertical line
      noFill();
      ellipse(225, 285, 50, 50);
    }
    
    return SamplePixel;
  }
  
  float GetSampleHue(color Pixel) {return hue(Pixel);}
  
  float GetSampleSaturation(color Pixel) {return saturation(Pixel);}
  
  float GetSampleBrightness(color Pixel) {return brightness(Pixel);}
  
}