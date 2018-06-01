import org.apache.http.StatusLine;
import org.apache.http.Header;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.auth.UsernamePasswordCredentials;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.auth.BasicScheme;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;

// This contains a collection of classes which are responsible for
// pulling in the data from the external source, processing it and 
// outputting it.

// Config takes in a URL string
// and loads the configuration 
// Effectively it'll be a container for the data without any methods.

class CConfig {
  
  String xmlLocation;
  XML xmlConfig;
  int positionX, positionY;
  String xmlURL;
  String xmlSave;
  String imgLoad;
  
  // Constructor
  CConfig(String _xmlLocation) {
    xmlLocation = _xmlLocation;
    xmlConfig = loadXML(xmlLocation);
    positionX = xmlConfig.getChild("imgPosition").getInt("x");
    positionY = xmlConfig.getChild("imgPosition").getInt("y");
    xmlURL = xmlConfig.getChild("xmlWeatherData").getString("url");
    xmlSave = xmlConfig.getChild("xmlSaveLocation").getString("path"); // C:/Users/Administrator/Dropbox/Weatherdata/
    imgLoad = xmlConfig.getChild("imgLoad").getString("path");
  }

}

// InputWeatherData will pull in the data from the external source 
// and convert it to variables that will be used in OS_Radar
// Theoretically only the InputWeatherData object will modify these values
// The rest of the program will only read these
// Arguments it will take:
// Config class 

// Object variables:
// boolean isValid - Is the source valid
// 
// 
// Functions to be implemented
// QueryWeatherData - Query from external source and assign it to variables
// RefreshWeatherData 

class CInputWeatherData {
  CConfig Config;
  boolean isURLValid;
  
  // Constructor
  CInputWeatherData(CConfig _Config) {
    Config = _Config;
  } 
}

class CWeatherDataProcessor 
{
  // Input variables
  CConfig Config;
  
  // Output variables
  boolean IsImgValid;
  int WeatherMode;
  float WeatherValue;
  float WeatherClouds;
  
  // Constructor
  CWeatherDataProcessor(CConfig _Config) 
  {
    Config = _Config;
  }
    
  void AnalyzePixel()
  {
    color SamplePixel = GetSamplePixel();;
    float SampleHue = GetSampleHue(SamplePixel);
    float SampleSaturation = GetSampleSaturation(SamplePixel);
    float SampleBrightness = GetSampleBrightness(SamplePixel);

    // black screenshot, so set XML date way back
    if (SampleBrightness < 25)
    {
      IsImgValid = false;
      return;
    }
    
    // no precipitation
    if (SampleSaturation < 50)
    {
       WeatherMode = 0;
       WeatherValue = 0;
       return;
    }
     
    // rain
    if (SampleHue <= 120)
    {
       WeatherMode = 1;
       
       if (SampleHue >= 80)
       {
         SampleBrightness = constrain (SampleBrightness, 114, 205);
         WeatherValue = map (SampleBrightness, 114, 205, 50, 30);
         WeatherClouds = map (SampleBrightness, 114, 205, 75, 60);
         return;
       }
       
       if (SampleHue < 80)
       {
         SampleHue = constrain (SampleHue, 0, 60);
         WeatherValue = map (SampleHue, 0, 60, 70, 51);
         WeatherClouds = map (SampleHue, 0, 60, 90, 76);
         return;
       }
    }
    
    if (SampleHue >= 200)
    {
      WeatherMode = 1;
      
      WeatherValue = 70;
      WeatherClouds = 90;
      return;
    }
  
    // snow
    if (SampleHue > 120 && SampleHue < 200)
    {
      WeatherMode = 2;
      
      SampleBrightness = constrain (SampleBrightness, 80, 245);
      WeatherValue = map (SampleBrightness, 80, 245, 100, 30);
      WeatherClouds = map (SampleBrightness, 80, 245, 100, 60);
      return;
    }
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
      image (webImg, -(positionX - 200), -(positionY - 220));
      SamplePixel = get (200 , 220);
    }
    
    return SamplePixel;
  }
  
  float GetSampleHue(color Pixel) {return hue(Pixel);}
  
  float GetSampleSaturation(color Pixel) {return saturation(Pixel);}
  
  float GetSampleBrightness(color Pixel) {return brightness(Pixel);}
  
}