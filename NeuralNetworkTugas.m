% Membaca data dari excel
filename = '4_contact-lenses konversi.xlsx';
sheet = 1;
xlRange = 'A2:E25';

Data = xlsread(filename, sheet, xlRange);
data_latih = Data(:,1:4)';
target_latih = Data(:,5)';
[m,n] = size(data_latih);

% Pembuatan neural networks feedforward backpropagation
net = newff(minmax(data_latih), [2 1], {'tansig', 'purelin'}, 'trainlm');

net.performFcn = 'mse';
net.trainParam.goal = 0.0001;
net.trainParam.show = 20;
net.trainParam.epochs = 3000;
net.trainParam.mc = 0.95;
net.trainParam.lr = 1;

% Proses training
[net_keluaran,tr,Y,E] = train(net,data_latih,target_latih);

% Hasil setelah pelatihan
bobot_hidden = net_keluaran.IW{1,1};
bobot_keluaran = net_keluaran.LW{2,1};
bias_hiddan = net_keluaran.b{1,1};
bias_keluaran = net_keluaran.b{2,1};
jumlah_iterasi = tr.num_epochs;
nilai_keluaran = Y;
nilai_error = E;
error_MSE = (1/n)*sum(nilai_error.^2);

save('C:\Users\hello\OneDrive\Documents\MATLAB\output.mat')

% Hasil prediksi
hasil_latih = sim(net_keluaran,data_latih);

% Performansi hasil prediksi
target_latih_asli = target_latih;

figure,
plotregression(target_latih_asli,hasil_latih,'Regression')
figure,
plotperform(tr)

figure,
plot(hasil_latih, 'bo-')
hold on
plot(target_latih_asli, 'ro-')
hold off
grid on
title(strcat(['Grafik Keluaran JST vs Target dengan nilai MSE = ',...
    num2str(error_MSE)]))
xlabel('Pola ke-')
ylabel('MSE')
legend('Keluaran JST', 'Target', 'Location', 'Best')

% Load jaringan yang dibuat pada proses pelatihan
load('C:\Users\hello\OneDrive\Documents\MATLAB\output.mat')

% Membaca data uji 
filename = '4_contact-lenses konversi.xlsx';
sheet = 1;
xlRange = 'A2:E25';
Data = xlsread(filename, sheet, xlRange);
data_uji = Data(:,1:4)';
target_uji = Data(:,5)';
[m,n] = size(data_uji);

% Hasil prediksi
hasil_uji = sim(net_keluaran, data_uji);
nilai_error = abs(hasil_uji-target_uji)

% Performa hasil prediksi
error = (1/n)*sum(nilai_error.^1);

akurasi = (1-error)*100