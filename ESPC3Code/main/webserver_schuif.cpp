#include <WiFi.h>
#include <WebServer.h>
#include <HTTPClient.h>
#include "webserver_schuif.h"

extern bool schuifStart;
extern int state;
bool deurIsOpen = false;
extern void deurOpen();
extern void deurDicht();

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

void handleDeurOpen() {
  Serial.println("📡 Webverzoek ontvangen: deur openen");
  deurOpen();
  server.send(200, "text/plain", "Deur geopend");
}

void handleDeurDicht() {
  Serial.println("📡 Webverzoek ontvangen: deur dichtmaken");
  deurDicht();
  server.send(200, "text/plain", "Deur dicht");
}

void handleDeurStatus() {
  String json = String("{\"deur_status\":\"") + (deurIsOpen ? "open" : "dicht") + "\"}";
  server.send(200, "application/json", json);
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
  server.on("/deur_open", handleDeurOpen);
  server.on("/deur_dicht", handleDeurDicht);
  server.on("/deur_status", handleDeurStatus);
  server.begin();
  Serial.println("🌐 Webserver gestart");
}

void checkWiFi() {
  if (WiFi.status() != WL_CONNECTED) {
    Serial.println("📶 WiFi verbroken. Probeer opnieuw te verbinden...");
    WiFi.disconnect();
    WiFi.begin(ssid, password);
    unsigned long startAttemptTime = millis();

    while (WiFi.status() != WL_CONNECTED && millis() - startAttemptTime < 10000) {
      delay(500);
      Serial.print(".");
    }

    if (WiFi.status() == WL_CONNECTED) {
      Serial.println("\n✅ Opnieuw verbonden met WiFi!");
    } else {
      Serial.println("\n❌ Kon geen verbinding maken.");
    }
  }
}

void handleWebServer() {
  server.handleClient();
}
