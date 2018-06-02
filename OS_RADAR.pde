import http.requests.*;

DConfig Config;
CWeatherDataProcessor WeatherDataProcessor;
CGUI GUI;
ControlP5 cp5;

void setup() {
  
  size (450, 450);
  fill (50);
  rect (0, 0, width, 100);

  Config = new DConfig("config.xml");
  WeatherDataProcessor = new CWeatherDataProcessor(Config);
  cp5 = new ControlP5(this);
  GUI = new CGUI(WeatherDataProcessor, cp5);
  
  GUI.Setup();
  WeatherDataProcessor.SetWeatherData();
  image (WeatherDataProcessor.Image, -(Config.positionX - 225), -(Config.positionY - 275));
  
}

void draw() {
}