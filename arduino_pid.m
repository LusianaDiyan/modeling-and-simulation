pkg load arduino; #Load Arduino before any usage
arduinosetup      #membuat Proyek Arduino sementara, 
                  #dengan file toolkit Arduino disalin ke sana dan Arduino IDE akan terbuka.
a=arduino;        #mendeklarasikan variabel komunikasi arduino dengan octave
led_pin = "d6"; #mendeklarasikan pin yang terhubung dengan LED
vr_pin = "a0"; #mendeklarasikan pin yang terhubung dengan potensio
initTime = 0; #delay
#readTime = 200;
x = 0;
feedback = 0;
Kp = 0.05;
Ki = 0.05;
Kd = 0.05;
integral_error = 0;
derivatif_error = 0;
last_error = 0;

#PID Controller program
while initTime <= 250  
adc = readAnalogPin(a, vr_pin); #inisialisasi pembacaan nilai potensio
value = adc/4;

  #menghitung nilai error
  error = value - feedback; #menghitung perbedaan nilai input potensio dengan pembacaan output PID Controller
  integral_error += error;
  derivatif_error = error - last_error;
  last_error = error;
  
  #menghitung nilai proportional, derivatif, integral
  proportional = Kp * error;
  integral = Ki * integral_error;
  derivatif = Kp * derivatif_error;
  
  #menampilkan nilai proportional, derivatif, integral di komunikasi serial
  printf("Proportional : %d\n", proportional);
  printf("Derivatif : %d\n", derivatif);
  printf("Integral : %d\n", integral);
  printf("\n");
  
  PID = proportional + integral + derivatif; #menghitung nilai PID 
  conv = PID/256; #konversi nilai PID
  double(conv); #konversi type nilai
  writePWMDutyCycle(a,led_pin,conv);
  feedback = PID;
  
  x = [x,PID]; #deklarasi matriks data output
  plot(x);      #membuat plot/grafik dari data output PID Controller
  title("PID Value Plot"); #membuat judul grafik
  xlabel("time");           #memberi label sisi x grafik
  ylabel("Digital Value 0-256");  #memberi label sisi y grafik
  grid ON         #memberikan garis grid pada grafik
  initTime = initTime + 1;  #mengatur waktu yang digunakan untuk data grafik
  drawnow; #menggambarkan grafik berdasarkan data output PID Controller

endwhile