%% Extraction
bag = rosbag('2019-02-18-19-43-37.bag')
bagselect = select(bag,'Topic','utm_fix');
msgs = readMessages(bagselect,'DataFormat','struct')
xPoints = cellfun(@(m) double(m.Pose.Pose.Position.X),msgs);
yPoints = cellfun(@(m) double(m.Pose.Pose.Position.Y),msgs);
zPoints = cellfun(@(m) double(m.Pose.Pose.Position.Z),msgs);

%% Plotting
figure(1)
scatter(xPoints-min(xPoints),yPoints-min(yPoints))
title('Openfield - walking')
xlabel('utm-x')
ylabel('utm-y')
figure(2)
scatter3(xPoints-min(xPoints),yPoints-min(yPoints),zPoints-min(zPoints))
title('Openfield-walking-Including altitude')
xlabel('utm-x')
ylabel('utm-y')
zlabel('Altitude')


%% Characterizing Noise
figure(3)
plot(histogram(xPoints,100))









