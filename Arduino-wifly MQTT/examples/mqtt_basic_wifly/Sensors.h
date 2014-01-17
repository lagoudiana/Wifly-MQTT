#ifndef _SENSORS_H_
#define _SENSORS_H_

#include <UberdustSensors.h>

#define MAX_SENSORS_NUM 20

int sensorCount = 0; 

//microphoneSensor 	*mic1, *mic2, *mic3;
//pirSensor 			*pir1, *pir2, *pir3;
//switchSensor		*switch1, *switch2, *switch3;
//UltrasonicSensor	*usonic1, *usonic2, *usonic3;

lightSensor *light1 = new lightSensor("light1", A0);
//lightSensor light1 ("light1", A0);
//lightSensor light2 ("light2", A1);
//lightSensor light3 ("light3", A2);

temperatureSensor *temp1 = new temperatureSensor("temp1", A3);
//temperatureSensor temp1 ("temp1", A3);
//temperatureSensor temp2 ("temp2", A4);
//temperatureSensor temp3 ("temp3", A5);

RandomSensor *rand1 = new RandomSensor("rand1",50);
//RandomSensor rand1("rand1", 50);
//RandomSensor rand2 ("rand2", 50);
//RandomSensor rand3 ("rand3", 50);

#endif