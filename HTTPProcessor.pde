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

class HTTPProcessor {
  
  String URL;
  
  HTTPProcessor(String _URL) {
    URL = _URL;
  }
  
  
  int GetURLReturnCode() {
        
    HttpResponse Response;
    DefaultHttpClient httpClient = new DefaultHttpClient();
    HttpGet httpGet = new HttpGet(URL);
    
    Response = httpClient.execute(httpGet);
    
    StatusLine ResponseStatusLine = Response.getStatusLine();
    
    return ResponseStatusLine.getStatusCode();
  }
  
}