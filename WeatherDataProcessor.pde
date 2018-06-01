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

// Config will contain the settings

class CConfig {
  
  String xmlLocation;
  XML xmlConfig;
  int positionX, positionY;
  String xmlURL;
  String xmlSave;
  String imgLoad;
  String CurrentweatherMode;
  
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
  boolean isURLValid;
  CConfig Config;
  
  CInputWeatherData(CConfig _Config) {
    Config = _Config;
    
  }
  
  int GetURLReturnCode() {
    HttpGet httpGet;
    HttpResponse Response;
    DefaultHttpClient httpClient = new DefaultHttpClient();
    
    httpGet = new HttpGet(Config.xmlURL);
    Response = httpClient.execute(httpGet);
    
    StatusLine ResponseStatusLine = Response.getStatusLine();
    
    return ResponseStatusLine.getStatusCode();
  }
  
  String GetURLContent() {
    GetRequest CheckURL = new GetRequest(Config.xmlURL);
    CheckURL.send();
    println("Response Status Header: " + CheckURL.getContent());
    
    return CheckURL.getContent();
  }
}