import http.requests.*;

void setup() {
  CConfig Config;
  CInputWeatherData InputWeatherData;
  
  Config = new CConfig("config.xml");
  InputWeatherData = new CInputWeatherData(Config);
  println(InputWeatherData.GetURLContent());
  println(InputWeatherData.GetURLReturnCode());
  
}

void draw() {
}