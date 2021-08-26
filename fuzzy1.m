pkg load arduino;
pkg load fuzzy-logic-toolkit

arduinosetup
a=arduino;
suhu_pin = "a0";
jarak_pin = "a1";
initTime = 1;
readTime = 200;
x = 0;
y = 0;
z = 0;

suhuDingin =0;
suhuHangat = 0;
suhuPanas = 0;

jarakDekat, jarakSedang, jarakJauh = 0;

pwmLambat = 100;
pwmSedang = 200;
pwmCepat = 250;

while true 
suhu = readAnalogPin(a, suhu_pin);
suhu_value = suhu/10.23;

jarak = readAnalogPin(a, jarak_pin);

  if (suhu_value <= 22.5)
    suhuDingin = 1;
  elseif (suhu_value > 22.5 && suhu_value <= 25)
    suhuDingin = (25-suhu_value)/(25-22.5);
  else
    suhuDingin = 0;
    
  if (suhu_value <= 22.5)
    suhuHangat = 0;
  elseif (suhu_value > 22.5 && suhu_value <= 25)
    suhuHangat = (suhu_value - 22.5)/(25 - 22.5);
  elseif (suhu_value > 25 && suhu_value <= 27.5)
    suhuHangat = (27.5 - suhu_value)/(27.5 - 25);
  else
    suhuHangat = 0;
    
  if (suhu_value <= 25)
    suhuPanas = 0;
  elseif (suhu_value > 25 && suhu_value <= 27.5)
    suhuPanas = (suhu_value-25)/(27.5 - 25);
  else
    suhuPanas = 1;
  
  if (jarak <= 10)
    jarakDekat = 1;
  elseif (jarak > 10 && suhu_value <= 20)
    jarakDekat = (20 - jarak)/(20-10);
  else
    jarakDekat = 0;
    
  if (jarak <= 10)
    jarakSedang = 0
  elseif (jarak > 10 && suhu_value <= 20)
    jarakSedang = (jarak - 10)/(20-10);
  elseif (jarak > 20 && suhu_value <= 30)
    jarakSedang = (30 - jarak)/(30-20);
  else
    jarakSedang = 0;
    
  if (jarak <= 20)
    jarakJauh = 0;
  elseif (jarak > 20 && jarak <= 30)
    jarakJauh = (jarak - 20)/(30-20);
  else
    jarakJauh = 1;
    
  rule00 = [1 1 1 1 1]; 
  rule01 = [1 2 1 1 1]; 
  rule02 = [1 2 3 1 1]; 
  rule10 = [2 1 1 1 1]; 
  rule11 = [2 2 2 1 1]; 
  rule12 = [2 3 3 1 1];
  rule20 = [3 1 1 1 1];
  rule21 = [3 2 1 1 1];
  rule22 = [3 3 3 1 1];
 
  PWM0 = (rule00 * pwmLambat) + (rule01 * pwmLambat) + (rule02 * pwmLambat);
  PWM1 = (rule10 * pwmLambat) + (rule11 * pwmSedang) + (rule12 * pwmCepat);
  PWM2 = (rule20 * pwmCepat) + (rule21 * pwmCepat) + (rule22 * pwmCepat);
  PWMTot = PWM1 + PWM0 + PWM2;
  
  DEF0 = (rule00) + (rule01) + (rule02)
  DEF1 = (rule10) + (rule11) + (rule12)
  DEF2 = (rule20) + (rule21) + (rule22)
  DEFTot = DEF0 + DEF1 + DEF2;
  
  OutPWM = PWMTot/DEFTot;
    
  x = [x,suhu_value];
  plot(x);
  title("Data Suhu");
  xlabel("time");
  ylabel("nilai suhu");
  grid ON
  initTime = initTime + 1;
  figure(1);
  
  y = [y, jarak];
  plot(y);
  title("Data Jarak");
  xlabel("time");
  ylabel("nilai jarak");
  grid ON
  figure(2);
#  initTime = initTime + 1;
    
  drawnow;
endwhile