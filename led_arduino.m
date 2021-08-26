pkg load arduino;
arduinosetup
a=arduino;
led_pin = "d6";
vr_pin = "a0";
initTime = 1;
readTime = 200;
x = 0;

while true 
value = readAnalogPin(a, vr_pin);
  if (value >= 512)
    writeDigitalPin(a, led_pin, true);
  else 
   writeDigitalPin(a, led_pin, false);
  endif
  
  x = [x,value];
  plot(x);
  title("ADC Value Plot");
  xlabel("time");
  ylabel("Digital Value 0-1023");
  grid ON
  initTime = initTime + 1;
  drawnow;

endwhile