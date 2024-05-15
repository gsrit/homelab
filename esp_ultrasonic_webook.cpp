#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>

const char* ssid = "your_SSID";
const char* password = "your_PASSWORD";
const char* slackWebhookUrl = "https://hooks.slack.com/services/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";

const int trigPin = 5;  // D1
const int echoPin = 4;  // D2

unsigned long previousMillis = 0;
const long interval = 10000;  // Interval to send data (milliseconds)

void setup() {
  Serial.begin(115200);
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);

  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }
  Serial.println("Connected to WiFi");
}

void loop() {
  unsigned long currentMillis = millis();

  if (currentMillis - previousMillis >= interval) {
    previousMillis = currentMillis;

    long duration, distance;

    // Clear the trigPin
    digitalWrite(trigPin, LOW);
    delayMicroseconds(2);

    // Set the trigPin on HIGH state for 10 micro seconds
    digitalWrite(trigPin, HIGH);
    delayMicroseconds(10);
    digitalWrite(trigPin, LOW);

    // Read the echoPin, returns the sound wave travel time in microseconds
    duration = pulseIn(echoPin, HIGH);

    // Calculate the distance
    distance = (duration * 0.034) / 2;  // Speed of sound wave divided by 2 (go and back)

    Serial.print("Distance: ");
    Serial.print(distance);
    Serial.println(" cm");

    if (WiFi.status() == WL_CONNECTED) {
      HTTPClient http;
      http.begin(slackWebhookUrl);
      http.addHeader("Content-Type", "application/json");

      String payload = "{\"text\":\"Distance: " + String(distance) + " cm\"}";
      int httpResponseCode = http.POST(payload);

      if (httpResponseCode > 0) {
        String response = http.getString();
        Serial.println(httpResponseCode);
        Serial.println(response);
      } else {
        Serial.print("Error on sending POST: ");
        Serial.println(httpResponseCode);
      }

      http.end();
    } else {
      Serial.println("WiFi Disconnected");
    }
  }
}
