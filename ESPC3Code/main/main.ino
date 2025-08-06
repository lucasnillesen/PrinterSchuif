#include "webserver_schuif.h"
#include "schuifMechanisme.h"
#include <TMCStepper.h>
#include <AccelStepper.h>

bool schuifStart = false;
int state = 0;


void setup() {
  Serial.begin(115200);
  setupWebServer();
  initSchuifMechanisme();
}

void loop() {
  handleWebServer();
  checkWiFi();

  if (schuifStart) {
    schuifMechanisme();
  }
}