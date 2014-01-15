/*
 * Basic MQTT example 
 * 
 *  - connects to an MQTT server
 *  - publishes "hello world" to the topic "outTopic"
 *  - subscribes to the topic "inTopic"
 *  
 *  Compatibly WiFly Libary can be found here https://github.com/dpslwk/WiFly
 *  Current WiFly Libary only supports DHCP out the box
 *  This version is based around the RN-XV on a Cisceo XBEE Shield
 *  The RN-XV on the xbee shield talks over the hardware serial line 
 *  so debuging my require a SoftSerial
 *  The Ciseco Shiled require pin 8 HIGH before powering up the RN-XV
 *  
 */

#include <SPI.h>
#include <WiFly.h>
#include <PubSubClient.h>

#include "Credentials.h"
//#include "Sensors.h"

// Update these with values suitable for your network.
uint8_t server[] = { 150, 140, 5, 20 };
//CoapSensor *sensorsArray[MAX_SENSORS_NUM];
char *mac;
char channel[20];

WiFlyClient wiFlyClient;
PubSubClient client(server, 1883, callback, wiFlyClient);

void callback(char* topic, uint8_t* payload, unsigned int length) {
	// handle message arrived
	/* topic = part of the variable header:has topic name of the topic where the publish received
	 * NOTE: variable header does not contain the 2 bytes with the 
	 *       publish msg ID
	 * payload = pointer to the first item of the buffer array that
	 *           contains the message tha was published
	 *          EXAMPLE of payload: lights,1
	 * length = the length of the payload, until which index of payload
	 */
	digitalWrite(8,HIGH);
	delay(200);
	digitalWrite(8,LOW);
	delay(200);
	
	char sensorName[35];
	char * sensor = strtok((char *) payload, ",");
	int i = strcspn((char *) payload, ",");

	strcpy(sensorName,mac);
	strcat(sensorName,"/");
	strcat(sensorName,sensor);

	uint8_t *value = payload+i;
	uint8_t vallen = length-i;
	
	client.publish(sensorName,value,vallen);
}

void setup()
{
	pinMode(8,OUTPUT);    // power up the XBee socket
	//digitalWrite(8,HIGH);
	// lots of time for the WiFly to start up
	delay(5000);
	
	Serial.begin(9600);   // Start hardware Serial for the RN-XV
	WiFly.setUart(&Serial); // Tell the WiFly library that we are not using the SPIUart
	
	WiFly.begin();
	
	// Join the WiFi network
	if (!WiFly.join(ssid, passphrase, mode)) {
		Serial.println("Association failed.");
		while(1){
			// Hang on failure.
		}
	}
	Serial.println("Association succeeded.");
	channel[0] = 's';
	mac = WiFly.getMAC();
	strcat(channel, mac);

	if (client.connect("arduinoClient")) {
		client.publish("outTopic","hello world");
		client.subscribe(channel);
	}
}

void loop()
{
	if(!client.loop())
		Serial.println("Client disconnected.");
	//delay(3000);
	//client.publish("outTopic", "rst");
}