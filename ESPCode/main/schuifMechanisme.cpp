#include <WiFi.h>
#include <WebServer.h>
#include <HTTPClient.h>
#include "webserver_schuif.h"

extern bool schuifStart;
extern int state;

const char* ssid = "robert";
const char* password = "dakterras1234";

// Vervang dit IP-adres door dat van jouw Flask webinterface!
const char* webserver_ip = "192.168.178.34";

WebServer server(80);

void handleSchuif() {
  Serial.println("📡 Webverzoek ontvangen: schuif activeren");
  schuifStart = true;
  state = 0;
  server.send(200, "text/plain", "Schuif geactiveerd via WiFi");
}

void schuifStarted() {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    String url = String("http://") + webserver_ip + ":5000/schuif_feedback";
    http.begin(url);
    http.addHeader("Content-Type", "application/json");

    String jsonPayload = "{\"status\":\"gestart\"}";
    int httpResponseCode = http.POST(jsonPayload);

    if (httpResponseCode > 0) {
      Serial.printf("📨 Startmelding verstuurd: %d\n", httpResponseCode);
    } else {
      Serial.printf("❌ Startmelding mislukt: %s\n", http.errorToString(httpResponseCode).c_str());
    }
    http.end();
  } else {
    Serial.println("❌ Niet verbonden met WiFi — geen startmelding mogelijk");
  }
}


void schuifKlaarMelden(bool success) {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    String url = String("http://") + webserver_ip + ":5000/schuif_feedback";
    http.begin(url);
    http.addHeader("Content-Type", "application/json");

    // Alleen status meesturen — geen serial
    String jsonPayload = String("{\"status\":\"") + (success ? "klaar" : "vast") + "\"}";
    int httpResponseCode = http.POST(jsonPayload);

    if (httpResponseCode > 0) {
      Serial.printf("📨 Terugmelding verstuurd (%s): %d\n", success ? "done" : "error", httpResponseCode);
    } else {
      Serial.printf("❌ Terugmelding mislukt: %s\n", http.errorToString(httpResponseCode).c_str());
    }
    http.end();
  } else {
    Serial.println("❌ Niet verbonden met WiFi — geen terugmelding mogelijk");
  }
}

void setupWebServer() {
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);
  Serial.print("🔌 Verbinden met WiFi");

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("\n✅ WiFi verbonden");
  Serial.print("📶 IP-adres: ");
  Serial.println(WiFi.localIP());

  server.on("/push", handleSchuif);
  server.begin();
  Serial.println("🌐 Webserver gestart");
}

void handleWebServer() {
  server.handleClient();
}
