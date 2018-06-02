import http.requests.*;

void setup() {
  DConfig Config;
  CWeatherDataProcessor WeatherDataProcessor;
  
  Config = new DConfig("config.xml");

  WeatherDataProcessor = new CWeatherDataProcessor(Config);
  WeatherDataProcessor.GetAnalyzedWeatherData();
  
  WeatherDataProcessor.SetWeatherData();
  println(WeatherDataProcessor.Weather.Mode);
  println(WeatherDataProcessor.Weather.Value);
  println(WeatherDataProcessor.Weather.Clouds);
    
  WeatherDataProcessor.IsOverridden = true;
  WeatherDataProcessor.OverrideWeatherMode = 50;
  WeatherDataProcessor.OverrideWeatherValue = 1;
  
  WeatherDataProcessor.SetWeatherData();
  println(WeatherDataProcessor.Weather.Mode);
  println(WeatherDataProcessor.Weather.Value);
  println(WeatherDataProcessor.Weather.Clouds);
  
}

void draw() {
}