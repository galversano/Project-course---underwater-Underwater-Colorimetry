%% Project course - underwater Underwater Colorimetry 
%Eilat 2024


%% show the pictures
I = im2double(imread('DSC01451.png'));

s = size(I);
figure(99);imshow(I*3)

title('Linear image','fontsize',20)



%% LOAD Data

load DGKColorChart.mat
mat_array_RGB=[]
num_chart=5

stdobs = importdata('data/CIEStandardObserver.csv');
light = importdata('data/illuminant-D65.csv');
refl = importdata('data/DGKcolorchart_reflectances.csv');
WL = 400:10:700;
% Interpolate data to wave length range  
refl_spectra = (interp1(refl.data(:,1)',refl.data(:,2:end),WL))';
light_spectra = interp1(light.data(:,1),light.data(:,2),WL);
% Interpolate data to wave length range  
stdobs_spectra = interp1(stdobs(:,1),stdobs(:,2:4),WL);

%% ex.1
for i=1:num_chart
masks = makeChartMask(I,chart,colors,20);
RGB = getChartRGBvalues(I,masks,colors);
    mat_array_RGB(:, :, i) = RGB;
end


%% ex.2
%opren the depath image and use the tips to get the distance, then right it
%manually for the depth_array=[]

%change your path 
uiopen('C:\Users\User\Downloads\Underwater-colorimetry-main\materials\DSC01451.tif',1)
figure(3)
imagesc(DSC01452);colorbar
depth_array=[]


%% ex.3

% get XYZ values 
XYZ = getradiance(refl_spectra, light_spectra, stdobs_spectra);
XYZ_light = getradiance(ones(1,numel(WL)), light_spectra, stdobs_spectra);
%xy_light = XYZ_light./sum(XYZ_light,2);
% Recall that we also want the XYZ to be white balanced.
XYZ_wb = XYZ./XYZ_light;

k=0.40024;
l =0.7075;
m=0.29785;

for i=1:18
Y(i,:,:)=k*XYZ(i,1,:)+l*XYZ(i,2,:)+m*XYZ(i,3,:)
end


Bc=[]
for j=1:num_chart
for i=1:3
coefficients = polyfit(Y(2:6,1), mat_array_RGB(2:6, i, j), 1); % Fit a first-degree (linear) polynomial
Bc(j,i)=coefficients(2)
end
end

for i=1:length(Bc)
        plot(depth_array(i),Bc(i,1),'o','MarkerEdgeColor', 'r')
        hold on
        plot(depth_array(i),Bc(i,2),'o','MarkerEdgeColor', 'g')
        hold on
        plot(depth_array(i),Bc(i,3),'o','MarkerEdgeColor', 'b')
        hold on
        grid on
        xlabel("z")
        ylabel("B_c")
end

%% ex.4 

Dc = [];
for i=1:num_chart
    for j=1:18
    Dc(j,:,i) = ((mat_array_RGB(j, 1:3,i) - Bc(i,:))); 
    end
end



for i=1:num_chart
        plot(depth_array(i),Dc(:,1,i),'o','MarkerEdgeColor', 'r')
        hold on
        plot(depth_array(i),Dc(:,2,i),'o','MarkerEdgeColor', 'g')
        hold on
        plot(depth_array(i),Dc(:,3,i),'o','MarkerEdgeColor', 'b')
        hold on
        grid on
        xlabel("z")
        ylabel("D_c")
end

% Determine the number of images
num_images = size(Dc, 3);
% Define the number of rows and columns for the subplot grid
rows = ceil(sqrt(num_images));
columns = ceil(num_images / rows);
% Create a new figure
figure(49);
% Plot each image in a subplot
for i = 1:num_images
    subplot(rows, columns, i);  % Subplot index starts from 1
    imshow(visualizeColorChecker(Dc(:,:,i)));
    title(['z=', num2str(depth_array(i))]);
end

%% ex.5

%change the parameter index_depth to your relevant chart in you image.

beta_dc=[];
index_depth=5;
for i = 1:(length(depth_array))
    if i~=index_depth
    dz = depth_array(i) - depth_array(index_depth);
    beta_dc(:,:,i) = log(Dc(:,:,index_depth) ./ Dc(:,:,i)) / dz;
    end
end




%% ex.6
J_c=[]
for i=1:num_chart
    if i~=index_depth
    for j=1:18
    J_c(j,:,i)=Dc(j,:,index_depth).*exp(beta_dc(j,:,i)*depth_array(index_depth))
    end
    end
end


% Find slices that are not all zeros
non_zero_slices = any(any(J_c ~= 0, 1), 2);
% Remove slices containing zeros
J_c = J_c(:,:,non_zero_slices);

% We get all the results for all the depth of color chart
%first index-num_patch second-RGB third-number-of-Jc forth-num-color-chart
full_result_Jc(:,:,:,index_depth)=J_c

%% plot- after full_result_Jc is complete

for i=1:num_chart
    figure(5)
        plot(depth_array(i),full_result_Jc(2:18,1,1,i),'o','MarkerEdgeColor', 'r')
        hold on
        plot(depth_array(i),full_result_Jc(2:18,2,1,i),'o','MarkerEdgeColor', 'g')
        hold on
        plot(depth_array(i),full_result_Jc(2:18,3,1,i),'o','MarkerEdgeColor', 'b')
        hold on
         xlabel("z")
        ylabel("J_c")
        grid on
end



% Define the number of rows and columns for the subplot grid
rows = 2;
columns = 2;
figure(51);
for i = 1:4
    subplot(rows, columns, i);  % Subplot index starts from 1
    imshow(visualizeColorChecker(J_c(:,:,i)));
end

%% ex.7 
Jc_wb=[]
patch_number=4;
patch_refl=[0.9 0.597 0.361 0.198 0.09 0.031];
for i=1:num_chart-1
    %patch1-0.9 patch2-0.597 patch3-0.361 patch4-0.198 patch5-0.09 patch6-0.031 
 wbpatch = J_c(patch_number,:,i);
Jc_wb(:,:,i) = patch_refl(patch_number)*J_c(:,:,i)./repmat(wbpatch,[size(J_c(:,:,i),1),1]);
end

full_result_Jc_wb(:,:,:,index_depth)=Jc_wb

rows = 2;
columns = 2;
figure(50);
for i = 1:4
    subplot(rows, columns, i);  % Subplot index starts from 1
    imshow(visualizeColorChecker(Jc_wb(:,:,i)));
    %title(['dz=', num2str(depth_array(i+1)-depth_array(index_depth))]);
end

%% plot- after full_result_Jc_wb is complete
for i=1:num_chart
    figure(7)
        plot(depth_array(i),full_result_Jc_wb(1:18,1,1,i),'o','MarkerEdgeColor', 'r')
        hold on
        plot(depth_array(i),full_result_Jc_wb(1:18,2,1,i),'o','MarkerEdgeColor', 'g')
        hold on
        plot(depth_array(i),full_result_Jc_wb(1:18,3,1,i),'o','MarkerEdgeColor', 'b')
        hold on
         xlabel("z")
        ylabel("J_cwb")
        grid on
end


%% ex.8

XYZ = getradiance(refl_spectra, light_spectra, stdobs_spectra);
% % choose right patch
XYZ_light = getradiance(refl_spectra(1,:), light_spectra, stdobs_spectra);
xy_light = XYZ_light./sum(XYZ_light,2);
% Recall that we also want the XYZ to be white balanced.
XYZ_wb = XYZ./XYZ_light;


%% ex.9
for i=1:num_chart-1
M(:,:,i) = XYZ_wb' * pinv(Jc_wb(:,:,i))';
end

%% ex.10
for i=1:num_chart-1
XYZ_Jc(:,:,i)=(M(:,:,i)*Jc_wb(:,:,i)')';
end

%% ex.11.1
XYZ_to_sRGB = makecform('xyz2srgb'); % Create a color transformation structure
% Convert XYZ values to sRGB color space
for i=1:num_chart-1
    for j=1:18
sRGB_values(j,:,i) = applycform((XYZ_Jc(j,:,i)), XYZ_to_sRGB);
    end
end

full_result_sRGB(:,:,:,index_depth)=sRGB_values

rows = 2;
columns = 2;

% Create a new figure
figure(53);
for i = 1:4
    subplot(rows, columns, i);  % Subplot index starts from 1
    imshow(visualizeColorChecker(sRGB_values(:,:,i)));

end

%% plot- after sRGB is complete 
for i=1:num_chart
    figure(10)
        plot(depth_array(i),full_result_sRGB(1:18,1,1,i),'o','MarkerEdgeColor', 'r')
        hold on
        plot(depth_array(i),full_result_sRGB(1:18,2,1,i),'o','MarkerEdgeColor', 'g')
        hold on
        plot(depth_array(i),full_result_sRGB(1:18,3,1,i),'o','MarkerEdgeColor', 'b')
        hold on
         xlabel("z")
        ylabel("sRGB")
        grid on
end

%% ex.11.2
%after you run for chart, run this command to save the best result. for
%example: for the first chart, run best_res(:,:,1) and choose the best
%result from sRGB_values(:,:,i) (change the i to best result.

%chart 1
best_res(:,:,1)=sRGB_values(:,:,1)
%chart 2
best_res(:,:,2)=sRGB_values(:,:,1)
%chart 3
best_res(:,:,3)=sRGB_values(:,:,1)
%chart 4
best_res(:,:,4)=sRGB_values(:,:,1)
%chart 5
best_res(:,:,5)=sRGB_values(:,:,1)


%% ex.12
error=[]
for i=1:num_chart-1
for j=1:18
error(j,:,i)=real(acos((best_res(j,:,i)*best_res(j,:,i+1)')/(norm(best_res(j,:,i)))*(norm(best_res(j,:,i+1)))))
end    
end

mean_error= mean(error(:, 1, :), 3);
figure(12);
plot(1:18,mean_error(:,1),'o','MarkerEdgeColor', 'r')
