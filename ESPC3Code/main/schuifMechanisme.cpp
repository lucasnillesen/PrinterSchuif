#include <TMCStepper.h>
#include <AccelStepper.h>
#include "schuifMechanisme.h"
#include "webserver_schuif.h"
#include <ESP32Servo.h>

Servo deurslot;
const int deurPin = 5;
const int DEUR_OPEN = 140;
const int DEUR_DICHT = 10;

extern bool deurIsOpen;

// Y-as (hoogte)
#define STEP_PIN_Y 10
#define DIR_PIN_Y 2

// X-as (schuif)
#define STEP_PIN_X 4
#define DIR_PIN_X 3

// Overig
#define RX_PIN 6
#define TX_PIN 7
#define EN_PIN 4
#define LIMIT_SWITCH_X_PIN 0
#define LIMIT_SWITCH_Y_PIN 1
#define R_SENSE 0.11f
#define DRIVER_ADDRESS_Y 0b00
#define DRIVER_ADDRESS_X 0b01

HardwareSerial SerialPort(1);
TMC2209Stepper driverY(&SerialPort, R_SENSE, DRIVER_ADDRESS_Y);
TMC2209Stepper driverX(&SerialPort, R_SENSE, DRIVER_ADDRESS_X);
AccelStepper stepperY(AccelStepper::DRIVER, STEP_PIN_Y, DIR_PIN_Y);
AccelStepper stepperX(AccelStepper::DRIVER, STEP_PIN_X, DIR_PIN_X);

// Gemiddelde berekening over 10 metingen
const int SG_BUFFER_SIZE = 10;
uint16_t sgYBuffer[SG_BUFFER_SIZE] = { 0 };
int sgYIndex = 0;
uint16_t sgXBuffer[SG_BUFFER_SIZE] = { 0 };
int sgXIndex = 0;

uint16_t getAverageY() {
  uint32_t sum = 0;
  for (int i = 0; i < SG_BUFFER_SIZE; i++) sum += sgYBuffer[i];
  return sum / SG_BUFFER_SIZE;
}

uint16_t getAverageX() {
  uint32_t sum = 0;
  for (int i = 0; i < SG_BUFFER_SIZE; i++) sum += sgXBuffer[i];
  return sum / SG_BUFFER_SIZE;
}

void resetSGBuffer() {
  for (int i = 0; i < SG_BUFFER_SIZE; i++) {
    sgYBuffer[i] = 0;
    sgXBuffer[i] = 0;
  }
  sgYIndex = 0;
  sgXIndex = 0;
}

enum Fase { BEGIN,
            OMHOOG,
            IN,
            OMLAAG,
            UIT,
            TERUG,
            WACHTEN };
Fase fase;
unsigned long motionStart = 0;
bool impactMonitoringY = false;
bool impactMonitoringX = false;
bool schuifVastgemeld = false;

void initSchuifMechanisme() {
  Serial.begin(115200);
  Serial.println("== TMC2209 SG-detectie: omhoog en omlaag op drempelwaarden ==");

  deurslot.attach(deurPin);
  deurslot.write(DEUR_DICHT);

  pinMode(EN_PIN, OUTPUT);
  digitalWrite(EN_PIN, LOW);
  pinMode(LIMIT_SWITCH_X_PIN, INPUT_PULLUP);
  pinMode(LIMIT_SWITCH_Y_PIN, INPUT_PULLUP);

  SerialPort.begin(115200, SERIAL_8N1, RX_PIN, TX_PIN);
  delay(1000);

  driverY.begin();
  delay(100);
  driverY.pdn_disable(true);
  driverY.mstep_reg_select(true);
  driverY.I_scale_analog(false);
  driverY.GCONF(driverY.GCONF() & ~(1 << 2));
  driverY.en_spreadCycle(true);

  driverX.begin();
  delay(100);
  driverX.pdn_disable(true);
  driverX.mstep_reg_select(true);
  driverX.I_scale_analog(false);
  driverX.GCONF(driverX.GCONF() & ~(1 << 2));
  driverX.en_spreadCycle(true);

  driverY.rms_current(800);
  driverY.microsteps(16);
  driverY.toff(5);
  driverY.tbl(1);
  driverY.hstrt(3);
  driverY.hend(0);
  driverY.pwm_autoscale(false);
  driverY.TCOOLTHRS(0xFFFF);
  driverY.SGTHRS(1);

  driverX.rms_current(800);
  driverX.microsteps(16);
  driverX.toff(5);
  driverX.tbl(1);
  driverX.hstrt(3);
  driverX.hend(0);
  driverX.pwm_autoscale(false);
  driverX.TCOOLTHRS(0xFFFF);
  driverX.SGTHRS(1);

  Serial.println("⏳ Wachten voor tweede init...");
  delay(2000);

  driverY.begin();
  driverX.begin();
  driverY.en_spreadCycle(true);
  driverX.en_spreadCycle(true);
  driverY.GCONF(driverY.GCONF() & ~(1 << 2));
  driverX.GCONF(driverX.GCONF() & ~(1 << 2));

  Serial.println("✅ Setup compleet");

  stepperY.setMaxSpeed(1000);
  stepperX.setMaxSpeed(1000);
  stepperY.setAcceleration(2000);
  stepperX.setAcceleration(2000);

  stepperY.moveTo(-1000000);  // Start omhoog
  fase = BEGIN;
  motionStart = millis();
  resetSGBuffer();
}

void schuifMechanisme() {
  stepperY.run();
  stepperX.run();

  static unsigned long lastPrint = 0;
  if (millis() - lastPrint > 50) {
    uint16_t sgY = driverY.SG_RESULT();
    uint16_t sgX = driverX.SG_RESULT();
    sgYBuffer[sgYIndex] = sgY;
    sgXBuffer[sgXIndex] = sgX;
    sgYIndex = (sgYIndex + 1) % SG_BUFFER_SIZE;
    sgXIndex = (sgXIndex + 1) % SG_BUFFER_SIZE;
    uint16_t avgY = getAverageY();
    uint16_t avgX = getAverageX();

    Serial.print("SG Y avg: ");
    Serial.println(avgY);
    Serial.print("SG X avg: ");
    Serial.println(avgX);
    lastPrint = millis();

    switch (fase) {
      case BEGIN:
        Serial.println("Wachten voor tweede init...");
        delay(2000);
        Serial.println("Setup compleet");

        deurslot.write(DEUR_OPEN);
        deurIsOpen = true;
        delay(500);

        stepperY.setMaxSpeed(10000);
        stepperX.setMaxSpeed(10000);
        stepperY.setAcceleration(2000);
        stepperX.setAcceleration(2000);


        stepperY.moveTo(-1000000);  // Start omhoog

        motionStart = millis();
        resetSGBuffer();
        fase = OMHOOG;
        break;

      case OMHOOG:
        static bool bezig = false;
        if (!bezig) {
          schuifStarted();
          bezig = true;
        }
        if (!impactMonitoringY && millis() - motionStart > 10000) {
          impactMonitoringY = true;
          Serial.println("[Y] SG-monitor actief.");
        }
        if (impactMonitoringY && avgY < 100) {
          Serial.println("Bovenstop bereikt. Beweeg schuif naar binnen");
          stepperY.stop();
          stepperY.setCurrentPosition(stepperY.currentPosition());
          delay(200);
          resetSGBuffer();
          stepperX.setMaxSpeed(10000);
          stepperX.moveTo(-1000000);
          fase = IN;
          motionStart = millis();
          impactMonitoringX = false;
        }
        break;

      case IN:
        if (!impactMonitoringX && millis() - motionStart > 3000) {
          impactMonitoringX = true;
          Serial.println("[X] SG-monitor actief (naar binnen).");
        }
        if (impactMonitoringX && avgX < 90) {
          Serial.println("Printbed bereikt. Beweeg Y naar beneden.");
          stepperX.stop();
          stepperX.setCurrentPosition(stepperX.currentPosition());
          delay(200);

          driverY.rms_current(500);
          stepperY.setMaxSpeed(10000);
          stepperY.moveTo(100000);
          resetSGBuffer();
          fase = OMLAAG;
          motionStart = millis();
          impactMonitoringY = false;
        }
        break;

      case OMLAAG:
        if (!impactMonitoringY && millis() - motionStart > 3000) {
          impactMonitoringY = true;
          Serial.println("[Y] Impactdetectie actief tijdens omlaag.");
        }

        if (impactMonitoringY && avgY < 150) {
          Serial.println("Printbed geraakt. Verifiëren...");

          // Impact detectie, nu eerst extra verificatie
          stepperY.stop();
          stepperY.setCurrentPosition(stepperY.currentPosition());
          delay(150);  // kleine rust

          // ➕ Extra terugduw en SG controle
          const int terugStappen = 1000;
          const int sgThreshold = 150;
          const int stabilisatieDelay = 150;
          const int numSamples = 5;

          long terug = stepperY.currentPosition() + terugStappen;
          stepperY.moveTo(terug);
          while (stepperY.distanceToGo() != 0) stepperY.run();

          delay(stabilisatieDelay);

          int totaalSG = 0;
          for (int i = 0; i < numSamples; i++) {
            totaalSG += driverY.SG_RESULT();
            delay(20);
          }
          int gemiddeldeSG = totaalSG / numSamples;

          Serial.print("Gemiddelde SG na verificatie: ");
          Serial.println(gemiddeldeSG);

          // Terug naar originele positie
          stepperY.moveTo(terug - terugStappen);
          while (stepperY.distanceToGo() != 0) stepperY.run();
          delay(50);

          // Alleen doorgaan als nog steeds laag
          if (gemiddeldeSG < sgThreshold) {
            Serial.println("✅ Verificatie bevestigt impact. Halve draai terug omhoog.");
            long halveRotatie = 3500;
            stepperY.moveTo(stepperY.currentPosition() - halveRotatie);
            while (stepperY.distanceToGo() != 0) {
              stepperY.run();
            }
            driverX.rms_current(1500);
            stepperX.moveTo(100000);
            resetSGBuffer();
            motionStart = millis();
            fase = UIT;
          } else {
            Serial.println("❌ Geen bevestiging van impact. Verder omlaag...");
            // Blijf in OMLAAG, dus niks aan fase veranderen
          }
        }
        break;


      case UIT:
        {
          static int lageWaardeCount = 0;
          bool switchXActief = digitalRead(LIMIT_SWITCH_X_PIN) == HIGH;

          if (!switchXActief && millis() - motionStart > 3000) {
            if (stepperX.distanceToGo() == 0) {
              Serial.println("↩️ Schuif beweegt niet, maar limit switch nog niet geraakt. Opnieuw proberen...");
              stepperX.moveTo(stepperX.currentPosition() - 10000);
            }

            if (avgX < 80) {
              lageWaardeCount++;
              if (lageWaardeCount >= 150 && !schuifVastgemeld) {
                Serial.println("⚠️ Waarschuwing: schuif vast tijdens terugtrekken!");
                schuifKlaarMelden(false);
                schuifVastgemeld = true;
              }
            } else {
              lageWaardeCount = 0;
            }
          }

          if (switchXActief) {
            Serial.println("✅ Limit switch geraakt. Schuif nu terug.");
            stepperX.stop();
            stepperX.setCurrentPosition(stepperX.currentPosition());
            driverY.rms_current(500);
            stepperY.setMaxSpeed(1200);
            stepperY.moveTo(100000);
            resetSGBuffer();
            fase = TERUG;
            motionStart = millis();
            impactMonitoringY = false;
          }

          break;
        }
      case TERUG:
        {
          bool switchYActief = digitalRead(LIMIT_SWITCH_Y_PIN) == HIGH;
          if (switchYActief) {
            Serial.println("Schuif is terug");
            stepperY.stop();
            stepperY.setCurrentPosition(stepperY.currentPosition());
            delay(200);
            deurslot.write(DEUR_DICHT);
            deurIsOpen = false;
            delay(500);
            schuifKlaarMelden(true);
            bezig = false;
            schuifVastgemeld = false;
            impactMonitoringY = false;
            impactMonitoringX = false;
            schuifStart = false;
            resetSGBuffer();
            fase = BEGIN;
            motionStart = millis();
          }
          break;
        }
    }
  }
}

void deurOpen() {
  deurslot.write(DEUR_OPEN);
  deurIsOpen = true;
  delay(500);
}

void deurDicht() {
  deurslot.write(DEUR_DICHT);
  deurIsOpen = false;
  delay(500);
}