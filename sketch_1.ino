char data;
int lightswitch,ledswitch;
int oldlightswitch=0;
int oldledswitch=0;
int lightstate=0;
int ledstate=0;
void setup()
{
  Serial.begin(38400);
  pinMode(9,OUTPUT);
  digitalWrite(9,HIGH);
  pinMode(12,INPUT);
  pinMode(11,INPUT);
  pinMode(10,OUTPUT);
   digitalWrite(10,HIGH);
}
void loop(){
  if (Serial.available()>0)
  {
    data=Serial.read();
    if(data=='1' && !lightstate) {
      digitalWrite(9,LOW);
     lightstate=1;
    }
    if (data=='0' && lightstate){
      digitalWrite(9,HIGH);
     lightstate=0;  
    }
    if (data=='a'&& !ledstate){
      digitalWrite(10,LOW);
     ledstate=1;
    }
    if (data=='b'&& ledstate){
      digitalWrite(10,HIGH);
     ledstate=0;
    }
  } 
   lightswitch=digitalRead(12);
  if (lightswitch!=oldlightswitch){          
        if(lightstate==1 ) {
          lightstate=0;
          digitalWrite(9,HIGH);  }
        else{
          lightstate=1;
          digitalWrite(9,LOW);  
        } 
        oldlightswitch=lightswitch;
  }
  ledswitch=digitalRead(11);
  if (ledswitch!=oldledswitch){
        if(ledstate==1 ) {
          ledstate=0;
          digitalWrite(10,HIGH);  }
        else{
          ledstate=1;
          digitalWrite(10,LOW);  
        } 
        oldledswitch=ledswitch;

  }
  
}
