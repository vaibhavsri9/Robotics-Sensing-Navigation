%% File and Java
clear all 
clear java
javaaddpath /home/vaibhav/lcm-1.3.1/lcm-java/lcm.jar
javaaddpath /home/vaibhav/Downloads/my_robot/lcm-spy/my_types.jar

log_file = lcm.logging.Log('/home/vaibhav/Downloads/my_robot/drive_log/lcm_drive_log','r');
log_file1 = lcm.logging.Log('/home/vaibhav/Downloads/my_robot/drive_log/lcm_drive_log','r');

%% Read File
i = 1;
while true
    try 
        ev = log_file.readNext();
        if strcmp(ev.channel, 'IMU')
            imu1 = lab3lcm.imu_t(ev.data);
            
            yaw(i) = imu1.yaw;
            roll(i) = imu1.roll;
            pitch(i) = imu1.pitch;
            mag_x(i) = imu1.mag_x;
            mag_y(i) = imu1.mag_y;
            mag_z(i) = imu1.mag_z;
            accel_x(i) = imu1.accel_x;
            accel_y(i) = imu1.accel_y;
            accel_z(i) = imu1.accel_z;
            gyro_x(i) = imu1.gyro_x;
            gyro_y(i) = imu1.gyro_y;
            gyro_z(i) = imu1.gyro_z;
            
            i = i+1;
        end
            catch
                break;
        
    end
end
%% Read GPS Data
c = 1;
while true
    try 
        evGPS = log_file1.readNext();
        if strcmp(evGPS.channel, 'GPS')
            gps1 = lab3lcm.gps_t(evGPS.data);
            time(c) = gps1.timestamp;
            lat(c) = gps1.lat;
            lon(c) = gps1.lon;
            alt(c) = gps1.altitude;
            utm_x(c) = gps1.utm_x;
            utm_y(c) = gps1.utm_y;
            
            c = c+1;
        end
            catch
                break;
        
    end
end
%% Data Analysis for driving data
% GPS velocity estimate
r = 1:length(utm_x);
for r = 2:length(utm_x)
    gps_vel(r-1) = sqrt(((utm_x(r)-utm_x(r-1))^2)+((utm_y(r)-utm_y(r-1))^2));
end
vel_gps = repelem(gps_vel,40);
% calculation of acceleration
vel_accel_err = cumtrapz(accel_x);
% Calculation of right velocity from acceleration data
accel_filter = smooth(accel_x);
accel_filter_1 = smooth(accel_filter);
accel_filter_2 = smooth(accel_filter_1);
[b,a] = butter(2,0.1);
accel_filter_final = filter(b,a,accel_filter_2);
% correction of of acceleration data
accel_filter_final(4657:5986) = 0;
accel_filter_final(9471:10090) = 0;
accel_filter_final(11490:15290) = 0;
accel_filter_final(16540:16800) = 0;
accel_filter_final(18450:19490) = 0;
accel_filter_final(20000:20220) = 0;
accel_filter_final(20460:21360) = 0;
accel_filter_final(22220:22480) = 0;
accel_filter_final(22750:23010) = 0;
accel_filter_final(23290:23890) = 0;
accel_filter_final(25300:28040) = 0;
accel_filter_final(31230:31920) = 0;
accel_filter_final(34020:34270) = 0;
accel_filter_final(35200:36190) = 0;
accel_filter_final(39320:39510) = 0;
accel_filter_final(42350:42580) = 0;
accel_filter_final(43720:44240) = 0;
accel_filter_final(50950:52140) = 0;
accel_filter_final(54540:55420) = 0;
accel_filter_final(55670:56970) = 0;
% calculation of corrected velocity
vel_corrected = cumtrapz(accel_filter_final);
accel_no = 1:60127;
[vel_corr,vel1] = baselinefit(vel_corrected);
[vel_corr1,vel2] = baselinefit(vel_corr);
for w = 1:60127
    if vel_corr1(w) > 0
        vel_corr1(w) = vel_corr1(w)/60;
    else
        vel_corr1(w) = 0;
    end
end
% vel_correctionfactor = polyfit(accel_filter_final,accel_no',1);
% Velocity and acceleration plots 
figure(1)
plot(vel_gps); hold on
%plot(vel_accel_err);hold on 
%plot(vel_corrected);hold on
plot(vel_corr1);
% plot(vel_accel_err)
figure(2)
plot(accel_x);hold on 
plot(accel_filter); hold on 
plot(accel_filter_1); hold on
plot(accel_filter_2)
% plot(vel_accel_err)





%% Data Analysis for stationary IMU
% Analysis of noise characteristics 
% figure(1)
% subplot(1,2,1)
% plot(accel_x)
% title('Accelerometer data in x')
% subplot(1,2,2)
% histogram(accel_x);
% title('Distribution of accelerometer data')
% figure(2)
% subplot(1,2,1)
% plot(accel_y)
% title('Accelerometer data in y')
% subplot(1,2,2)
% histogram(accel_y);
% title('Distribution of accelerometer data')
% figure(3)
% subplot(1,2,1)
% plot(accel_z)
% title('Accelerometer data in z')
% subplot(1,2,2)
% histogram(accel_z);
% title('Distribution of accelerometer data')
% figure(4)
% subplot(1,2,1)
% plot(gyro_x)
% title('Gyro data in x')
% subplot(1,2,2)
% histogram(gyro_y);
% title('Distribution of gyro data')
% figure(5)
% subplot(1,2,1)
% plot(gyro_y)
% title('Gyro data in y')
% subplot(1,2,2)
% histogram(accel_y);
% title('Distribution of gyro data')
% figure(6)
% subplot(1,2,1)
% plot(gyro_z)
% title('Gyro data in z')
% subplot(1,2,2)
% histogram(gyro_z);
% title('Distribution of gyro data')
% figure(7)
% subplot(1,2,1)
% plot(mag_x)
% title('Magnetometer data in x')
% subplot(1,2,2)
% histogram(mag_x)
% title('Distribution of magnetometer data')
% figure(8)
% subplot(1,2,1)
% plot(mag_x)
% title('Magnetometer data in y')
% subplot(1,2,2)
% histogram(mag_x)
% title('Distribution of magnetometer data')
% figure(9)
% subplot(1,2,1)
% plot(mag_x)
% title('Magnetometer data in z')
% subplot(1,2,2)
% histogram(mag_x)
% title('Distribution of magnetometer data')

















%% Data Analysis and plotting for hard iron and soft iron
%figure(1)
scatter(mag_x,mag_y)
ax = gca;
ellipse_interpreted1 = fit_ellipse(mag_x,mag_y,ax);
title('1st step in interpretation of data')
% Now move the ellipse foci to (0,0)
%% Perform hard iron and soft iron
% Now move the ellipse foci to (0,0)
mag_xhct = mag_x - ellipse_interpreted1.X0;
mag_yhct = mag_y - ellipse_interpreted1.Y0;
mag_xhctr = ((mag_xhct).*cos(ellipse_interpreted1.phi)) - (sin(ellipse_interpreted1.phi).*(mag_yhct));
mag_yhctr = ((mag_xhct).*sin(ellipse_interpreted1.phi)) + (cos(ellipse_interpreted1.phi).*(mag_yhct));
%figure(2)
%scatter(mag_xhctr,mag_yhctr)
ax1 = gca;
ellipse_hardironcalibrated1 = fit_ellipse(mag_xhctr,mag_yhctr,ax1);
title('ellipse translated and rotated')
mag_xhctrt = mag_xhctr - ellipse_hardironcalibrated1.X0;
mag_yhctrt = mag_yhctr - ellipse_hardironcalibrated1.Y0;
%figure(3)
%scatter(mag_xhctrt,mag_yhctrt)
ax2 = gca;
ellipse_hardironcalibrated2 = fit_ellipse(mag_xhctrt,mag_yhctrt,ax2);
title('Ellipse translated final hard iron calibration')
% Now distort the ellipse to circle to perform soft iron
mag_xsc = (mag_xhctrt);
mag_ysc = (mag_yhctrt).*(ellipse_hardironcalibrated2.a/ellipse_hardironcalibrated2.b);
%figure(4)
%scatter(mag_xsc,mag_ysc)
ax3 = gca;
%instead try fitting a circle 
ellipse_softironcalibrated = fit_ellipse(mag_xsc,mag_ysc,ax3);
title('Near Circle after soft iron calibration')
%% Calculation of Yaw from corrected magnetometer readings
for k = 1:length(mag_xsc)
Heading(k)= atan(mag_xsc(k)/mag_ysc(k))*(180/pi);
end
%% Calculation of Yaw from yaw rate (gyro)
Q = cumtrapz(gyro_z);
Qfinal = (mod(Q,2*pi)*(180/pi)) - 360;
%% Analysis Qfinal
fft_Q = fft(Qfinal);
length_Q = length(Qfinal);
P_Q =abs(fft_Q/length_Q);
%% Filtering Qfinal
[b,a] = butter(2,0.8);
Qfilter = filter(b,a,Qfinal);
%% Complementary Filter for Yaw (Heading)
Headingfinal = (0.95*Heading)+(0.05*Qfilter);
%% Comparison of all the Yaw angles
figure(5)
plot(Qfilter);hold on
xlabel('Time')
ylabel('Yaw calculated from different sources')
plot(yaw); hold on
plot(Heading); hold on
plot(Headingfinal)
legend('Filtered Yaw angle from Yaw rate','Yaw calculated by sensor','Heading calculated by Magnetometer','Final Heading after application of complementary filter')  

%% Estimation of Distance 
% Estimation of X'-filter_vel
wr = gyro_z;
% change this velocity
Xdot = vel_corr1;
% wXdot
wXdot = wr'.*Xdot;
ydoubledot = accel_y;
figure(7)
plot(wXdot);hold on
plot(ydoubledot)
legend('wXdot','ydoubledot')
% title('Comparison of wXdot and ydoubledot')
% East North Reference frame
coscomponent = cos(Headingfinal-90);
sincomponent = sin(Headingfinal-90);
vn = vel_corr1.*coscomponent';
ve = vel_corr1.*sincomponent';
xn = cumtrapz(ve);
yn = cumtrapz(vn);
figure(8)
plot(utm_x-mean(utm_x),utm_y-mean(utm_y));hold on
plot(xn,yn)



 





