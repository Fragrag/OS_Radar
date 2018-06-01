import http.requests.*;

void setup() {
  CConfig Config;
  CInputWeatherData InputWeatherData;
  CWeatherDataProcessor WeatherDataProcessor;
  
  Config = new CConfig("config.xml");
  InputWeatherData = new CInputWeatherData(Config);
  WeatherDataProcessor = new CWeatherDataProcessor(Config);
  WeatherDataProcessor.AnalyzePixel();
  
  println(WeatherDataProcessor.WeatherMode);
  println(WeatherDataProcessor.WeatherValue);
  println(WeatherDataProcessor.WeatherClouds);
  
}

void draw() {
}