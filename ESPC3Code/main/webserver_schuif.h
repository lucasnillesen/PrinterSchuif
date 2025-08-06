#ifndef WEBSERVER_SCHUIF_H
#define WEBSERVER_SCHUIF_H

void setupWebServer();
void handleWebServer();
void handleSchuif();
void handleDeurDicht();
void handleDeurOpen();
void handleDeurStatus();
void checkWiFi();
void schuifKlaarMelden(bool success);
void schuifStarted();

#endif