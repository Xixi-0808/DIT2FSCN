% 
% %% 清空环境
% tic; clc; clear; close all; format compact
% % 固定随机种子,使其训练结果不变 
% setdemorandstream(pi);
% 
% %% 加载数据
% [All_data, Txt] = xlsread('2021.3.28数据.xlsx', 1);
% [row, col] = size(All_data);
% 
% %% 选择辅助变量为烟气含氧量预测的输入变量
% % 进料器速度
% Waste_inlet_flow_Keywords = { '进料器左内侧速度',['进料器左外侧' ...
%     '' ...
%     '' ...
%     ' 速度'],'进料器右内侧速度','进料器右外侧速度' };
% index1 = find(contains(Txt(1,:), Waste_inlet_flow_Keywords) == 1);
% features_1 = mean(All_data(:, index1), 2);
% 
% % 检查进料器运行状态
% Wif_Start_Keywords = { '进料器运行' };
% index1_start = find(contains(Txt(1,:), Wif_Start_Keywords) == 1);
% Wif_Stop_Keywords = { '进料器停止' };
% index1_stop = find(contains(Txt(1,:), Wif_Stop_Keywords) == 1);
% Wif_flag = 1;
% for k = 1:row
%     if All_data(k, index1_stop) == 1
%         Wif_flag = 0;
%     end
%     if All_data(k, index1_start) == 1
%         Wif_flag = 1;
%     end
%     if Wif_flag == 0
%         features_1(k) = 0;
%     end
% end
% 
% % 干燥炉排速度
% Speed_grate_Keywords = { '干燥炉排左内侧速度','干燥炉排左外侧速度','干燥炉排右内侧速度','干燥炉排右外侧速度'};
% index1 = find(contains(Txt(1,:), Speed_grate_Keywords) == 1);
% features_2_1 = mean(All_data(:, index1), 2);
% Sg_Start_Keywords = { '干燥段炉排运行'};
% index1_start = find(contains(Txt(1,:), Sg_Start_Keywords) == 1);
% Sg_Stop_Keywords = { '干燥段炉排停止'};
% index1_stop = find(contains(Txt(1,:), Sg_Stop_Keywords) == 1);
% Sg_flag = 1;
% for k = 1:row
%     if All_data(k, index1_stop) == 1
%         Sg_flag = 0;
%     end
%     if All_data(k, index1_start) == 1
%         Sg_flag = 1;
%     end
%     if Sg_flag == 0
%         features_2_1(k) = 0;
%     end
% end
% 
% % 燃烧炉排速度
% Speed_grate_Keywords = { '燃烧炉排１左内侧速度','燃烧炉排１左外侧速度','燃烧炉排１右内侧速度','燃烧炉排１右外侧速度'};
% index1 = find(contains(Txt(1,:), Speed_grate_Keywords) == 1);
% features_2_2 = mean(All_data(:, index1), 2);
% Sg_Start_Keywords = { '燃烧1段炉排运行'};
% index1_start = find(contains(Txt(1,:), Sg_Start_Keywords) == 1);
% Sg_Stop_Keywords = { '燃烧1段炉排停止'};
% index1_stop = find(contains(Txt(1,:), Sg_Stop_Keywords) == 1);
% Sg_flag = 1;
% for k = 1:row
%     if All_data(k, index1_stop) == 1
%         Sg_flag = 0;
%     end
%     if All_data(k, index1_start) == 1
%         Sg_flag = 1;
%     end
%     if Sg_flag == 0
%         features_2_2(k) = 0;
%     end
% end
% 
% % 燃烧炉排速度
% Speed_grate_Keywords = { '燃烧炉排２左内侧速度','燃烧炉排２左外侧速度','燃烧炉排２右内侧速度','燃烧炉排２右外侧速度'};
% index1 = find(contains(Txt(1,:), Speed_grate_Keywords) == 1);
% features_2_3 = mean(All_data(:, index1), 2);
% Sg_Start_Keywords = { '燃烧2段炉排运行'};
% index1_start = find(contains(Txt(1,:), Sg_Start_Keywords) == 1);
% Sg_Stop_Keywords = { '燃烧2段炉排停止'};
% index1_stop = find(contains(Txt(1,:), Sg_Stop_Keywords) == 1);
% Sg_flag = 1;
% for k = 1:row
%     if All_data(k, index1_stop) == 1
%         Sg_flag = 0;
%     end
%     if All_data(k, index1_start) == 1
%         Sg_flag = 1;
%     end
%     if Sg_flag == 0
%         features_2_3(k) = 0;
%     end
% end
% 
% % 燃烬炉排速度
% Speed_grate_Keywords = { '燃烬炉排左内侧速度','燃烬炉排右内侧速度'};
% index1 = find(contains(Txt(1,:), Speed_grate_Keywords) == 1);
% features_2_4 = mean(All_data(:, index1), 2);
% Sg_Start_Keywords = { '燃烬段炉排运行'};
% index1_start = find(contains(Txt(1,:), Sg_Start_Keywords) == 1);
% Sg_Stop_Keywords = { '燃烬段炉排停止'};
% index1_stop = find(contains(Txt(1,:), Sg_Stop_Keywords) == 1);
% Sg_flag = 1;
% for k = 1:row
%     if All_data(k, index1_stop) == 1
%         Sg_flag = 0;
%     end
%     if All_data(k, index1_start) == 1
%         Sg_flag = 1;
%     end
%     if Sg_flag == 0
%         features_2_4(k) = 0;
%     end    
% end
% 
% % 绘制速度图
% figure
% plot(features_1, 'r')
% hold on
% plot(features_2_1, 'k')
% hold on
% plot(features_2_2, 'b')
% hold on
% plot(features_2_3, 'y')
% hold on
% plot(features_2_4, 'g')
% legend('进料器速度','干燥炉排速度','燃烧1段炉排速度','燃烧2段炉排速度','燃烬段炉排速度')
% xlabel('样本序号','fontsize',12)
% ylabel('速度(%)','fontsize',12)
% axis tight;
% set(gca, 'YLim', [-10 110]); % X轴的数据显示范围
% All_data = All_data(3001:10:13000, :);
% line([10001, 10001], [0, 100], 'color', 'r', 'linestyle', '--');
% line([13800, 13800], [0, 100], 'color', 'r', 'linestyle', '--');
% 
% [row, col] = size(All_data);
% % 主要空气流量
% Primary_air_flow_Keywords = { '干燥炉排左1空气流量','干燥炉排右1空气流量','干燥炉排左2空气流量','干燥炉排右2空气流量','燃烧段炉排左1-1段空气流量','燃烧段炉排右1-1段空气流量','燃烧段炉排左1-2段空气流量','燃烧段炉排右1-2段空气流量','燃烧段炉排左2-1段空气流量','燃烧段炉排右2-1段空气流量','燃烧段炉排左2-2段空气流量','燃烧段炉排右2-2段空气流量','燃烬段炉排左空气流量','燃烬段炉排右空气流量' };
% index1 = find(contains(Txt(1,:), Primary_air_flow_Keywords) == 1);
% features_3 = sum(All_data(:, index1), 2); % 这些标签的总和是一次风
% 
% % 主要空气流量 
% Primary_air_flow_Keywords = { '干燥炉排左1空气流量','干燥炉排右1空气流量','干燥炉排左2空气流量','干燥炉排右2空气流量'};
% index1 = find(contains(Txt(1,:), Primary_air_flow_Keywords) == 1);
% features_3_1 = sum(All_data(:, index1), 2); % 这些标签的总和是一次风
% 
% Primary_air_flow_Keywords = {'燃烧段炉排左1-1段空气流量','燃烧段炉排右1-1段空气流量','燃烧段炉排左1-2段空气流量','燃烧段炉排右1-2段空气流量'};
% index1 = find(contains(Txt(1,:), Primary_air_flow_Keywords) == 1);
% features_3_2 = sum(All_data(:, index1), 2); % 这些标签的总和是一次风
% 
% Primary_air_flow_Keywords = { '燃烧段炉排左2-1段空气流量','燃烧段炉排右2-1段空气流量','燃烧段炉排左2-2段空气流量','燃烧段炉排右2-2段空气流量' };
% index1 = find(contains(Txt(1,:), Primary_air_flow_Keywords) == 1);
% features_3_3 = sum(All_data(:, index1), 2); % 这些标签的总和是一次风
% 
% Primary_air_flow_Keywords = {'燃烬段炉排左空气流量','燃烬段炉排右空气流量' };
% index1 = find(contains(Txt(1,:), Primary_air_flow_Keywords) == 1);
% features_3_4 = sum(All_data(:, index1), 2); % 这些标签的总和是一次风
% 
% % 次要空气流量
% Secondary_air_flow_Keywords = { '二次风流量' };
% index1 = find(contains(Txt(1,:), Secondary_air_flow_Keywords) == 1);
% features_4 = All_data(:, index1);
% 
% others_flow_Keywords = {'干燥段炉排进口空气温度','燃烧段炉排进口空气温度(燃1-1, 2+2-1)','一次空气加热器出口空气温度(燃2-2+燃烬)','炉膛负压','省煤器给水总量','喷入炉膛的尿素稀释液量','烟气氧气浓度1'};
% index1 = find(contains(Txt(1,:), others_flow_Keywords) == 1);
% features_5 = All_data(:, index1);
% 
% %% 选择烟气含氧量为输出变量
% Oxygen_content_Keywords = {'烟气Nox浓度'};
% index1 = find(contains(Txt(1,:), Oxygen_content_Keywords) == 1);
% features_out = All_data(:, index1);
% features = [features_5];
% Oxygenout = features_out;
% 
% interval = 1; % 采样间隔
% features = [features(2:interval:end, :) Oxygenout(1:interval:(end-1), :)];
% Oxygenout = Oxygenout(2:interval:end, :);
% Data = [features Oxygenout];
% 
% %% 3σ准则剔除数据
% outliers_line = [];
% for i = 1:size(Data, 2)
%     a = Data(:, i);
%     [h, p] = lillietest(a);
%     aa = mean(a);
%     sig = std(a); % 算出x的标准偏差。
%     m = zeros(1, length(a));
%     j = 1;
%     for t = 1:length(a)
%         m(t) = abs(a(t) - aa);
%         if m(t) > 3 * sig
%             Data(t, i) = 0; % 这里把异常值替换成了均值，也可以直接替换成其他的值如0等，然后进行剔除
%             outliers_line = [outliers_line t]; % 显示异常数据，如果没有异常数据的话将不会产生num变量
%             j = j + 1;
%         end
%     end
% end
% outliers_lines = unique(outliers_line);
% Data(outliers_lines, :) = [];
% features = Data(:, 1:end-1);
% Oxygenout = Data(:, end);
% [inputn, inputps] = mapminmax(features');
% [outputn, outputps] = mapminmax(Oxygenout');
% figure;
% for i = 1:size(inputn, 1)
%     plot(inputn(i, :));
%     hold on
% end
% hold on
% plot(outputn, 'LineWidth', 5)
% axis tight
% legend
% 
% % 各变量与烟气含氧量的皮尔森系数,归一化前后不影响结果
% Y = outputn;
% for i = 1:size(inputn, 1)
%     X = inputn(i, :);
%     coeff(i) = corr(X', Y'); 
% end
% len = length(Oxygenout);
% index = (1:len);
% % input_train = inputn(:, index(1:round(len*0.7)))';
% % output_train = outputn(index(1:round(len*0.7)))';
% % input_test = inputn(:, index(round(len*0.7)+1:end))';
% % output_test = outputn(index(round(len*0.7)+1:end))';
% input_train = features(index(1:round(len*0.7)),:);%训练样本输入
% output_train = Oxygenout(index(1:round(len*0.7)),:);%训练样本输出
% input_test = features(index(round(len*0.7)+1:end),:);%测试样本输入
% output_test = Oxygenout(index(round(len*0.7)+1:end),:);%测试样本输出
% % 归一化
% [inputps.max, inputps.min] = deal(max(input_train, [], 1), min(input_train, [], 1));
% [outputps.max, outputps.min] = deal(max(output_train, [], 1), min(output_train, [], 1));
% 
% TrainSamIn = (input_train - inputps.min) ./ (inputps.max - inputps.min);
% TrainSamOut = (output_train - outputps.min) ./ (outputps.max - outputps.min);
% TestSamIn = (input_test - inputps.min) ./ (inputps.max - inputps.min);
% TestSamOut = (output_test - outputps.min) ./ (outputps.max - outputps.min);
% TrainSamIn=TrainSamIn';
% TrainSamOut=TrainSamOut';
% TestSamIn=TestSamIn';
% TestSamOut=TestSamOut';
% [InDim, TrainSamNum] = size(TrainSamIn); % InDim输入维数
% OutDim = size(TrainSamOut, 1); % OutDim输出维数
% TestSamNum = size(TestSamIn, 2); % TestSamNum测试样本数
% 
% 
% %% 初始化参数
% M_max = 30;                  % 最大模糊规则数
% T_max = 250;                % 每次尝试生成的候选参数数
% epsilon = 0.01;             % 误差容忍度
% r = 0.9;                    % 监督机制超参数
% 
% % 监督机制的约束参数
% lambda_L = 0.000001;             % 下界正则化参数
% lambda_H = 0.000001;             % 上界正则化参数
% lambda_gen_L = 3;           % 下界候选参数生成范围上限
% lambda_gen_H = 3;           % 上界候选参数生成范围上限
% 
% % 使用自适应k均值方法确定最优k值和中心
% fprintf('\n=== 自适应k均值聚类过程 ===\n');
% [Fuzzy_RuleNum, Fuzzy_Center] = hybrid_density_kmeans(TrainSamIn);
% fprintf('确定的规则数量: %d\n', Fuzzy_RuleNum);
% 
% % 2. 使用FSCN的方式初始化宽度（固定std=1）
% std = ones(InDim, Fuzzy_RuleNum);  % 所有维度和规则都使用相同的宽度1
% 
% % 初始化模糊规则参数
% Fuzzy_Width_up = 1.2*std;   % 上界宽度0.7
% Fuzzy_Width_low = 1.1*std;  % 下界宽度0.6
% 
% % 后件参数初始化
% v_i_H = 1.7*ones(Fuzzy_RuleNum, 1); % 上界略高于下界
% v_i_L = 1.6*ones(Fuzzy_RuleNum, 1); % 初始化为随机小数值
% v_i = [v_i_L, v_i_H];
% 
% % 初始化历史误差数组
% historical_error_L = [];
% historical_error_H = [];
% 
% %% 训练阶段
% train_start = tic;
% % 初始化总体误差
% total_error_L = Inf;
% total_error_H = Inf;
% 
% % 初始化历史误差数组
% historical_error_L = [];
% historical_error_H = [];
% historical_error_L_N = [];
% historical_error_H_N = [];
% 
% % 初始化隐层输出矩阵
% h_L_opt = zeros(Fuzzy_RuleNum, TrainSamNum);
% h_H_opt = zeros(Fuzzy_RuleNum, TrainSamNum);
% disp(size(TrainSamIn)); disp(size(Fuzzy_Width_up)); disp(size(Fuzzy_Center));
% % 计算初始隐层输出
% for sample_idx = 1:TrainSamNum
%     % 计算每个样本的隶属度
%     u_up = zeros(InDim, Fuzzy_RuleNum);
%     u_low = zeros(InDim, Fuzzy_RuleNum);
%     
%     for i = 1:InDim
%         for j = 1:Fuzzy_RuleNum
%             u_up(i,j) = gaussmf(TrainSamIn(i,sample_idx), [Fuzzy_Width_up(i,j), Fuzzy_Center(i,j)]);
%             u_low(i,j) = gaussmf(TrainSamIn(i,sample_idx), [Fuzzy_Width_low(i,j), Fuzzy_Center(i,j)]);
%         end
%     end
%     
%     % 计算规则激活强度
%     n3_up = prod(u_up, 1);
%     n3_low = prod(u_low, 1);
%     
%     % 计算隐层输出
%     for j = 1:Fuzzy_RuleNum
%         h_L_opt(j,sample_idx) = 1 / (1 + exp(-n3_low(j) * v_i_L(j)));
%         h_H_opt(j,sample_idx) = 1 / (1 + exp(-n3_up(j) * v_i_H(j)));
%     end
% end
% 
% % 计算初始权重
% beta_L_opt = (h_L_opt * h_L_opt' + lambda_L * eye(Fuzzy_RuleNum)) \ (h_L_opt * TrainSamOut');
% beta_H_opt = (h_H_opt * h_H_opt' + lambda_H * eye(Fuzzy_RuleNum)) \ (h_H_opt * TrainSamOut');
% 
% % 计算初始输出
% TrainNetOut_L = (h_L_opt' * beta_L_opt)';
% TrainNetOut_H = (h_H_opt' * beta_H_opt)';
% 
% % 计算归一化后的初始误差
% total_error_L = sqrt(mean((TrainSamOut - TrainNetOut_L).^2));
% total_error_H = sqrt(mean((TrainSamOut - TrainNetOut_H).^2));
% 
% % 计算原始尺度的初始误差
% TrainNetOut_L_N = mapminmax('reverse', TrainNetOut_L, outputps);
% TrainNetOut_H_N = mapminmax('reverse', TrainNetOut_H, outputps);
% % TrainSamOutN = mapminmax('reverse', TrainSamOut, outputps);
% TrainSamOutN=output_train';
% total_error_L_N = sqrt(mean((TrainSamOutN - TrainNetOut_L_N).^2));
% total_error_H_N = sqrt(mean((TrainSamOutN - TrainNetOut_H_N).^2));
% 
% % 记录历史误差
% historical_error_L = [historical_error_L; total_error_L];
% historical_error_H = [historical_error_H; total_error_H];
% historical_error_L_N = [historical_error_L_N; total_error_L_N];
% historical_error_H_N = [historical_error_H_N; total_error_H_N];
% 
% fprintf('\n=== 初始训练误差 ===\n');
% fprintf('归一化后的误差：%.4f (下界), %.4f (上界)\n', total_error_L, total_error_H);
% fprintf('原始尺度误差：%.4f mg/m³ (下界), %.4f mg/m³ (上界)\n', total_error_L_N, total_error_H_N);
% 
% % 主循环
% while Fuzzy_RuleNum < M_max && (total_error_L > epsilon || total_error_H > epsilon)
%     % 生成新的模糊规则
%     [new_center, new_width_up, new_width_low] = generate_new_membership_function(Fuzzy_Center, Fuzzy_Width_up, Fuzzy_Width_low, InDim);
%     
%     % 更新隶属函数参数
%     Fuzzy_Center = [Fuzzy_Center, new_center];
%     Fuzzy_Width_up = [Fuzzy_Width_up, new_width_up];
%     Fuzzy_Width_low = [Fuzzy_Width_low, new_width_low];
%     
%     % 更新规则数
%     Fuzzy_RuleNum = Fuzzy_RuleNum + 1;
%     
%     % 计算新规则对所有样本的激活度
%     new_n3_up = zeros(1, TrainSamNum);
%     new_n3_low = zeros(1, TrainSamNum);
%     
%     for sample_idx = 1:TrainSamNum
%         SamIn = TrainSamIn(:, sample_idx);
%         new_u_up = zeros(InDim, 1);
%         new_u_low = zeros(InDim, 1);
%         
%         for i = 1:InDim
%             new_u_up(i) = gaussmf(SamIn(i), [new_width_up(i), new_center(i)]);
%             new_u_low(i) = gaussmf(SamIn(i), [new_width_low(i), new_center(i)]);
%         end
%         
%         new_n3_up(sample_idx) = prod(new_u_up);
%         new_n3_low(sample_idx) = prod(new_u_low);
%     end
%     
%     % 1. 随机生成候选后件参数（下界）
%     candidate_v_L = -lambda_gen_L + 2*lambda_gen_L*rand(T_max, 1);
%     valid_xi_L = [];
%     valid_candidate_v_L = [];
%     
%     % 计算现有规则的输出
%     existing_output_L = (h_L_opt' * beta_L_opt)';
%     
%     for t = 1:T_max
%         mu_M_L = (1-r)/(Fuzzy_RuleNum);
%         
%         % 计算新规则对所有样本的输出
%         new_rule_output = zeros(1, TrainSamNum);
%         for sample_idx = 1:TrainSamNum
%             new_rule_output(sample_idx) = 1 / (1 + exp(-new_n3_low(sample_idx) * candidate_v_L(t)));
%         end
%         
%         % 修改后的监督机制公式
%         xi_L = sum(((TrainSamOut - existing_output_L) .* new_rule_output).^2) / ...
%             ((norm(new_rule_output)^2 + lambda_L)^2 / (norm(new_rule_output)^2 + 2 * lambda_L)) - ...
%             (1 - r - mu_M_L) * norm(TrainSamOut - existing_output_L)^2;
%         
%         if xi_L >= 0
%             valid_candidate_v_L = [valid_candidate_v_L; candidate_v_L(t)];
%             valid_xi_L = [valid_xi_L; xi_L];
%         end
%     end
%     
%     % 2. 随机生成候选后件参数（上界）
%     candidate_v_H = -lambda_gen_H + 2*lambda_gen_H*rand(T_max, 1);
%     valid_xi_H = [];
%     valid_candidate_v_H = [];
%     
%     % 计算现有规则的输出
%     existing_output_H = (h_H_opt' * beta_H_opt)';
%     
%     for t = 1:T_max
%         mu_M_H = (1-r)/(Fuzzy_RuleNum);
%         
%         % 计算新规则对所有样本的输出
%         new_rule_output = zeros(1, TrainSamNum);
%         for sample_idx = 1:TrainSamNum
%             new_rule_output(sample_idx) = 1 / (1 + exp(-new_n3_up(sample_idx) * candidate_v_H(t)));
%         end
%         
%         % 修改后的监督机制公式
%         xi_H = sum(((TrainSamOut - existing_output_H) .* new_rule_output).^2) / ...
%             ((norm(new_rule_output)^2 + lambda_H)^2 / (norm(new_rule_output)^2 + 2 * lambda_H)) - ...
%             (1 - r - mu_M_H) * norm(TrainSamOut - existing_output_H)^2;
%         
%         if xi_H >= 0
%             valid_candidate_v_H = [valid_candidate_v_H; candidate_v_H(t)];
%             valid_xi_H = [valid_xi_H; xi_H];
%         end
%     end
%     
%     % 选择最优下界参数
%     if ~isempty(valid_xi_L)
%         [~, idx_max_L] = max(valid_xi_L);
%         v_M_L_opt = valid_candidate_v_L(idx_max_L);
%     else
%         v_M_L_opt = candidate_v_L(1);
%     end
%     
%     % 选择最优上界参数
%     if ~isempty(valid_xi_H)
%         [~, idx_max_H] = max(valid_xi_H);
%         v_M_H_opt = valid_candidate_v_H(idx_max_H);
%     else
%         v_M_H_opt = candidate_v_H(1);
%     end
%     
%     % 确保上界大于等于下界
%     if v_M_H_opt < v_M_L_opt
%         v_M_H_opt = v_M_L_opt;
%     end
%     
%     % 3. 更新模型参数
%     % 更新后件参数
%     v_i_L = [v_i_L; v_M_L_opt];
%     v_i_H = [v_i_H; v_M_H_opt];
%     
%     % 计算新的隐层输出
%     new_h_L = zeros(1, TrainSamNum);
%     new_h_H = zeros(1, TrainSamNum);
%     
%     for sample_idx = 1:TrainSamNum
%         new_h_L(sample_idx) = 1 / (1 + exp(-new_n3_low(sample_idx) * v_M_L_opt));
%         new_h_H(sample_idx) = 1 / (1 + exp(-new_n3_up(sample_idx) * v_M_H_opt));
%     end
%     
%     % 更新隐层输出矩阵
%     h_L_opt = [h_L_opt; new_h_L];
%     h_H_opt = [h_H_opt; new_h_H];
%     
%     % 更新权重
%     beta_L_opt = (h_L_opt * h_L_opt' + lambda_L * eye(Fuzzy_RuleNum)) \ (h_L_opt * TrainSamOut');
%     beta_H_opt = (h_H_opt * h_H_opt' + lambda_H * eye(Fuzzy_RuleNum)) \ (h_H_opt * TrainSamOut');
%     
%     % 计算新的输出
%     TrainNetOut_L = (h_L_opt' * beta_L_opt)';
%     TrainNetOut_H = (h_H_opt' * beta_H_opt)';
%     
%     % 计算归一化后的误差
%     total_error_L = sqrt(mean((TrainSamOut - TrainNetOut_L).^2));
%     total_error_H = sqrt(mean((TrainSamOut - TrainNetOut_H).^2));
%     
%     % 计算原始尺度的误差
%     TrainNetOut_L_N = mapminmax('reverse', TrainNetOut_L, outputps);
%     TrainNetOut_H_N = mapminmax('reverse', TrainNetOut_H, outputps);
%     
%     total_error_L_N = sqrt(mean((TrainSamOutN - TrainNetOut_L_N).^2));
%     total_error_H_N = sqrt(mean((TrainSamOutN - TrainNetOut_H_N).^2));
%     
%     % 记录历史误差
%     historical_error_L = [historical_error_L; total_error_L];
%     historical_error_H = [historical_error_H; total_error_H];
%     historical_error_L_N = [historical_error_L_N; total_error_L_N];
%     historical_error_H_N = [historical_error_H_N; total_error_H_N];
%     
%     fprintf('规则数: %d\n', Fuzzy_RuleNum);
%     fprintf('归一化后的误差：%.4f (下界), %.4f (上界)\n', total_error_L, total_error_H);
%     fprintf('原始尺度误差：%.4f mg/m³ (下界), %.4f mg/m³ (上界)\n', total_error_L_N, total_error_H_N);
% end
% 
% %% 第二阶段：SCN训练
% fprintf('\n=== 开始第二阶段训练 ===\n');
% 
% 
% 
% % 准备第二阶段输入
% H_L = h_L_opt';  % 转置为样本数×规则数
% H_H = h_H_opt';  % 转置为样本数×规则数
% 
% % 创建SCN实例
% scn = qiuqiul_SCN(H_L, H_H);
% scn.debug = false;  % 关闭调试信息
% 
% % 训练模型
% [scn, per] = scn.Regression(TrainSamOut');
% train_time = toc(train_start);
% 
% % 获取训练集和测试集预测结果
% train_fls.L = h_L_opt';
% train_fls.H = h_H_opt';
% TrainNetOut = scn.GetOutput(train_fls, TrainSamOut')';
% fprintf('训练时间: %.4f 秒\n', train_time);
% % 测试集调用
% test_start = tic;
% % 计算测试集的隐层输出
% h_L_test = zeros(Fuzzy_RuleNum, TestSamNum);
% h_H_test = zeros(Fuzzy_RuleNum, TestSamNum);
% 
% for k = 1:TestSamNum
%     % 计算测试样本的隶属度
%     u_test_up = zeros(InDim, Fuzzy_RuleNum);
%     u_test_low = zeros(InDim, Fuzzy_RuleNum);
%     
%     for i = 1:InDim
%         for j = 1:Fuzzy_RuleNum
%             u_test_up(i,j) = gaussmf(TestSamIn(i,k), [Fuzzy_Width_up(i,j), Fuzzy_Center(i,j)]);
%             u_test_low(i,j) = gaussmf(TestSamIn(i,k), [Fuzzy_Width_low(i,j), Fuzzy_Center(i,j)]);
%         end
%     end
%     
%     % 计算规则激活强度
%     n3_test_up = prod(u_test_up, 1);
%     n3_test_low = prod(u_test_low, 1);
%     
%     % 计算隐层输出
%     for j = 1:Fuzzy_RuleNum
%         h_L_test(j,k) = 1 / (1 + exp(-n3_test_low(j) * v_i_L(j)));
%         h_H_test(j,k) = 1 / (1 + exp(-n3_test_up(j) * v_i_H(j)));
%     end
% end
% test_fls.L = h_L_test';
% test_fls.H = h_H_test';
% TestNetOut = scn.GetOutput(test_fls, TestSamOut')';
% test_time = toc(test_start);
% fprintf('测试时间: %.4f 秒\n', test_time);
% %% 训练结果评估
% % 计算最终训练集预测结果
% TrainNetOutN=(outputps.max-outputps.min).*TrainNetOut+outputps.min;
% % TrainSamOutN = mapminmax('reverse', TrainSamOut, outputps);
% TrainSamOutN=output_train';
% % 计算训练集评价指标（归一化后）
% TrainError_Normalized = TrainSamOut - TrainNetOut;
% Train_RMSE_Normalized = sqrt(mean(TrainError_Normalized.^2));
% Train_MAPE_Normalized = mean(abs(TrainError_Normalized./TrainSamOut));
% Train_MAE_Normalized = mean(abs(TrainError_Normalized));
% 
% % 计算训练集评价指标（原始尺度）
% TrainError = TrainSamOutN - TrainNetOutN;
% Train_RMSE = sqrt(mean(TrainError.^2));
% Train_MAPE = mean(abs(TrainError./TrainSamOutN));
% Train_MAE = mean(abs(TrainError));
% 
% % 计算测试集预测结果
% TestNetOutN=(outputps.max-outputps.min).*TestNetOut+outputps.min;
% TestSamOutN = output_test';
% 
% % 计算测试集评价指标（归一化后）
% TestError_Normalized = TestSamOut - TestNetOut;
% Test_RMSE_Normalized = sqrt(mean(TestError_Normalized.^2));
% Test_MAPE_Normalized = mean(abs(TestError_Normalized./TestSamOut));
% Test_MAE_Normalized = mean(abs(TestError_Normalized));
% 
% % 计算测试集评价指标（原始尺度）
% TestError = TestSamOutN - TestNetOutN;
% Test_RMSE = sqrt(mean(TestError.^2));
% Test_MAPE = mean(abs(TestError./TestSamOutN));
% Test_MAE = mean(abs(TestError));
% 
% % 输出最终结果
% fprintf('\n=== 训练集评价指标 ===\n');
% fprintf('归一化后：\n');
% fprintf('Train Normalized RMSE: %.4f\n', Train_RMSE_Normalized);
% fprintf('Train Normalized MAPE: %.4f%%\n', Train_MAPE_Normalized*100);
% fprintf('Train Normalized MAE: %.4f\n', Train_MAE_Normalized);
% 
% fprintf('\n原始尺度：\n');
% fprintf('Train RMSE: %.4f mg/m³\n', Train_RMSE);
% fprintf('Train MAPE: %.4f%%\n', Train_MAPE*100);
% fprintf('Train MAE: %.4f mg/m³\n', Train_MAE);
% 
% fprintf('\n=== 测试集评价指标 ===\n');
% fprintf('归一化后：\n');
% fprintf('Test Normalized RMSE: %.4f\n', Test_RMSE_Normalized);
% fprintf('Test Normalized MAPE: %.4f%%\n', Test_MAPE_Normalized*100);
% fprintf('Test Normalized MAE: %.4f\n', Test_MAE_Normalized);
% 
% fprintf('\n原始尺度：\n');
% fprintf('Test RMSE: %.4f mg/m³\n', Test_RMSE);
% fprintf('Test MAPE: %.4f%%\n', Test_MAPE*100);
% fprintf('Test MAE: %.4f mg/m³\n', Test_MAE);
% 
% %% 绘图
% % 1. 训练集预测结果对比
% figure('Name', '训练集预测结果对比');
% subplot(2,2,1);
% plot(TrainSamOut, 'b-', 'LineWidth', 1.5, 'DisplayName', '实际值');
% hold on;
% plot(TrainNetOut, 'r--', 'LineWidth', 1.5, 'DisplayName', '预测值');
% xlabel('样本序号');
% ylabel('归一化后的NOx浓度');
% title('归一化后的训练集预测结果');
% legend('show');
% grid on;
% 
% subplot(2,2,2);
% plot(TrainSamOutN, 'b-', 'LineWidth', 1.5, 'DisplayName', '实际值');
% hold on;
% plot(TrainNetOutN, 'r--', 'LineWidth', 1.5, 'DisplayName', '预测值');
% xlabel('样本序号');
% ylabel('NOx浓度 (mg/m³)');
% title('原始尺度的训练集预测结果');
% legend('show');
% grid on;
% 
% subplot(2,2,3);
% scatter(TrainSamOut, TrainNetOut, 20, 'filled', 'b');
% hold on;
% plot([-1 1], [-1 1], 'r--', 'LineWidth', 1.5);
% xlabel('归一化后的实际值');
% ylabel('归一化后的预测值');
% title('归一化后的训练集散点图');
% grid on;
% 
% subplot(2,2,4);
% scatter(TrainSamOutN, TrainNetOutN, 20, 'filled', 'b');
% hold on;
% plot([min(TrainSamOutN) max(TrainSamOutN)], [min(TrainSamOutN) max(TrainSamOutN)], 'r--', 'LineWidth', 1.5);
% xlabel('实际NOx浓度 (mg/m³)');
% ylabel('预测NOx浓度 (mg/m³)');
% title('原始尺度的训练集散点图');
% grid on;
% 
% % 2. 测试集预测结果对比
% figure('Name', '测试集预测结果对比');
% subplot(2,2,1);
% plot(TestSamOut, 'b-', 'LineWidth', 1.5, 'DisplayName', '实际值');
% hold on;
% plot(TestNetOut, 'r--', 'LineWidth', 1.5, 'DisplayName', '预测值');
% xlabel('样本序号');
% ylabel('归一化后的NOx浓度');
% title('归一化后的测试集预测结果');
% legend('show');
% grid on;
% 
% subplot(2,2,2);
% plot(TestSamOutN, 'b-', 'LineWidth', 1.5, 'DisplayName', '实际值');
% hold on;
% plot(TestNetOutN, 'r--', 'LineWidth', 1.5, 'DisplayName', '预测值');
% xlabel('样本序号');
% ylabel('NOx浓度 (mg/m³)');
% title('原始尺度的测试集预测结果');
% legend('show');
% grid on;
% 
% subplot(2,2,3);
% scatter(TestSamOut, TestNetOut, 20, 'filled', 'b');
% hold on;
% plot([-1 1], [-1 1], 'r--', 'LineWidth', 1.5);
% xlabel('归一化后的实际值');
% ylabel('归一化后的预测值');
% title('归一化后的测试集散点图');
% grid on;
% 
% subplot(2,2,4);
% scatter(TestSamOutN, TestNetOutN, 20, 'filled', 'b');
% hold on;
% plot([min(TestSamOutN) max(TestSamOutN)], [min(TestSamOutN) max(TestSamOutN)], 'r--', 'LineWidth', 1.5);
% xlabel('实际NOx浓度 (mg/m³)');
% ylabel('预测NOx浓度 (mg/m³)');
% title('原始尺度的测试集散点图');
% grid on;
% 
% 
% figure('Name', '测试集预测结果对比');
% plot(TestSamOutN, 'b-o', 'LineWidth', 1.5, 'DisplayName', '实际值');
% hold on;
% plot(TestNetOutN, 'r-x', 'LineWidth', 1.5, 'DisplayName', '预测值');
% xlabel('样本序号');
% ylabel('NOx浓度（mg/m3）');
% title('t时刻的NOx浓度');
% legend('show');
% 
% % 在IT2-FLS-SCN模型代码末尾
% save_model_results(TestSamOutN, TestNetOutN, 'IT2FSCNs-gk');
% disp(toc);
% %% 辅助函数
% function [Fuzzy_RuleNum, Fuzzy_Center] = hybrid_density_kmeans(data)
%     % 1. 计算局部密度和距离矩阵
%     [local_density, dist_matrix, dc] = compute_local_density(data);
%     
%     % 2. 识别密度峰值
%     peak_points = find_density_peaks(local_density, dist_matrix);
%     
%     % 3. 确定初始k值
%     Fuzzy_RuleNum = length(peak_points);
%     if Fuzzy_RuleNum < 2  % 确保至少有2个聚类
%         Fuzzy_RuleNum = 10;
%     elseif Fuzzy_RuleNum > 50  % 添加最大聚类数限制
%         Fuzzy_RuleNum = 30;
%     end
%     
%     % 4. 使用确定的k值进行k-means聚类
%     [~, Fuzzy_Center] = kmeans(data', Fuzzy_RuleNum, 'Distance', 'sqeuclidean', ...
%         'MaxIter', 200, 'Replicates', 5);  % 增加重复次数提高稳定性
%     Fuzzy_Center = Fuzzy_Center';
%     
%     fprintf('自动确定的规则数量: ');
% end
% 
% function [local_density, dist_matrix, dc] = compute_local_density(data)
%     % 计算距离矩阵
%     dist_matrix = pdist2(data', data');
%     
%     % 估算截断距离dc (取所有距离的2%分位数)
%     all_dists = dist_matrix(triu(true(size(dist_matrix)), 1));
%     dc = prctile(all_dists, 30);
%     
%     % 按照公式计算局部密度ρi
%     n = size(data, 2);
%     local_density = zeros(n, 1);
%     
%     for i = 1:n
%         % 计算ρi = Σj c(dij - dc)
%         local_density(i) = sum(dist_matrix(i,:) < dc) - 1;  % 减1排除自身
%     end
% end
% 
% function peak_points = find_density_peaks(local_density, dist_matrix)
%     n = length(local_density);
%     delta = zeros(n, 1);  % δi距离
%     
%     % 计算每个点的δi (到密度更高点的最小距离)
%     for i = 1:n
%         higher_density_idx = find(local_density > local_density(i));
%         if isempty(higher_density_idx)
%             % 对于密度最高的点,取其到所有其他点的最大距离
%             delta(i) = max(dist_matrix(i,:));
%         else
%             % 对于其他点,取其到所有密度更高点的最小距离
%             delta(i) = min(dist_matrix(i,higher_density_idx));
%         end
%     end
%     
%     % 计算决策值 γi = ρi * δi
%     decision = local_density .* delta;
%     
%     % 使用自适应阈值选择密度峰值
%     threshold = mean(decision) + 2*std(decision);
%     peak_points = find(decision > threshold);
%     
%     % 如果没有找到足够的峰值点,降低阈值
%     if length(peak_points) < 2
%         threshold = mean(decision) + std(decision);
%         peak_points = find(decision > threshold);
%     end
% end
% 
% function [new_center, new_width_up, new_width_low] = generate_new_membership_function(Fuzzy_Center, Fuzzy_Width_up, Fuzzy_Width_low, InDim)
%     new_center = zeros(InDim, 1);
%     new_width_up = zeros(InDim, 1);
%     new_width_low = zeros(InDim, 1);
%     
%     % 1. 计算距离矩阵
%     num_rules = size(Fuzzy_Center, 2);
%     dist_matrix = zeros(num_rules);
%     for i = 1:num_rules
%         for j = i+1:num_rules
%             dist_matrix(i,j) = norm(Fuzzy_Center(:,i) - Fuzzy_Center(:,j));
%             dist_matrix(j,i) = dist_matrix(i,j);
%         end
%     end
%     
%     % 2. 计算每对规则之间的空白度评分
%     vacancy_scores = zeros(num_rules);
%     for i = 1:num_rules
%         for j = i+1:num_rules
%             % 计算两个规则中心的中点
%             midpoint = (Fuzzy_Center(:,i) + Fuzzy_Center(:,j)) / 2;
%             
%             % 计算其他规则到这个中点的距离
%             distances_to_mid = zeros(1, num_rules);
%             for k = 1:num_rules
%                 if k ~= i && k ~= j
%                     distances_to_mid(k) = norm(Fuzzy_Center(:,k) - midpoint);
%                 end
%             end
%             
%             % 计算空白度评分
%             % 考虑两个因素：规则间距离和周围规则的密度
%             min_dist_to_others = min(distances_to_mid(distances_to_mid > 0));
%             vacancy_score = dist_matrix(i,j) * exp(-0.5 * min_dist_to_others / mean(dist_matrix(:)));
%             
%             vacancy_scores(i,j) = vacancy_score;
%             vacancy_scores(j,i) = vacancy_score;
%         end
%     end
%     
%     % 3. 选择空白度评分最高的规则对
%     [max_score, max_idx] = max(vacancy_scores(:));
%     [i_max, j_max] = ind2sub(size(vacancy_scores), max_idx);
%     
%     % 获取选中规则对之间的距离
%     selected_dist = dist_matrix(i_max, j_max);
%     
%     % 4. 生成新中心时考虑局部密度
%     alpha = rand();  % 随机插值系数
%     interpolated_center = Fuzzy_Center(:,i_max) * (1-alpha) + Fuzzy_Center(:,j_max) * alpha;
%     
%     % 计算局部密度，用于调整扰动大小
%     local_density = sum(exp(-pdist2(interpolated_center', Fuzzy_Center')));
%     density_factor = exp(-local_density / num_rules);
%     
%     % 根据局部密度调整扰动大小
%     perturbation = randn(InDim, 1) * 0.1 * selected_dist * density_factor;
%     new_center = interpolated_center + perturbation;
%     
%     % 计算上下界宽度比例
%     width_ratio = mean(Fuzzy_Width_low ./ Fuzzy_Width_up, 2);
%     
%     % 基于相邻规则的宽度计算新规则的宽度
%     local_width_up = (Fuzzy_Width_up(:,i_max) + Fuzzy_Width_up(:,j_max)) / 2;
%     local_width_low = (Fuzzy_Width_low(:,i_max) + Fuzzy_Width_low(:,j_max)) / 2;
%     
%     % 根据距离调整宽度
%     dist_factor = exp(-selected_dist/mean(dist_matrix(:)));
%     
%     % 计算新规则的宽度
%     new_width_up = local_width_up * (1 + dist_factor);
%     new_width_low = local_width_low * (1 + dist_factor);
%     
%     % 确保宽度在合理范围内
%     min_width_up = 0.1 * mean(Fuzzy_Width_up, 2);
%     min_width_low = 0.1 * mean(Fuzzy_Width_low, 2);
%     max_width_up = 2 * mean(Fuzzy_Width_up, 2);
%     
%     % 应用约束
%     new_width_up = min(max(new_width_up, min_width_up), max_width_up);
%     new_width_low = min(max(new_width_low, min_width_low), new_width_up);
%     
%     % 确保维持上下界宽度比例关系
%     if any(new_width_low ./ new_width_up > width_ratio)
%         new_width_low = new_width_up .* width_ratio;
%     end
% end
% 
% 
% 
% 
% 
% function [Width_up, Width_low] = compute_adaptive_widths(data, centers)
%     [n_dim, n_centers] = size(centers);
%     Width_up = zeros(n_dim, n_centers);
%     Width_low = zeros(n_dim, n_centers);
%     
%     % 计算全局标准差作为参考
%     global_std = std(data, 0, 2);
%     
%     % 计算每个样本到最近中心的距离，用于密度估计
%     D = pdist2(data', centers');
%     [min_dists, cluster_idx] = min(D, [], 2);
%     
%     for i = 1:n_centers
%         cluster_points = data(:, cluster_idx == i);
%         
%         % 1. 计算局部统计特征
%         local_std = std(cluster_points, 0, 2);
%         local_range = range(cluster_points, 2);
%         
%         % 2. 计算聚类特征
%         cluster_size = size(cluster_points, 2);
%         total_size = size(data, 2);
%         size_factor = sqrt(cluster_size / total_size);
%         
%         % 3. 自适应计算宽度基准值
%         base_width = zeros(n_dim, 1);
%         for d = 1:n_dim
%             if local_std(d) > 0
%                 base_width(d) = local_std(d) * (0.7 + 0.3 * (global_std(d) / local_std(d)));
%             else
%                 base_width(d) = global_std(d) * 0.5;
%             end
%         end
%         
%         % 4. 应用自适应因子
%         adaptive_factor = size_factor * (0.8 + 0.2 * (mean(min_dists(cluster_idx == i)) / mean(min_dists)));
%         
%         % 5. 计算上下界宽度
%         width_up = base_width * adaptive_factor * 1.2;
%         width_low = base_width * adaptive_factor * 0.8;
%         
%         % 6. 确保宽度在合理范围内
%         for d = 1:n_dim
%             max_width = local_range(d) * 0.5;
%             if max_width > 0
%                 width_up(d) = min(width_up(d), max_width);
%                 width_low(d) = min(width_low(d), width_up(d));
%             else
%                 width_up(d) = global_std(d) * 0.1;
%                 width_low(d) = global_std(d) * 0.08;
%             end
%             
%             % 确保最小宽度
%             min_width = global_std(d) * 0.01;
%             width_up(d) = max(width_up(d), min_width);
%             width_low(d) = max(width_low(d), min_width * 0.8);
%         end
%         
%         Width_up(:,i) = width_up;
%         Width_low(:,i) = width_low;
%     end
%     
%     % 全局归一化
%     width_range = max(max(Width_up)) - min(min(Width_low));
%     if width_range > 0
%         Width_up = Width_up / width_range;
%         Width_low = Width_low / width_range;
%     end
% end
% % 保存每个模型的测试结果
% function save_model_results(TestSamOut, TestNetOut, model_name)
%     results.actual = TestSamOut;
%     results.predicted = TestNetOut;
%     
%     % 创建统一的保存路径
%     save_path = '../NOX results/';
%     if ~exist(save_path, 'dir')
%         mkdir(save_path);
%     end
%     
%     % 保存结果
%     save([save_path, model_name, '_results.mat'], 'results');
% end





%% 清空环境与初始化
tic; clc; clear; close all; format compact
num_trials = 50;  % 50次独立试验
all_results = struct();  % 存储所有试验结果

%% 固定数据加载与预处理（只执行一次）
% 加载数据
[All_data, Txt] = xlsread('2021.3.28数据.xlsx', 1);
[row, col] = size(All_data);

%% 选择辅助变量为输入特征
% 进料器速度
Waste_inlet_flow_Keywords = {'进料器左内侧速度',['进料器左外侧速度'],'进料器右内侧速度','进料器右外侧速度'};
index1 = find(contains(Txt(1,:), Waste_inlet_flow_Keywords) == 1);
features_1 = mean(All_data(:, index1), 2);

% 进料器运行状态处理
Wif_Start_Keywords = {'进料器运行'};
index1_start = find(contains(Txt(1,:), Wif_Start_Keywords) == 1);
Wif_Stop_Keywords = {'进料器停止'};
index1_stop = find(contains(Txt(1,:), Wif_Stop_Keywords) == 1);
Wif_flag = 1;
for k = 1:row
    if All_data(k, index1_stop) == 1, Wif_flag = 0; end
    if All_data(k, index1_start) == 1, Wif_flag = 1; end
    if Wif_flag == 0, features_1(k) = 0; end
end

% 干燥炉排速度
Speed_grate_Keywords = {'干燥炉排左内侧速度','干燥炉排左外侧速度','干燥炉排右内侧速度','干燥炉排右外侧速度'};
index1 = find(contains(Txt(1,:), Speed_grate_Keywords) == 1);
features_2_1 = mean(All_data(:, index1), 2);
Sg_Start_Keywords = {'干燥段炉排运行'};
index1_start = find(contains(Txt(1,:), Sg_Start_Keywords) == 1);
Sg_Stop_Keywords = {'干燥段炉排停止'};
index1_stop = find(contains(Txt(1,:), Sg_Stop_Keywords) == 1);
Sg_flag = 1;
for k = 1:row
    if All_data(k, index1_stop) == 1, Sg_flag = 0; end
    if All_data(k, index1_start) == 1, Sg_flag = 1; end
    if Sg_flag == 0, features_2_1(k) = 0; end
end

% 燃烧1段炉排速度
Speed_grate_Keywords = {'燃烧炉排１左内侧速度','燃烧炉排１左外侧速度','燃烧炉排１右内侧速度','燃烧炉排１右外侧速度'};
index1 = find(contains(Txt(1,:), Speed_grate_Keywords) == 1);
features_2_2 = mean(All_data(:, index1), 2);
Sg_Start_Keywords = {'燃烧1段炉排运行'};
index1_start = find(contains(Txt(1,:), Sg_Start_Keywords) == 1);
Sg_Stop_Keywords = {'燃烧1段炉排停止'};
index1_stop = find(contains(Txt(1,:), Sg_Stop_Keywords) == 1);
Sg_flag = 1;
for k = 1:row
    if All_data(k, index1_stop) == 1, Sg_flag = 0; end
    if All_data(k, index1_start) == 1, Sg_flag = 1; end
    if Sg_flag == 0, features_2_2(k) = 0; end
end

% 燃烧2段炉排速度
Speed_grate_Keywords = {'燃烧炉排２左内侧速度','燃烧炉排２左外侧速度','燃烧炉排２右内侧速度','燃烧炉排２右外侧速度'};
index1 = find(contains(Txt(1,:), Speed_grate_Keywords) == 1);
features_2_3 = mean(All_data(:, index1), 2);
Sg_Start_Keywords = {'燃烧2段炉排运行'};
index1_start = find(contains(Txt(1,:), Sg_Start_Keywords) == 1);
Sg_Stop_Keywords = {'燃烧2段炉排停止'};
index1_stop = find(contains(Txt(1,:), Sg_Stop_Keywords) == 1);
Sg_flag = 1;
for k = 1:row
    if All_data(k, index1_stop) == 1, Sg_flag = 0; end
    if All_data(k, index1_start) == 1, Sg_flag = 1; end
    if Sg_flag == 0, features_2_3(k) = 0; end
end

% 燃烬炉排速度
Speed_grate_Keywords = {'燃烬炉排左内侧速度','燃烬炉排右内侧速度'};
index1 = find(contains(Txt(1,:), Speed_grate_Keywords) == 1);
features_2_4 = mean(All_data(:, index1), 2);
Sg_Start_Keywords = {'燃烬段炉排运行'};
index1_start = find(contains(Txt(1,:), Sg_Start_Keywords) == 1);
Sg_Stop_Keywords = {'燃烬段炉排停止'};
index1_stop = find(contains(Txt(1,:), Sg_Stop_Keywords) == 1);
Sg_flag = 1;
for k = 1:row
    if All_data(k, index1_stop) == 1, Sg_flag = 0; end
    if All_data(k, index1_start) == 1, Sg_flag = 1; end
    if Sg_flag == 0, features_2_4(k) = 0; end
end
All_data = All_data(3001:10:13000, :);
% 一次风流量
Primary_air_flow_Keywords = {'干燥炉排左1空气流量','干燥炉排右1空气流量','干燥炉排左2空气流量','干燥炉排右2空气流量',...
    '燃烧段炉排左1-1段空气流量','燃烧段炉排右1-1段空气流量','燃烧段炉排左1-2段空气流量','燃烧段炉排右1-2段空气流量',...
    '燃烧段炉排左2-1段空气流量','燃烧段炉排右2-1段空气流量','燃烧段炉排左2-2段空气流量','燃烧段炉排右2-2段空气流量',...
    '燃烬段炉排左空气流量','燃烬段炉排右空气流量'};
index1 = find(contains(Txt(1,:), Primary_air_flow_Keywords) == 1);
features_3 = sum(All_data(:, index1), 2);

% 二次风流量
Secondary_air_flow_Keywords = {'二次风流量'};
index1 = find(contains(Txt(1,:), Secondary_air_flow_Keywords) == 1);
features_4 = All_data(:, index1);

% 其他特征
others_flow_Keywords = {'干燥段炉排进口空气温度','燃烧段炉排进口空气温度(燃1-1, 2+2-1)',...
    '一次空气加热器出口空气温度(燃2-2+燃烬)','炉膛负压','省煤器给水总量','喷入炉膛的尿素稀释液量','烟气氧气浓度1'};
index1 = find(contains(Txt(1,:), others_flow_Keywords) == 1);
features_5 = All_data(:, index1);

%% 输出变量（烟气NOx浓度）
Oxygen_content_Keywords = {'烟气Nox浓度'};
index1 = find(contains(Txt(1,:), Oxygen_content_Keywords) == 1);
features_out = All_data(:, index1);

%% 数据预处理（固定划分，所有试验共享）
% 特征组合与滞后处理
features = [features_5];
Oxygenout = features_out;
interval = 1;
features = [features(2:interval:end, :) Oxygenout(1:interval:(end-1), :)];
Oxygenout = Oxygenout(2:interval:end, :);
Data = [features Oxygenout];

%% 3σ准则剔除数据
outliers_line = [];
for i = 1:size(Data, 2)
    a = Data(:, i);
    [h, p] = lillietest(a);
    aa = mean(a);
    sig = std(a); % 算出x的标准偏差。
    m = zeros(1, length(a));
    j = 1;
    for t = 1:length(a)
        m(t) = abs(a(t) - aa);
        if m(t) > 3 * sig
            Data(t, i) = 0; % 这里把异常值替换成了均值，也可以直接替换成其他的值如0等，然后进行剔除
            outliers_line = [outliers_line t]; % 显示异常数据，如果没有异常数据的话将不会产生num变量
            j = j + 1;
        end
    end
end
outliers_lines = unique(outliers_line);
Data(outliers_lines, :) = [];
features = Data(:, 1:end-1);
Oxygenout = Data(:, end);
[inputn, inputps] = mapminmax(features');
[outputn, outputps] = mapminmax(Oxygenout');
figure;
for i = 1:size(inputn, 1)
    plot(inputn(i, :));
    hold on
end
hold on
plot(outputn, 'LineWidth', 5)
axis tight
legend

% 各变量与烟气含氧量的皮尔森系数,归一化前后不影响结果
Y = outputn;
for i = 1:size(inputn, 1)
    X = inputn(i, :);
    coeff(i) = corr(X', Y'); 
end
len = length(Oxygenout);
index = (1:len);
% input_train = inputn(:, index(1:round(len*0.7)))';
% output_train = outputn(index(1:round(len*0.7)))';
% input_test = inputn(:, index(round(len*0.7)+1:end))';
% output_test = outputn(index(round(len*0.7)+1:end))';
input_train = features(index(1:round(len*0.7)),:);%训练样本输入
output_train = Oxygenout(index(1:round(len*0.7)),:);%训练样本输出
input_test = features(index(round(len*0.7)+1:end),:);%测试样本输入
output_test = Oxygenout(index(round(len*0.7)+1:end),:);%测试样本输出

% 归一化参数（固定，所有试验共享）
[inputps.max, inputps.min] = deal(max(input_train, [], 1), min(input_train, [], 1));
[outputps.max, outputps.min] = deal(max(output_train, [], 1), min(output_train, [], 1));

% 归一化空间数据（用于模型训练）
TrainSamIn_norm = (input_train - inputps.min) ./ (inputps.max - inputps.min);
TrainSamOut_norm = (output_train - outputps.min) ./ (outputps.max - outputps.min );
TestSamIn_norm = (input_test - inputps.min) ./ (inputps.max - inputps.min );
TestSamOut_norm = (output_test - outputps.min) ./ (outputps.max - outputps.min );

% 格式转换（归一化空间）
TrainSamIn_norm = TrainSamIn_norm';  % 特征维度×样本数
TrainSamOut_norm = TrainSamOut_norm';
TestSamIn_norm = TestSamIn_norm';
TestSamOut_norm = TestSamOut_norm';
[InDim, TrainSamNum] = size(TrainSamIn_norm);
OutDim = size(TrainSamOut_norm, 1);
TestSamNum = size(TestSamIn_norm, 2);

%% 初始化存储数组（区分归一化和原始空间）
% 训练集-归一化空间
train_rmse_norm_all = zeros(num_trials, 1);
train_mae_norm_all = zeros(num_trials, 1);
train_mape_norm_all = zeros(num_trials, 1);

% 训练集-原始空间
train_rmse_raw_all = zeros(num_trials, 1);
train_mae_raw_all = zeros(num_trials, 1);
train_mape_raw_all = zeros(num_trials, 1);

% 测试集-归一化空间
test_rmse_norm_all = zeros(num_trials, 1);
test_mae_norm_all = zeros(num_trials, 1);
test_mape_norm_all = zeros(num_trials, 1);

% 测试集-原始空间
test_rmse_raw_all = zeros(num_trials, 1);
test_mae_raw_all = zeros(num_trials, 1);
test_mape_raw_all = zeros(num_trials, 1);

% 时间统计
train_time_all = zeros(num_trials, 1);
test_time_all = zeros(num_trials, 1);

%% 50次独立试验循环
for trial = 1:num_trials
    fprintf('\n=== 第 %d/%d 次试验 ===\n', trial, num_trials);
    
    % 重置随机种子（保证独立性）
    setdemorandstream(pi + trial);
    
    %% 模型参数初始化
    M_max = 30;                  % 最大模糊规则数
    T_max = 250;                 % 候选参数数
    epsilon = 0.001;              % 误差容忍度
    r = 0.9;                     % 监督机制参数
    lambda_L = 1e-6;
    lambda_H = 1e-6;
    lambda_gen_L = 3;
    lambda_gen_H = 3;
    
    %% 第一阶段：IT2-FLS训练
    train_start = tic;
    
    % 自适应k均值确定规则数和中心
    [Fuzzy_RuleNum, Fuzzy_Center] = hybrid_density_kmeans(TrainSamIn_norm);
    fprintf('第%d次试验确定规则数: %d\n', trial, Fuzzy_RuleNum);
    
    % 初始化宽度
    Fuzzy_Width_up = 1.2 * ones(InDim, Fuzzy_RuleNum);
    Fuzzy_Width_low = 1 * ones(InDim, Fuzzy_RuleNum);
    
    % 后件参数初始化
    v_i_H = 1.7 * ones(Fuzzy_RuleNum, 1);
    v_i_L = 1.5 * ones(Fuzzy_RuleNum, 1);
    
    % 计算初始隐层输出
    h_L_opt = zeros(Fuzzy_RuleNum, TrainSamNum);
    h_H_opt = zeros(Fuzzy_RuleNum, TrainSamNum);
    for sample_idx = 1:TrainSamNum
        u_up = zeros(InDim, Fuzzy_RuleNum);
        u_low = zeros(InDim, Fuzzy_RuleNum);
        for i = 1:InDim
            for j = 1:Fuzzy_RuleNum
                u_up(i,j) = gaussmf(TrainSamIn_norm(i,sample_idx), [Fuzzy_Width_up(i,j), Fuzzy_Center(i,j)]);
                u_low(i,j) = gaussmf(TrainSamIn_norm(i,sample_idx), [Fuzzy_Width_low(i,j), Fuzzy_Center(i,j)]);
            end
        end
        n3_up = prod(u_up, 1);
        n3_low = prod(u_low, 1);
        for j = 1:Fuzzy_RuleNum
            h_L_opt(j,sample_idx) = 1 / (1 + exp(-n3_low(j) * v_i_L(j)));
            h_H_opt(j,sample_idx) = 1 / (1 + exp(-n3_up(j) * v_i_H(j)));
        end
    end
    
    % 初始权重计算
    beta_L_opt = (h_L_opt * h_L_opt' + lambda_L * eye(Fuzzy_RuleNum)) \ (h_L_opt * TrainSamOut_norm');
    beta_H_opt = (h_H_opt * h_H_opt' + lambda_H * eye(Fuzzy_RuleNum)) \ (h_H_opt * TrainSamOut_norm');
    
    % 初始输出与误差
    TrainNetOut_L_norm = (h_L_opt' * beta_L_opt)';  % 归一化空间训练集预测
    TrainNetOut_H_norm = (h_H_opt' * beta_H_opt)';
    total_error_L = sqrt(mean((TrainSamOut_norm - TrainNetOut_L_norm).^2));
    total_error_H = sqrt(mean((TrainSamOut_norm - TrainNetOut_H_norm).^2));
    
    % 迭代优化规则
    while Fuzzy_RuleNum < M_max && (total_error_L > epsilon || total_error_H > epsilon)
        % 生成新规则
        [new_center, new_width_up, new_width_low] = generate_new_membership_function(...
            Fuzzy_Center, Fuzzy_Width_up, Fuzzy_Width_low, InDim);
        
        % 更新隶属函数参数
        Fuzzy_Center = [Fuzzy_Center, new_center];
        Fuzzy_Width_up = [Fuzzy_Width_up, new_width_up];
        Fuzzy_Width_low = [Fuzzy_Width_low, new_width_low];
        Fuzzy_RuleNum = Fuzzy_RuleNum + 1;
        
        % 计算新规则激活度
        new_n3_up = zeros(1, TrainSamNum);
        new_n3_low = zeros(1, TrainSamNum);
        for sample_idx = 1:TrainSamNum
            SamIn = TrainSamIn_norm(:, sample_idx);
            new_u_up = zeros(InDim, 1);
            new_u_low = zeros(InDim, 1);
            for i = 1:InDim
                new_u_up(i) = gaussmf(SamIn(i), [new_width_up(i), new_center(i)]);
                new_u_low(i) = gaussmf(SamIn(i), [new_width_low(i), new_center(i)]);
            end
            new_n3_up(sample_idx) = prod(new_u_up);
            new_n3_low(sample_idx) = prod(new_u_low);
        end
        
        % 生成候选后件参数（下界）
        candidate_v_L = -lambda_gen_L + 2*lambda_gen_L*rand(T_max, 1);
        valid_xi_L = [];
        valid_candidate_v_L = [];
        existing_output_L = (h_L_opt' * beta_L_opt)';
        for t = 1:T_max
            mu_M_L = (1 - r) / Fuzzy_RuleNum;
            new_rule_output = 1 ./ (1 + exp(-new_n3_low * candidate_v_L(t)));
            xi_L = sum(((TrainSamOut_norm - existing_output_L) .* new_rule_output).^2) / ...
                ((norm(new_rule_output)^2 + lambda_L)^2 / (norm(new_rule_output)^2 + 2 * lambda_L)) - ...
                (1 - r - mu_M_L) * norm(TrainSamOut_norm - existing_output_L)^2;
            if xi_L >= 0
                valid_candidate_v_L = [valid_candidate_v_L; candidate_v_L(t)];
                valid_xi_L = [valid_xi_L; xi_L];
            end
        end
        
        % 生成候选后件参数（上界）
        candidate_v_H = -lambda_gen_H + 2*lambda_gen_H*rand(T_max, 1);
        valid_xi_H = [];
        valid_candidate_v_H = [];
        existing_output_H = (h_H_opt' * beta_H_opt)';
        for t = 1:T_max
            mu_M_H = (1 - r) / Fuzzy_RuleNum;
            new_rule_output = 1 ./ (1 + exp(-new_n3_up * candidate_v_H(t)));
            xi_H = sum(((TrainSamOut_norm - existing_output_H) .* new_rule_output).^2) / ...
                ((norm(new_rule_output)^2 + lambda_H)^2 / (norm(new_rule_output)^2 + 2 * lambda_H)) - ...
                (1 - r - mu_M_H) * norm(TrainSamOut_norm - existing_output_H)^2;
            if xi_H >= 0
                valid_candidate_v_H = [valid_candidate_v_H; candidate_v_H(t)];
                valid_xi_H = [valid_xi_H; xi_H];
            end
        end
        
        % 选择最优参数
        if ~isempty(valid_candidate_v_L)
            [~, idx_max_L] = max(valid_xi_L);
            v_M_L_opt = valid_candidate_v_L(idx_max_L);
        else
            v_M_L_opt = candidate_v_L(1);
        end
        if ~isempty(valid_candidate_v_H)
            [~, idx_max_H] = max(valid_xi_H);
            v_M_H_opt = valid_candidate_v_H(idx_max_H);
        else
            v_M_H_opt = candidate_v_H(1);
        end
        if v_M_H_opt < v_M_L_opt, v_M_H_opt = v_M_L_opt; end
        
        % 更新隐层输出和权重
        new_h_L = 1 ./ (1 + exp(-new_n3_low * v_M_L_opt));
        new_h_H = 1 ./ (1 + exp(-new_n3_up * v_M_H_opt));
        h_L_opt = [h_L_opt; new_h_L];
        h_H_opt = [h_H_opt; new_h_H];
        v_i_L = [v_i_L; v_M_L_opt];
        v_i_H = [v_i_H; v_M_H_opt];
        
        % 更新权重
        beta_L_opt = (h_L_opt * h_L_opt' + lambda_L * eye(Fuzzy_RuleNum)) \ (h_L_opt * TrainSamOut_norm');
        beta_H_opt = (h_H_opt * h_H_opt' + lambda_H * eye(Fuzzy_RuleNum)) \ (h_H_opt * TrainSamOut_norm');
        
        % 计算误差
        TrainNetOut_L_norm = (h_L_opt' * beta_L_opt)';
        TrainNetOut_H_norm = (h_H_opt' * beta_H_opt)';
        total_error_L = sqrt(mean((TrainSamOut_norm - TrainNetOut_L_norm).^2));
        total_error_H = sqrt(mean((TrainSamOut_norm - TrainNetOut_H_norm).^2));
    end
    
    %% 第二阶段：SCN训练
    H_L = h_L_opt';
    H_H = h_H_opt';
    scn = qiuqiul_SCN(H_L, H_H);
    scn.debug = false;
    [scn, ~] = scn.Regression(TrainSamOut_norm');
    train_time = toc(train_start);
    train_time_all(trial) = train_time;
    fprintf('第%d次试验训练时间: %.4f 秒\n', trial, train_time);
    
    %% 测试阶段
    test_start = tic;
    
    % 计算测试集的隐层输出
    h_L_test = zeros(Fuzzy_RuleNum, TestSamNum);
    h_H_test = zeros(Fuzzy_RuleNum, TestSamNum);
    for k = 1:TestSamNum
        u_test_up = zeros(InDim, Fuzzy_RuleNum);
        u_test_low = zeros(InDim, Fuzzy_RuleNum);
        for i = 1:InDim
            for j = 1:Fuzzy_RuleNum
                u_test_up(i,j) = gaussmf(TestSamIn_norm(i,k), [Fuzzy_Width_up(i,j), Fuzzy_Center(i,j)]);
                u_test_low(i,j) = gaussmf(TestSamIn_norm(i,k), [Fuzzy_Width_low(i,j), Fuzzy_Center(i,j)]);
            end
        end
        n3_test_up = prod(u_test_up, 1);
        n3_test_low = prod(u_test_low, 1);
        for j = 1:Fuzzy_RuleNum
            h_L_test(j,k) = 1 / (1 + exp(-n3_test_low(j) * v_i_L(j)));
            h_H_test(j,k) = 1 / (1 + exp(-n3_test_up(j) * v_i_H(j)));
        end
    end
    
    % SCN预测（归一化空间）
    test_fls.L = h_L_test';
    test_fls.H = h_H_test';
    TestNetOut_norm = scn.GetOutput(test_fls, TestSamOut_norm')';
    test_time = toc(test_start);
    test_time_all(trial) = test_time;
    fprintf('第%d次试验测试时间: %.4f 秒\n', trial, test_time);
    
    %% 结果反归一化到原始空间
    % 训练集
    TrainNetOut_raw = (outputps.max - outputps.min) .* TrainNetOut_L_norm + outputps.min;
    TrainSamOut_raw = output_train';  % 原始真实值（未归一化）
    
    % 测试集
    TestNetOut_raw = (outputps.max - outputps.min) .* TestNetOut_norm + outputps.min;
    TestSamOut_raw = output_test';  % 原始真实值（未归一化）
    
    %% 计算评价指标（区分归一化和原始空间）
    % 1. 训练集-归一化空间
    TrainError_norm = TrainSamOut_norm - TrainNetOut_L_norm;
    train_rmse_norm = sqrt(mean(TrainError_norm.^2));
    train_mae_norm = mean(abs(TrainError_norm));
    nonzero_idx_norm = TrainSamOut_norm ~= 0;
    train_mape_norm = mean(abs(TrainError_norm(nonzero_idx_norm) ./ TrainSamOut_norm(nonzero_idx_norm))) * 100;
    
    % 2. 训练集-原始空间
    TrainError_raw = TrainSamOut_raw - TrainNetOut_raw;
    train_rmse_raw = sqrt(mean(TrainError_raw.^2));
    train_mae_raw = mean(abs(TrainError_raw));
    nonzero_idx_raw = TrainSamOut_raw ~= 0;
    train_mape_raw = mean(abs(TrainError_raw(nonzero_idx_raw) ./ TrainSamOut_raw(nonzero_idx_raw))) * 100;
    
    % 3. 测试集-归一化空间
    TestError_norm = TestSamOut_norm - TestNetOut_norm;
    test_rmse_norm = sqrt(mean(TestError_norm.^2));
    test_mae_norm = mean(abs(TestError_norm));
    nonzero_idx_t_norm = TestSamOut_norm ~= 0;
    test_mape_norm = mean(abs(TestError_norm(nonzero_idx_t_norm) ./ TestSamOut_norm(nonzero_idx_t_norm))) * 100;
    
    % 4. 测试集-原始空间
    TestError_raw = TestSamOut_raw - TestNetOut_raw;
    test_rmse_raw = sqrt(mean(TestError_raw.^2));
    test_mae_raw = mean(abs(TestError_raw));
    nonzero_idx_t_raw = TestSamOut_raw ~= 0;
    test_mape_raw = mean(abs(TestError_raw(nonzero_idx_t_raw) ./ TestSamOut_raw(nonzero_idx_t_raw))) * 100;
    
    %% 保存当前试验结果
    % 训练集
    train_rmse_norm_all(trial) = train_rmse_norm;
    train_mae_norm_all(trial) = train_mae_norm;
    train_mape_norm_all(trial) = train_mape_norm;
    
    train_rmse_raw_all(trial) = train_rmse_raw;
    train_mae_raw_all(trial) = train_mae_raw;
    train_mape_raw_all(trial) = train_mape_raw;
    
    % 测试集
    test_rmse_norm_all(trial) = test_rmse_norm;
    test_mae_norm_all(trial) = test_mae_norm;
    test_mape_norm_all(trial) = test_mape_norm;
    
    test_rmse_raw_all(trial) = test_rmse_raw;
    test_mae_raw_all(trial) = test_mae_raw;
    test_mape_raw_all(trial) = test_mape_raw;
    
    %% 打印当前试验关键指标
    fprintf('\n===== 归一化空间指标 =====\n');
    fprintf('训练集：RMSE=%.4f, MAE=%.4f, MAPE=%.2f%%\n', train_rmse_norm, train_mae_norm, train_mape_norm);
    fprintf('测试集：RMSE=%.4f, MAE=%.4f, MAPE=%.2f%%\n', test_rmse_norm, test_mae_norm, test_mape_norm);
    
    fprintf('\n===== 原始空间指标 =====\n');
    fprintf('训练集：RMSE=%.4f, MAE=%.4f, MAPE=%.2f%%\n', train_rmse_raw, train_mae_raw, train_mape_raw);
    fprintf('测试集：RMSE=%.4f, MAE=%.4f, MAPE=%.2f%%\n', test_rmse_raw, test_mae_raw, test_mape_raw);
end

%% 计算50次试验的统计结果
stats = struct();

% 训练集-归一化空间
stats.train_norm.rmse_mean = mean(train_rmse_norm_all);
stats.train_norm.rmse_std = std(train_rmse_norm_all(:));
stats.train_norm.mae_mean = mean(train_mae_norm_all);
stats.train_norm.mae_std = std(train_mae_norm_all(:));
stats.train_norm.mape_mean = mean(train_mape_norm_all);
stats.train_norm.mape_std = std(train_mape_norm_all(:));

% 训练集-原始空间
stats.train.raw.rmse_mean = mean(train_rmse_raw_all);
stats.train.raw.rmse_std = std(train_rmse_raw_all(:));
stats.train.raw.mae_mean = mean(train_mae_raw_all);
stats.train.raw.mae_std = std(train_mae_raw_all(:));
stats.train.raw.mape_mean = mean(train_mape_raw_all);
stats.train.raw.mape_std = std(train_mape_raw_all(:));

% 测试集-归一化空间
stats.test_norm.rmse_mean = mean(test_rmse_norm_all);
stats.test_norm.rmse_std = std(test_rmse_norm_all(:));
stats.test_norm.mae_mean = mean(test_mae_norm_all);
stats.test_norm.mae_std = std(test_mae_norm_all(:));
stats.test_norm.mape_mean = mean(test_mape_norm_all);
stats.test_norm.mape_std = std(test_mape_norm_all(:));

% 测试集-原始空间
stats.test.raw.rmse_mean = mean(test_rmse_raw_all);
stats.test.raw.rmse_std = std(test_rmse_raw_all(:));
stats.test.raw.mae_mean = mean(test_mae_raw_all);
stats.test.raw.mae_std = std(test_mae_raw_all(:));
stats.test.raw.mape_mean = mean(test_mape_raw_all);
stats.test.raw.mape_std = std(test_mape_raw_all(:));

% 时间统计
stats.time.train_mean = mean(train_time_all);
stats.time.train_std = std(train_time_all(:));
stats.time.test_mean = mean(test_time_all);
stats.time.test_std = std(test_time_all(:));

%% 打印50次试验统计结果
fprintf('\n\n=====================================\n');
fprintf('========= 50次独立试验统计结果 ==========\n');
fprintf('=====================================\n');

% 训练集-归一化空间
fprintf('\n------------ 训练集-归一化空间 ------------\n');
fprintf('RMSE: %.4f ± %.4f\n', stats.train_norm.rmse_mean, stats.train_norm.rmse_std);
fprintf('MAE:  %.4f ± %.4f\n', stats.train_norm.mae_mean, stats.train_norm.mae_std);
fprintf('MAPE: %.2f%% ± %.2f%%\n', stats.train_norm.mape_mean, stats.train_norm.mape_std);

% 训练集-原始空间
fprintf('\n------------ 训练集-原始空间 ------------\n');
fprintf('RMSE: %.4f ± %.4f mg/m³\n', stats.train.raw.rmse_mean, stats.train.raw.rmse_std);
fprintf('MAE:  %.4f ± %.4f mg/m³\n', stats.train.raw.mae_mean, stats.train.raw.mae_std);
fprintf('MAPE: %.2f%% ± %.2f%%\n', stats.train.raw.mape_mean, stats.train.raw.mape_std);

% 测试集-归一化空间
fprintf('\n------------ 测试集-归一化空间 ------------\n');
fprintf('RMSE: %.4f ± %.4f\n', stats.test_norm.rmse_mean, stats.test_norm.rmse_std);
fprintf('MAE:  %.4f ± %.4f\n', stats.test_norm.mae_mean, stats.test_norm.mae_std);
fprintf('MAPE: %.2f%% ± %.2f%%\n', stats.test_norm.mape_mean, stats.test_norm.mape_std);

% 测试集-原始空间
fprintf('\n------------ 测试集-原始空间 ------------\n');
fprintf('RMSE: %.4f ± %.4f mg/m³\n', stats.test.raw.rmse_mean, stats.test.raw.rmse_std);
fprintf('MAE:  %.4f ± %.4f mg/m³\n', stats.test.raw.mae_mean, stats.test.raw.mae_std);
fprintf('MAPE: %.2f%% ± %.2f%%\n', stats.test.raw.mape_mean, stats.test.raw.mape_std);

% 时间统计
fprintf('\n------------ 时间统计 ------------\n');
fprintf('平均训练时间: %.4f ± %.4f 秒\n', stats.time.train_mean, stats.time.train_std);
fprintf('平均测试时间: %.4f ± %.4f 秒\n', stats.time.test_mean, stats.time.test_std);

%% 保存结果
save('IT2FLS_SCN_50trials_NOx_full_results.mat', ...
     'stats', 'train_rmse_norm_all', 'train_rmse_raw_all', ...
     'test_rmse_norm_all', 'test_rmse_raw_all', ...
     'train_mae_norm_all', 'train_mae_raw_all', ...
     'test_mae_norm_all', 'test_mae_raw_all', ...
     'train_mape_norm_all', 'train_mape_raw_all', ...
     'test_mape_norm_all', 'test_mape_raw_all', ...
     'train_time_all', 'test_time_all');
fprintf('\n结果已保存至 IT2FLS_SCN_50trials_NOx_full_results.mat\n');
disp(['总运行时间: ', num2str(toc), ' 秒']);

%% 辅助函数
function [Fuzzy_RuleNum, Fuzzy_Center] = hybrid_density_kmeans(data)
    [local_density, dist_matrix, dc] = compute_local_density(data);
    peak_points = find_density_peaks(local_density, dist_matrix);
    Fuzzy_RuleNum = length(peak_points);
    if Fuzzy_RuleNum < 2
        Fuzzy_RuleNum = 10;
    elseif Fuzzy_RuleNum > 50
        Fuzzy_RuleNum = 30;
    end
    [~, Fuzzy_Center] = kmeans(data', Fuzzy_RuleNum, 'Distance', 'sqeuclidean', ...
        'MaxIter', 200, 'Replicates', 5);
    Fuzzy_Center = Fuzzy_Center';
end

function [local_density, dist_matrix, dc] = compute_local_density(data)
    dist_matrix = pdist2(data', data');
    all_dists = dist_matrix(triu(true(size(dist_matrix)), 1));
    dc = prctile(all_dists, 30);
    n = size(data, 2);
    local_density = zeros(n, 1);
    for i = 1:n
        local_density(i) = sum(dist_matrix(i,:) < dc) - 1;
    end
end

function peak_points = find_density_peaks(local_density, dist_matrix)
    n = length(local_density);
    delta = zeros(n, 1);
    for i = 1:n
        higher_density_idx = find(local_density > local_density(i));
        if isempty(higher_density_idx)
            delta(i) = max(dist_matrix(i,:));
        else
            delta(i) = min(dist_matrix(i,higher_density_idx));
        end
    end
    decision = local_density .* delta;
    threshold = mean(decision) + 2*std(decision);
    peak_points = find(decision > threshold);
    if length(peak_points) < 2
        threshold = mean(decision) + std(decision);
        peak_points = find(decision > threshold);
    end
end

function [new_center, new_width_up, new_width_low] = generate_new_membership_function(Fuzzy_Center, Fuzzy_Width_up, Fuzzy_Width_low, InDim)
    new_center = zeros(InDim, 1);
    new_width_up = zeros(InDim, 1);
    new_width_low = zeros(InDim, 1);
    num_rules = size(Fuzzy_Center, 2);
    if num_rules < 2
        new_center = randn(InDim, 1) * 0.1;
        new_width_up = 1.2 * ones(InDim, 1);
        new_width_low = 1.1 * ones(InDim, 1);
        return;
    end
    dist_matrix = zeros(num_rules);
    for i = 1:num_rules
        for j = i+1:num_rules
            dist_matrix(i,j) = norm(Fuzzy_Center(:,i) - Fuzzy_Center(:,j));
            dist_matrix(j,i) = dist_matrix(i,j);
        end
    end
    vacancy_scores = zeros(num_rules);
    for i = 1:num_rules
        for j = i+1:num_rules
            midpoint = (Fuzzy_Center(:,i) + Fuzzy_Center(:,j)) / 2;
            distances_to_mid = zeros(1, num_rules);
            for k = 1:num_rules
                if k ~= i && k ~= j
                    distances_to_mid(k) = norm(Fuzzy_Center(:,k) - midpoint);
                end
            end
            min_dist_to_others = min(distances_to_mid(distances_to_mid > 0));
            vacancy_score = dist_matrix(i,j) * exp(-0.5 * min_dist_to_others / mean(dist_matrix(:)));
            vacancy_scores(i,j) = vacancy_score;
            vacancy_scores(j,i) = vacancy_score;
        end
    end
    [~, max_idx] = max(vacancy_scores(:));
    [i_max, j_max] = ind2sub(size(vacancy_scores), max_idx);
    selected_dist = dist_matrix(i_max, j_max);
    alpha = rand();
    interpolated_center = Fuzzy_Center(:,i_max) * (1-alpha) + Fuzzy_Center(:,j_max) * alpha;
    local_density = sum(exp(-pdist2(interpolated_center', Fuzzy_Center')));
    density_factor = exp(-local_density / num_rules);
    perturbation = randn(InDim, 1) * 0.1 * selected_dist * density_factor;
    new_center = interpolated_center + perturbation;
    width_ratio = mean(Fuzzy_Width_low ./ Fuzzy_Width_up, 2);
    local_width_up = (Fuzzy_Width_up(:,i_max) + Fuzzy_Width_up(:,j_max)) / 2;
    local_width_low = (Fuzzy_Width_low(:,i_max) + Fuzzy_Width_low(:,j_max)) / 2;
    dist_factor = exp(-selected_dist/mean(dist_matrix(:)));
    new_width_up = local_width_up * (1 + dist_factor);
    new_width_low = local_width_low * (1 + dist_factor);
    min_width_up = 0.1 * mean(Fuzzy_Width_up, 2);
    min_width_low = 0.1 * mean(Fuzzy_Width_low, 2);
    for d = 1:InDim
        new_width_up(d) = max(new_width_up(d), min_width_up(d));
        new_width_low(d) = max(new_width_low(d), min_width_low(d));
        new_width_low(d) = min(new_width_low(d), new_width_up(d));
    end
end

function save_model_results(TestSamOut, TestNetOut, model_name)
    results.actual = TestSamOut;
    results.predicted = TestNetOut;
    save_path = '../NOX results/';
    if ~exist(save_path, 'dir')
        mkdir(save_path);
    end
    save([save_path, model_name, '_results.mat'], 'results');
end