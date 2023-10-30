% Load the data files
data_dir = 'C:\Users\visha\OneDrive\Desktop\subject_2';

% Load the data for quiet standing without exosuit (QSN)
qsn_data = readtable(fullfile(data_dir, 'QSN.xlsx'));

% Load the data for quiet standing with exosuit (QSW)
qsw_data = readtable(fullfile(data_dir, 'QSW.xlsx'));

% Load the data without exosuit assistance (NA)
na_data = readtable(fullfile(data_dir, 'NA.xlsx'));

% Load the data with exosuit assistance (WA)
wa_data = readtable(fullfile(data_dir, 'WA.xlsx'));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%----------------Preprocessing--------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Step 1: Isolate the O2 and CO2 data for the quiet standing period and convert to SI units
%%

o2_conversion_factor = 1e-6 / 60; 
co2_conversion_factor = 1e-6 / 60; 

% % Conversion factor for ml/min to m³/s
qsn_o2 = qsn_data.VO2 * o2_conversion_factor; % Convert to L/min
qsn_co2 = qsn_data.VCO2 * co2_conversion_factor; % Convert to L/min


% Convert O2 and CO2 data for QSW to SI units
qsw_o2 = qsw_data.VO2 * o2_conversion_factor; % Convert to L/min
qsw_co2 = qsw_data.VCO2 * co2_conversion_factor; % Convert to L/min


% Print values for the first dataset (qsn_data)
fprintf('Values for Dataset 1 (Without Exosuit):\n');
fprintf('VO2: %.2f m³/s\n', qsn_data.VO2);
fprintf('VCO2: %.2f m³/s\n', qsn_data.VCO2);

% Print values for the second dataset (qsw_data)
fprintf('Values for Dataset 2 (With Exosuit):\n');
fprintf('VO2: %.2f L/min\n', qsw_data.VO2);
fprintf('VCO2: %.2f L/min\n', qsw_data.VCO2);


% Print the converted O2 and CO2 data for QSN (Without Exosuit)
fprintf('Converted O2 data for QSN (Without Exosuit):\n');
disp(qsn_o2);

fprintf('Converted CO2 data for QSN (Without Exosuit):\n');
disp(qsn_co2);

% Print the converted O2 and CO2 data for QSW (With Exosuit)
fprintf('Converted O2 data for QSW (With Exosuit):\n');
disp(qsw_o2);

fprintf('Converted CO2 data for QSW (With Exosuit):\n');
disp(qsw_co2);


%%%%Step 2: Use Peronnet and Massicotte's equation to calculate the metabolic cost of quiet standing.
%%%


% Calculate the metabolic cost for each dataset during quiet standing
metabolic_cost_qsn = 16.89 * qsn_data.VO2 + 4.84 * qsn_data.VCO2;
metabolic_cost_qsw = 16.89 * qsw_data.VO2 + 4.84 * qsw_data.VCO2;

% Print the metabolic cost for both datasets
fprintf('Metabolic Cost for Quiet Standing (Without Exosuit):\n');
disp(metabolic_cost_qsn);

fprintf('Metabolic Cost for Quiet Standing (With Exosuit):\n');
disp(metabolic_cost_qsw);


% Convert metabolic cost to W/kg (assuming the subject's weight is 60 kg)
subject_weight_kg = 60;
metabolic_cost_per_kg_qsn = metabolic_cost_qsn / subject_weight_kg;
metabolic_cost_per_kg_qsw = metabolic_cost_qsw / subject_weight_kg;


% Print the metabolic cost for both datasets
fprintf('Metabolic Cost for Quiet Standing (Without Exosuit):\n');
disp(metabolic_cost_per_kg_qsn);

fprintf('Metabolic Cost for Quiet Standing (With Exosuit):\n');
disp(metabolic_cost_per_kg_qsw);

% Plot the metabolic cost over time for both datasets
figure;
plot(qsn_data.t, metabolic_cost_per_kg_qsn, 'b');
hold on;
plot(qsw_data.t, metabolic_cost_per_kg_qsw, 'r');
hold off;
xlabel('Time');
ylabel('Metabolic Cost (W/kg)');
title('Metabolic Cost of Quiet Standing');
legend('Without Exosuit', 'With Exosuit');



%%%%Step 3: Determine the calibration offset to use for the trial datasets.

MR_QSN = mean(metabolic_cost_qsn);
disp(metabolic_cost_qsn);
MR_QSW = mean(metabolic_cost_qsw);
disp(metabolic_cost_qsw);

% Determine the calibration offset
calibration_offset = mean(MR_QSW - MR_QSN);

% Print the calibration offset
fprintf('Calibration Offset: %.2f W/kg\n', calibration_offset);

%%Step 4: Plot the O2, CO2, and metabolic costs for this period of both datasets. Print the value 
%%%of the calibration offset on the plot. Take care that your plot is easy to read and interpret.


figure;

% Plot QSN O2 and CO2 data along with metabolic cost

subplot(2, 1, 1);
hold on;
plot(qsn_data.VO2, 'r', 'LineWidth', 2);
plot(qsn_data.VCO2, 'b', 'LineWidth', 2);
plot(metabolic_cost_qsn, 'c', 'LineWidth', 2);

% Add legend and labels
legend('O2', 'CO2', 'Metabolic Cost');
ylabel('Values');
title('QSN Dataset',sprintf('Calibration Offset: %.2f', calibration_offset));
grid on;
hold off;

% Plot QSW O2 and CO2 data along with metabolic cost
subplot(2, 1, 2);
hold on;
plot(qsw_data.VO2, 'r', 'LineWidth', 2);
plot(qsw_data.VCO2, 'b', 'LineWidth', 2);
plot(metabolic_cost_qsw, 'c', 'LineWidth', 2);

% Add legend and labels
legend('O2', 'CO2', 'Metabolic Cost');
ylabel('Values');
title('QSW Dataset');
grid on;
hold off;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%----------------Data Analysis--------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%Step 1: Calculate and plot the net metabolic cost over time for the experimental trials (with and without the exosuit).


% Define conversion factors to convert O2 and CO2 data to SI units
o2_conversion_factor = 1e-6 / 60;
co2_conversion_factor = 1e-6 / 60; % Replace this with the appropriate conversion factor for CO2 data

% Convert O2 and CO2 data for NA to SI units
na_o2 = na_data.VO2 * o2_conversion_factor; % Convert to L/min
na_co2 = na_data.VCO2 * co2_conversion_factor; % Convert to L/min

% % Conversion factor for ml/min to m³/s
wa_o2 = wa_data.VO2 * o2_conversion_factor; % Convert to L/min
wa_co2 = wa_data.VCO2 * co2_conversion_factor; % Convert to L/min

% Print values for the first dataset (qsn_data)
fprintf('Values for Dataset 1 (Without Exosuit):\n');
fprintf('VO2: %.2f m³/s\n', na_data.VO2);
fprintf('VCO2: %.2f m³/s\n', na_data.VCO2);

% Print values for the second dataset (qsw_data)
fprintf('Values for Dataset 2 (With Exosuit):\n');
fprintf('VO2: %.2f L/min\n', wa_data.VO2);
fprintf('VCO2: %.2f L/min\n', wa_data.VCO2);



% Calculate the metabolic cost for each dataset
net_metabolic_cost_without_exosuit = 16.89 * na_data.VO2 + 4.84 * na_data.VCO2;
net_metabolic_cost_with_exosuit = 16.89 * wa_data.VO2 + 4.84 * wa_data.VCO2;



%%%Step 2: Calculate the normalized cost of transport (COT) for each case.


%%EXO OFF

NA(:,1) = na_data.VO2*(10^-3/60);    % O2 in L/s
NA(:,2) = na_data.VCO2*(10^-3/60);    % CO2 in L/s

seg_NA = na_data.Marker;                % markers

%%EXO ON

WA(:,1) = wa_data.VO2*(10^-3/60);    % O2 in L/s
WA(:,2) = wa_data.VCO2*(10^-3/60);    % CO2 in L/s

seg_WA = wa_data.Marker;                % markers
    

% Compute the metabolic cost using the Peronnet and Massicotte's equation
% and subtract the cost at quiet standing
PM_NA = (net_metabolic_cost_without_exosuit - MR_QSN);
PM_WA = (net_metabolic_cost_with_exosuit - MR_QSW);


figure()
plot(PM_NA(find(seg_NA == 1):find(seg_NA == 2)),'LineWidth', 2); hold on;
plot(PM_WA(find(seg_WA == 1):find(seg_WA == 2)),'LineWidth', 2);
legend('NA','WA')
title('Net Metabolic Cost')

%Compute the mean walking speed by dividing the distance covered (400m) by
%the time (number of samples multiplied by 10 --> the COSMED gives 10 samples each second)

v_NA = 400/(10*(length(PM_NA(find(seg_NA == 1):find(seg_NA == 2)))));
v_WA = 400/(10*(length(PM_WA(find(seg_WA == 1):find(seg_WA == 2)))));

%Compute the cost of transport by normalizing the metabolic cost by the
%gravitational acceleration and the speed of walking

% first two minutes needs to be excluded
% Initialize cell arrays
COT_NA = PM_NA./(9.81 * v_NA);
COT_WA = PM_WA./(9.81 * v_WA);

NA_mean = mean(COT_NA);
WA_mean = mean(COT_WA);


%%%%%Step 3: Plot the COT over time for each case. Print on the plot the mean COT and mean 
%%walking speed for each case. Calculate and print the metabolic cost savings as a percent 
%%change when using the exosuit

% Plot COT over time for EXO OFF and EXO ON
figure;
% Create text boxes for mean COT and mean walking speed
annotation('textbox', [0.2, 0.7, 0.1, 0.1], 'String', sprintf('Mean COT for Case 1: %.2f', NA_mean), 'Color', 'b','FontSize',7);
annotation('textbox', [0.2, 0.6, 0.1, 0.1], 'String', sprintf('Mean COT for Case 2: %.2f', WA_mean), 'Color', 'r','FontSize',7);
annotation('textbox', [0.2, 0.5, 0.1, 0.1], 'String', sprintf('Mean Walking Speed for Case 1: %.2f m/s', v_NA), 'Color', 'b','FontSize',7);
annotation('textbox', [0.2, 0.4, 0.1, 0.1], 'String', sprintf('Mean Walking Speed for Case 2: %.2f m/s', v_WA), 'Color', 'r','FontSize',7);

plot(COT_NA, 'LineWidth', 2); hold on;
plot(COT_WA, 'LineWidth', 2); hold Off;
hold on;

% Set labels for each line
label1 = sprintf('MCOT %d', NA_mean);
label2 = sprintf('MCOT %d', WA_mean);
label3 = sprintf('mean walking speed %.2f', v_NA);
label4 = sprintf('mean walking speed %.2f', v_WA);

legend('No Exo', 'With Exo')
ylabel('Cost of Transport kJ/(Nm)', 'Interpreter', 'latex', 'FontSize', 10)
xlabel('Samples', 'Interpreter', 'latex', 'FontSize', 10)
title('Cost of Transport Over Time')
grid on;

% Adjust the figure size for better visibility
fig = gcf; 
ax = gca; 
fig.Position(3) = 1000; 
set(gca, 'TickLabelInterpreter', 'Latex', 'FontSize', 5); 
set(gcf, 'color', 'white'); 
set(gca, 'box', 'off');

hold off;

%Compute the saving granted by the use of the exosuit
sav = ((NA_mean - WA_mean)/NA_mean)*100;

% Print the metabolic cost savings
fprintf('Metabolic Cost Savings with Exosuit: %.2f%%\n', sav);

