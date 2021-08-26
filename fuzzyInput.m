clc;
pkg load arduino;
arduinosetup
pkg load fuzzy-logic-toolkit;

a = arduino;
led_pin = 'd13';
potensio_pin = 'a0';
x=0;
init_time = 0;
y=0;
potensio_pin2 = 'a1';

while true
  suhu= readAnalogPin(a, potensio_pin);
  suhu_value= suhu/10.23;
  jarak= readAnalogPin(a, potensio_pin2);
  jarak_value=jarak/2.046;
  
a=newfis('KipasAngin');

% Tambahkan input SUHU
a=addvar(a,'input','SUHU',[0 100]); 
% Tambahkan fungsi keanggotaan SUHU
a=addmf(a,'input',1,'Dingin','trimf',[0 25 50]);
a=addmf(a,'input',1,'Hangat','trimf',[25 50 75]);
a=addmf(a,'input',1,'Panas','trimf',[50 75 100]);
% plot input SUHU utk melihat hasilnya
plotmf(a,'input',1)
 
% Tambahkan input JARAK
a=addvar(a,'input','JARAK',[0 500]);
% Tambahkan fungsi keanggotaan JARAK
a=addmf(a,'input',2,'Dekat','trimf', [0 125 250]);
a=addmf(a,'input',2,'Sedang','trimf', [125 250 375]);
a=addmf(a,'input',2,'Jauh','trimf', [250 375 500]);
% plot input JARAK utk melihat hasilnya
figure; plotmf(a,'input',2)
 
% Tambahkan output
a=addvar(a,'output','Output Kipas Angin',[0 255]); 
% Tambahkan fungsi keanggotaan output
a=addmf(a,'output',1,'Lambat','trimf', [0 50 100]);
a=addmf(a,'output',1,'Sedang','trimf', [75 125 175]);
a=addmf(a,'output',1,'Cepat','trimf', [150 200 255]);
% plot output utk melihat hasilnya
figure; plotmf(a,'output',1)

aturan1 = [1 1 1 1 1]; 
aturan2 = [1 2 1 1 1]; 
aturan3 = [1 2 3 1 1]; 
aturan4 = [2 1 1 1 1]; 
aturan5 = [2 2 2 1 1]; 
aturan6 = [2 3 3 1 1];
aturan7 = [3 1 1 1 1];
aturan8 = [3 2 1 1 1];
aturan9 = [3 3 3 1 1]; 

% Padukan semua aturan
listAturan = [aturan1;aturan2;aturan3;aturan4;aturan5;aturan6;aturan7;aturan8;aturan9;];
a = addrule(a,listAturan);
% Perlihatkan aturan, apakah sudah sesuai?
showrule(a)

% Lakukan evaluasi
evaluasi = evalfis([data1 data2], a)
endwhile