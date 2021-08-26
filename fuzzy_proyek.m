pkg load arduino;
pkg load fuzzy-logic-toolkit

arduinosetup

ar = arduino;
vr_pin = "a0";
vr2_pin = "a1";
initTime = 1;
readTime = 200;
x = 0;
y= 0;
z=0;
while  initTime <= 200
  value = readAnalogPin(ar, vr_pin);
  value_2 = readAnalogPin(ar, vr2_pin);
  conv_temp = (value/32)-2;
  conv_dist = (value_2/8);
  
  %fuzifikasi
  %suhu dingin
  if conv_temp <= 22.5,
    suhuDingin=1;
  elseif conv_temp > 22.5 & conv_temp <= 25,
    suhuDingin= (25-conv_temp)/(25-22.5);,
  elseif conv_temp > 25,
    suhuDingin=0;
  endif
  
  %suhu hangat
  if conv_temp <= 22.5,
    suhuHangat=0;
  elseif conv_temp > 22.5 & conv_temp <= 25,
    suhuHangat= (conv_temp-22.5)/(25-22.5);
  elseif conv_temp > 25 & conv_temp <= 27.5,
    suhuHangat= (27.5-conv_temp)/(27.5-25);
  elseif conv_temp > 27.5,
    suhuHangat=0;
  endif
  
  %suhu panas
  if conv_temp <= 25,
    suhuPanas=0;
  elseif conv_temp > 25 & conv_temp <= 27.5,
    suhuPanas= (conv_temp-25)/(27.5-25);,
  elseif conv_temp > 27.5,
    suhuPanas=1;
  endif
  
  %jarak dekat
  if conv_dist <= 35,
    jarakDekat=1;
  elseif conv_dist > 35 & conv_dist <= 45,
    jarakDekat= (45-conv_dist)/(45-35);,
  elseif conv_dist > 45,
    jarakDekat=0;
  endif
  
   %suhu sedang
  if conv_dist <= 35,
    jarakSedang=0;
  elseif conv_dist > 35 & conv_dist <= 45,
    jarakSedang= (conv_dist-35)/(45-35);
  elseif conv_dist > 45 & conv_dist <= 65,
    jarakSedang= (65-conv_dist)/(65-45);
  elseif conv_dist > 65,
    jarakSedang=0;
  endif
  
  %jarak Jauh
  if conv_dist <= 65,
    jarakJauh=0;
  elseif conv_dist > 65 & conv_dist <= 100,
    jarakJauh= (conv_dist-65)/(100-65);,
  elseif conv_dist > 100,
    jarakJauh=1;
  endif
  
  %rule base
  rule00 = min(suhuDingin, jarakDekat);
  rule01 = min(suhuDingin, jarakSedang);
  rule02 = min(suhuDingin, jarakJauh);
  
  rule10 = min(suhuHangat, jarakDekat);
  rule11 = min(suhuHangat, jarakSedang);
  rule12 = min(suhuHangat, jarakJauh);
  
  rule20 = min(suhuPanas, jarakDekat);
  rule21 = min(suhuPanas, jarakSedang);
  rule22 = min(suhuPanas, jarakJauh);
  
  pwmLambat = 100;
  pwmSedang = 200;
  pwmCepat = 250;
  
  %defuz
  PWM0 = (rule00 * pwmLambat) + (rule01 * pwmLambat) + (rule02 * pwmLambat);
  PWM1 = (rule10 * pwmLambat) + (rule11 * pwmSedang) + (rule12 * pwmCepat);
  PWM2 = (rule20 * pwmCepat) + (rule21 * pwmCepat) + (rule22 * pwmCepat);
  PWMTot = PWM0 + PWM1 + PWM2;
  
  DEF0 = (rule00) + (rule01) + (rule02);
  DEF1 = (rule10) + (rule11) + (rule12);
  DEF2 = (rule20) + (rule21) + (rule22);
  DEFTot = DEF0 + DEF1 + DEF2;
  
  OutPWM = PWMTot / DEFTot;
  
  %plot
  figure(1);
  x = [x,conv_temp];
  y = [y, conv_dist];
  z = [z,OutPWM];
  plot(x,'r');
  hold on;
  plot(y,'b');
  hold on;
  plot(z,'g');
  xlabel("Time (s)");
  ylabel("Merah : Suhu (C), Biru = Jarak(cm), Hijau = OutPWM");
  axis([0 300 0 130]);
  hold on;
  initTime += 1;
  drawnow;
endwhile

 ## Create new FIS.
 a = newfis ('Heart-Disease-Risk', 'sugeno', ...
             'min', 'max', 'min', 'max', 'wtaver');
 
 ## Add two inputs and their membership functions.

 a = addvar (a, 'input', 'Jarak', [0 130]);
 a = addmf (a, 'input', 1, 'Dekat', 'trapmf', [-1 0 45 55]);
 a = addmf (a, 'input', 1, 'Sedang', 'trapmf', [45 55 75 90]);
 a = addmf (a, 'input', 1, 'Jauh', 'trapmf', [75 90 130 131]);
 
 a = addvar (a, 'input', 'Suhu', [0 30]);
 a = addmf (a, 'input', 2, 'Dingin', 'trapmf', [-1 0 10 15]);
 a = addmf (a, 'input', 2, 'Hangat', 'trapmf', [10 15 20 25]);
 a = addmf (a, 'input', 2, 'Panas', 'trapmf', [20 25 30 31]);
 
 ## Plot the input membership functions.
 plotmf (a, 'input', 1);
 plotmf (a, 'input', 2);