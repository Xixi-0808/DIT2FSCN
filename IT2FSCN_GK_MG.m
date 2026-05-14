% %%%%%%%%%%%%%%%%%%%%%%%%数据集采用MG时间序列；测试集与训练集=1:3；自适应k均值聚类自动确定k值；改进的稀疏插值规则生长；
% %% 清空工作区
% clc;
% clear;
% close all;
% format long
% rand('seed',9); % 设置随机数种子，确保结果可复现9
% randn('seed',20); % 恢复默认的随机数生成器设置
% 
% %% 样本划分
% x = ones(1, 4000);
% x(1) = 1.2;
% for t = 18:4017
%     x(t+1) = 0.9 * x(t) + 0.2 * x(t-17) / (1 + x(t-17).^10);
% end
% 
% % 调整切片范围以适应新的样本数量
% start_idx = 136;
% train_end = start_idx + 750 - 1;
% test_end = train_end + 250;
% 
% x1 = x(start_idx:train_end); 
% x2 = x(start_idx-6:train_end-6);
% x3 = x(start_idx-12:train_end-12);
% x4 = x(start_idx-18:train_end-18);
% 
% % 测试集
% x5 = x(train_end+1:test_end);
% x6 = x(train_end-5:test_end-6);
% x7 = x(train_end-11:test_end-12);
% x8 = x(train_end-17:test_end-18);
% 
% % 训练样本
% TrainSamIn = [x1; x2; x3; x4];
% TrainSamOut = x(start_idx+1:train_end+1);
% 
% % 测试样本
% TestSamIn = [x5; x6; x7; x8];
% TestSamOut = x(train_end+2:test_end+1);
% 
% % 数据标准化
% [TrainSamIn_scaled, ps_X] = auto(TrainSamIn);  % 输入数据标准化
% [TrainSamOut_scaled, ps_Y] = auto(TrainSamOut);  % 输出数据标准化
% 
% % 使用训练集的归一化参数对测试集进行标准化
% TestSamIn_scaled = scale(TestSamIn, ps_X);
% TestSamOut_scaled = scale(TestSamOut, ps_Y);
% 
% % 获取输入维度
% InDim = size(TrainSamIn, 1);
% 
% % 更新样本数量
% TrainSamNum = size(TrainSamIn, 2);  % 应该是750
% TestSamNum = size(TestSamIn, 2);    % 应该是250
% 
% % 打印样本划分信息
% fprintf('训练集大小: %d\n', TrainSamNum);
% fprintf('测试集大小: %d\n', TestSamNum);
% fprintf('总样本数: %d\n', TrainSamNum + TestSamNum);
% 
% %% 初始化参数
% M_max = 23;                  % 最大模糊规则数
% T_max = 200;                  % 每次尝试生成的候选参数数
% epsilon = 0.03;              % 误差容忍度
% r = 0.5;                     % 监督机制超参数
% 
% % 监督机制的约束参数
% lambda_L = 0.01;             % 下界正则化参数
% lambda_H = 0.01;             % 上界正则化参数
% lambda_gen_L = 15;            % 下界候选参数生成范围上限
% lambda_gen_H = 15;            % 上界候选参数生成范围上限
% % 使用自适应k均值方法确定最优k值和中心
% fprintf('\n=== 自适应k均值聚类过程 ===\n');
% [Fuzzy_RuleNum, Fuzzy_Center] = hybrid_density_kmeans(TrainSamIn_scaled);
% fprintf('确定的规则数量: %d\n', Fuzzy_RuleNum);
% 
% 
% 
% % 2. 使用FSCN的方式初始化宽度（固定std=1）
% std = ones(InDim, Fuzzy_RuleNum);  % 所有维度和规则都使用相同的宽度1
% 
% 
% 
% 
% % 初始化模糊规则参数
% %%[Fuzzy_Width_up, Fuzzy_Width_low] = compute_adaptive_widths(TrainSamIn_scaled, Fuzzy_Center);
% % 3. 设置二型模糊的上下界宽度
% % 2. 初始化宽度（与FSCN一样使用固定宽度）
% Fuzzy_Width_up = 1.3*ones(InDim, Fuzzy_RuleNum);   % 上界宽度
% Fuzzy_Width_low = 0.55*ones(InDim, Fuzzy_RuleNum);  % 下界宽度
% 
% 
% 
% % 后件参数初始化
% v_i_L = -0.5 + rand(Fuzzy_RuleNum, 1); % 初始化为随机小数值
% v_i_H = v_i_L + 0.1 * rand(Fuzzy_RuleNum, 1); % 上界略高于下界，确保 v_i_H >= v_i_L
% v_i = [v_i_L, v_i_H];
% 
% % 初始化历史误差数组
% historical_error_L = [];
% historical_error_H = [];
% %% 训练阶段
% train_start = tic;
% % 初始化总体误差
% total_error_L = Inf;
% total_error_H = Inf;
% 
% % 初始输出准备
% current_output_L = zeros(1, TrainSamNum);
% current_output_H = zeros(1, TrainSamNum);
% 
% % 计算初始隐层输出和权重
% h_L_opt = zeros(Fuzzy_RuleNum, TrainSamNum);
% h_H_opt = zeros(Fuzzy_RuleNum, TrainSamNum);
% 
% % 预分配内存
% u_up = zeros(InDim, Fuzzy_RuleNum, TrainSamNum);
% u_low = zeros(InDim, Fuzzy_RuleNum, TrainSamNum);
% h_L_opt = zeros(Fuzzy_RuleNum, TrainSamNum);
% h_H_opt = zeros(Fuzzy_RuleNum, TrainSamNum);
% 
% % 前向传播的矩阵计算版本
% % 1. 一次性计算所有样本的隶属度
% u_up = zeros(InDim, Fuzzy_RuleNum, TrainSamNum);
% u_low = zeros(InDim, Fuzzy_RuleNum, TrainSamNum);
% 
% for i = 1:InDim
%     % 将输入数据和参数重塑为便于广播运算的形状
%     x_i = reshape(TrainSamIn_scaled(i,:), 1, 1, []);        % 1×1×TrainSamNum
%     centers = reshape(Fuzzy_Center(i,:), 1, [], 1);         % 1×Fuzzy_RuleNum×1
%     widths_up = reshape(Fuzzy_Width_up(i,:), 1, [], 1);     % 1×Fuzzy_RuleNum×1
%     widths_low = reshape(Fuzzy_Width_low(i,:), 1, [], 1);   % 1×Fuzzy_RuleNum×1
%     
%     % 使用广播运算一次性计算所有样本的隶属度（将高斯函数表示出来了）
%     diff_sq = bsxfun(@minus, x_i, centers).^2;             % 1×Fuzzy_RuleNum×TrainSamNum
%     u_up(i,:,:) = exp(-diff_sq./(2*widths_up.^2));
%     u_low(i,:,:) = exp(-diff_sq./(2*widths_low.^2));
% end
% 
% % 2. 一次性计算所有样本的激活强度
% n3_up = squeeze(prod(u_up, 1));    % Fuzzy_RuleNum×TrainSamNum
% n3_low = squeeze(prod(u_low, 1));  % Fuzzy_RuleNum×TrainSamNum
% 
% % 3. 一次性计算所有样本的隐层输出
% % 将v_i_L和v_i_H重塑为便于广播运算的形状
% v_i_L_reshaped = reshape(v_i_L, [], 1);  % Fuzzy_RuleNum×1
% v_i_H_reshaped = reshape(v_i_H, [], 1);  % Fuzzy_RuleNum×1
% 
% % 使用广播运算计算隐层输出
% h_L_opt = 1./(1 + exp(-bsxfun(@times, n3_low, v_i_L_reshaped)));  % Fuzzy_RuleNum×TrainSamNum
% h_H_opt = 1./(1 + exp(-bsxfun(@times, n3_up, v_i_H_reshaped)));   % Fuzzy_RuleNum×TrainSamNum
% 
% % 4. 计算权重（保持不变，因为本来就是矩阵运算）
% beta_L_opt = (h_L_opt * h_L_opt' + lambda_L * eye(Fuzzy_RuleNum)) \ (h_L_opt * TrainSamOut_scaled');
% beta_H_opt = (h_H_opt * h_H_opt' + lambda_H * eye(Fuzzy_RuleNum)) \ (h_H_opt * TrainSamOut_scaled');
% 
% % 计算初始输出和误差
% current_output_L = (h_L_opt' * beta_L_opt)';
% current_output_H = (h_H_opt' * beta_H_opt)';
% 
% % 计算初始总体误差
% total_error_L = norm(TrainSamOut_scaled - current_output_L, 2) / sqrt(TrainSamNum);
% total_error_H = norm(TrainSamOut_scaled - current_output_H, 2) / sqrt(TrainSamNum);
% 
% disp(['初始总体误差：', num2str(total_error_L), ' (下界), ', num2str(total_error_H), ' (上界)']);
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
%         % 计算新规则对所有样本的激活度
%     new_n3_up = zeros(1, TrainSamNum);
%     new_n3_low = zeros(1, TrainSamNum);
%     
%     for sample_idx = 1:TrainSamNum
%         SamIn = TrainSamIn_scaled(:, sample_idx);
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
%     %% 1. 随机生成候选后件参数（下界）
%     % 定义上下界范围
%     lower_bound_L = -lambda_gen_L;
%     upper_bound_L = lambda_gen_L;
%     
%     % 生成候选参数
%     candidate_v_L = lower_bound_L + (upper_bound_L - lower_bound_L) * rand(T_max, 1);
%     
%     valid_xi_L = [];
%     valid_candidate_v_L = [];
%     
%     % 计算现有规则的输出（不包括新规则）
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
%         xi_L = sum(((TrainSamOut_scaled - existing_output_L) .* new_rule_output).^2) / ...
%             ((norm(new_rule_output)^2 + lambda_L)^2 / (norm(new_rule_output)^2 + 2 * lambda_L)) - ...
%             (1 - r - mu_M_L) * norm(TrainSamOut_scaled - existing_output_L)^2;
%         
%         if xi_L >= 0
%             valid_candidate_v_L = [valid_candidate_v_L; candidate_v_L(t)];
%             valid_xi_L = [valid_xi_L; xi_L];
%         end
%     end
%     
%     % 选择最优下界参数
%     if ~isempty(valid_xi_L)
%         [~, idx_max_L] = max(valid_xi_L);
%         v_M_L_opt = valid_candidate_v_L(idx_max_L);
%     else
%         v_M_L_opt = candidate_v_L(1); % 如果没有有效候选，选择第一个
%     end
%         %% 2. 随机生成候选后件参数（上界）
%     lower_bound_H = -lambda_gen_H;
%     upper_bound_H = lambda_gen_H;
%     
%     candidate_v_H = lower_bound_H + (upper_bound_H - lower_bound_H) * rand(T_max, 1);
%     
%     valid_xi_H = [];
%     valid_candidate_v_H = [];
%     
%     % 计算现有规则的输（不包括新规则）
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
%         xi_H = sum(((TrainSamOut_scaled - existing_output_H) .* new_rule_output).^2) / ...
%             ((norm(new_rule_output)^2 + lambda_H)^2 / (norm(new_rule_output)^2 + 2 * lambda_H)) - ...
%             (1 - r - mu_M_H) * norm(TrainSamOut_scaled - existing_output_H)^2;
%         
%         if xi_H >= 0
%             valid_candidate_v_H = [valid_candidate_v_H; candidate_v_H(t)];
%             valid_xi_H = [valid_xi_H; xi_H];
%         end
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
%     %% 3. 更新模型参数
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
%     beta_L_opt = (h_L_opt * h_L_opt' + lambda_L * eye(Fuzzy_RuleNum)) \ (h_L_opt * TrainSamOut_scaled');
%     beta_H_opt = (h_H_opt * h_H_opt' + lambda_H * eye(Fuzzy_RuleNum)) \ (h_H_opt * TrainSamOut_scaled');
%     % 计算新的输出和误差
%     current_output_L = (h_L_opt' * beta_L_opt)';
%     current_output_H = (h_H_opt' * beta_H_opt)';
%     
% %     % 更新总体误差，除以样本数量归一化
% %     total_error_L = norm(TrainSamOut_scaled - current_output_L, 2)/sqrt(TrainSamNum);
% %     total_error_H = norm(TrainSamOut_scaled - current_output_H, 2)/sqrt(TrainSamNum);
% 
%     % 修改训练过程中的误差计算
%     total_error_L = sqrt(mean((TrainSamOut_scaled - current_output_L).^2));
%     total_error_H = sqrt(mean((TrainSamOut_scaled - current_output_H).^2));
% 
%     
%     % 记录历史误差
%     historical_error_L = [historical_error_L; total_error_L];
%     historical_error_H = [historical_error_H; total_error_H];
%     
%     disp(['规则数: ', num2str(Fuzzy_RuleNum), ...
%           ', 总体误差: ', num2str(total_error_L), ' (下界), ', ...
%           num2str(total_error_H), ' (上界)']);
% end
% 
% 
% 
% 
% 
% %% 第二阶段：SCN训练
% fprintf('\n=== 开始第二阶段训练 ===\n');
% 
% 
% % 准备第二阶段输入
% H_L = h_L_opt';  % 转置为样本数×则数
% H_H = h_H_opt';  % 转置为样本数×规则数
% 
% % 创建SCN实例
% scn = qiuqiul_SCN(H_L, H_H);
% scn.debug = false;  % 关闭调试信息
% % 训练模型
% [scn, per] = scn.Regression(TrainSamOut_scaled');
% train_time = toc(train_start);
% % 获取训练集预测结果
% train_fls.L = h_L_opt';
% train_fls.H = h_H_opt';
% TrainNetOut = scn.GetOutput(train_fls, TrainSamOut_scaled')';
% fprintf('训练时间: %.4f 秒\n', train_time);
% 
% 
% % 对测试集：
% test_start = tic;
% TestSamIn_scaled = TestSamIn_scaled';  % 确保维度正确
% 
% % 计算测试集的隐层输出
% h_L_test = zeros(Fuzzy_RuleNum, TestSamNum);
% h_H_test = zeros(Fuzzy_RuleNum, TestSamNum);
% 
% % 确保输入数据维度正确
% if size(TestSamIn_scaled, 1) ~= InDim
%     TestSamIn_scaled = TestSamIn_scaled';  % 只在需要时转置
% end
% 
% % 打印维度信息以检查
% fprintf('TestSamIn_scaled维度: %d × %d\n', size(TestSamIn_scaled,1), size(TestSamIn_scaled,2));
% fprintf('InDim: %d\n', InDim);
% fprintf('TestSamNum: %d\n', TestSamNum);
% % 打印维度信息
% fprintf('TrainSamIn维度: %d × %d\n', size(TrainSamIn,1), size(TrainSamIn,2));
% fprintf('TestSamIn维度: %d × %d\n', size(TestSamIn,1), size(TestSamIn,2));
% fprintf('h_L_opt维度: %d × %d\n', size(h_L_opt,1), size(h_L_opt,2));
% fprintf('h_H_opt维度: %d × %d\n', size(h_H_opt,1), size(h_H_opt,2));
% % 对每个测试样本计算IT2-FLS输出
% for sample_idx = 1:TestSamNum
%     SamIn = TestSamIn_scaled(:, sample_idx);
%     
%     % 计算隶属度
%     u_up = zeros(InDim, Fuzzy_RuleNum);
%     u_low = zeros(InDim, Fuzzy_RuleNum);
%     for i = 1:InDim
%         for j = 1:Fuzzy_RuleNum
%             u_up(i, j) = gaussmf(SamIn(i), [Fuzzy_Width_up(i, j), Fuzzy_Center(i, j)]);
%             u_low(i, j) = gaussmf(SamIn(i), [Fuzzy_Width_low(i, j), Fuzzy_Center(i, j)]);
%         end
%     end
%     
%     % 计算激活强度
%     n3_up = prod(u_up, 1);
%     n3_low = prod(u_low, 1);
%     
%     % 计算隐层输出
%     for i = 1:Fuzzy_RuleNum
%         h_L_test(i, sample_idx) = 1 / (1 + exp(-n3_low(i) * v_i_L(i)));
%         h_H_test(i, sample_idx) = 1 / (1 + exp(-n3_up(i) * v_i_H(i)));
%     end
% end
% 
% 
% 
% % 测试集调用
% test_fls.L = h_L_test';
% test_fls.H = h_H_test';
% TestNetOut = scn.GetOutput(test_fls, TestSamOut_scaled')';
% 
% test_time = toc(test_start);
% fprintf('测试时间: %.4f 秒\n', test_time);
% 
% % 反归一化
% TrainNetOut = rescale(TrainNetOut, ps_Y);
% TestNetOut = rescale(TestNetOut, ps_Y);
% 
% % 计算性能指标
% train_rmse = sqrt(mean((TrainSamOut - TrainNetOut).^2));
% train_mae = mean(abs(TrainSamOut - TrainNetOut));
% train_r2 = 1 - sum((TrainSamOut - TrainNetOut).^2)/sum((TrainSamOut - mean(TrainSamOut)).^2);
% train_mape = mean(abs((TrainSamOut - TrainNetOut)./TrainSamOut)) * 100;  % 添加MAPE计算
% 
% test_rmse = sqrt(mean((TestSamOut - TestNetOut).^2));
% test_mae = mean(abs(TestSamOut - TestNetOut));
% test_r2 = 1 - sum((TestSamOut - TestNetOut).^2)/sum((TestSamOut - mean(TestSamOut)).^2);
% test_mape = mean(abs((TestSamOut - TestNetOut)./TestSamOut)) * 100;  % 添加MAPE计算
% 
% % 设置全局字体为加粗的Times New Roman，字号为10
% set(0, 'DefaultAxesFontName', 'Times New Roman', 'DefaultAxesFontSize', 10, 'DefaultAxesFontWeight', 'bold');
% 
% % 绘制训练集结果
% figure;
% plot(1:TrainSamNum, TrainSamOut, 'b-', 'LineWidth', 1.5, 'DisplayName', '期望输出');
% hold on;
% plot(1:TrainSamNum, TrainNetOut, 'r--', 'LineWidth', 1.5, 'DisplayName', '预测输出');
% xlabel('样本序号');
% ylabel('输出值');
% title(sprintf('训练集预测结果对比\nRMSE=%.4f, MAE=%.4f, R^2=%.4f, MAPE=%.2f%%', ...
%     train_rmse, train_mae, train_r2, train_mape));
% legend('show');
% grid on;
% % 设置坐标轴边框和线条宽度
% set(gca, 'Box', 'on', 'LineWidth', 1);
% % 保存训练集图形
% print('train_result.pdf', '-dpdf', '-r600');
% 
% % 绘制测试集结果
% figure;
% plot(1:TestSamNum, TestSamOut, 'b-o', 'LineWidth', 1, 'DisplayName', 'Real Value');
% hold on;
% plot(1:TestSamNum, TestNetOut, 'r-x', 'LineWidth', 1, 'DisplayName', 'DIT2FSCN');
% xlabel('Testing Samples');
% ylabel('Output Value');
% legend('show');
% axis tight;
% grid off;
% % 设置坐标轴边框和线条宽度
% set(gca, 'Box', 'on', 'LineWidth', 1);
% % 保存测试集图形
% print('test_result.pdf', '-dpdf', '-r600');
% 
% % 计算测试集预测误差
% prediction_errors = TestSamOut - TestNetOut;
% 
% % 创建新的图形窗口用于显示预测误差
% figure;
% plot(1:TestSamNum, prediction_errors, 'k-', 'LineWidth', 1);
% xlabel('Testing samples');
% ylabel('Prediction errors');
% axis tight;
% grid on;
% % 设置坐标轴范围
% ylim([-0.025 0.025]);  % 根据实际误差范围调整
% xlim([0 250]);      % 与参考图保持一致的x轴范围
% % 设置坐标轴边框和线条宽度
% set(gca, 'Box', 'on', 'LineWidth', 1);
% axis tight;
% grid off;
% % 保存预测误差图形
% print('prediction_error.pdf', '-dpdf', '-r600');
% 
% % 打印评估指标
% fprintf('\n=== 模型性能评估 ===\n');
% fprintf('训练集评估指标：\n');
% fprintf('RMSE: %.4f\n', train_rmse);
% fprintf('MAE: %.8f\n', train_mae);
% fprintf('R²: %.4f\n', train_r2);
% fprintf('MAPE: %.2f%%\n', train_mape);  % 添加MAPE打印
% 
% fprintf('\n测试集评估指标：\n');
% fprintf('RMSE: %.8f\n', test_rmse);
% fprintf('MAE: %.4f\n', test_mae);
% fprintf('R²: %.4f\n', test_r2);
% fprintf('MAPE: %.2f%%\n', test_mape);  % 添加MAPE打印
% 
% % 添加训练误差曲线
% figure;
% plot(1:length(per.Error), per.Error, 'b-', 'LineWidth', 2);
% xlabel('迭代次数');
% ylabel('RMSE');
% title('训练误差曲线');
% grid on;
% % 在IT2-FLS-SCN模型代码末尾
% save_model_results(TestSamOut, TestNetOut, 'IT2FSCNs-gk');
% %% 辅助函数
% function [scaled_data, ps] = auto(data)
%     % 转置数据以匹配 mapminmax 的输入要求
%     [scaled_data, ps] = mapminmax(data, -1, 1);
% end
% 
% function scaled_data = scale(data, ps)
%     % 使用已有的归一化参数对新数据进行处理
%     scaled_data = mapminmax('apply', data, ps);
% end
% 
% function rescaled_data = rescale(scaled_data, ps)
%     % 反归一化
%     rescaled_data = mapminmax('reverse', scaled_data, ps);
% end
% %% 规则生长
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
% %% 规则库初始化
% function [Fuzzy_RuleNum, Fuzzy_Center] = hybrid_density_kmeans(data)
%     % 1. 计算局部密度和密度距离矩阵
%     [local_density, dist_matrix, dc] = compute_local_density(data);
%     
%     % 2. 识别密度峰值
%     peak_points = find_density_peaks(local_density, dist_matrix);
%     
%     % 3. 确定初始k值
%     Fuzzy_RuleNum = length(peak_points);
%     if Fuzzy_RuleNum < 2  % 确保至少有2个聚类
%         Fuzzy_RuleNum = 2;
%     end
%     
%     % 4. 使用确定的k值进行k-means聚类
%     [~, Fuzzy_Center] = kmeans(data', Fuzzy_RuleNum, 'Distance', 'sqeuclidean', ...
%         'MaxIter', 200, 'Replicates', 5);  % 增加重复次数提高稳定性
%     Fuzzy_Center = Fuzzy_Center';
%     
%     fprintf('自动确定的规则数量: %d (截断距离 dc = %.4f)\n', Fuzzy_RuleNum, dc);
% end
% 
% function [local_density, dist_matrix, dc] = compute_local_density(data)  %输入4*750的输入训练数据
%     % 计算距离矩阵
%     dist_matrix = pdist2(data', data');
%     
%     % 估算截断距离dc (取所有距离的2%分位数)
%     all_dists = dist_matrix(triu(true(size(dist_matrix)), 1));
%     dc = prctile(all_dists, 2);
%     
%     % 按照公式计算局部密度ρi
%     n = size(data, 2);
%     local_density = zeros(n, 1);
%     
%     for i = 1:n
%         % 计算ρi = Σj c(dij - dc)
%         local_density(i) = sum(dist_matrix(i,:) < dc) - 1;  % 减1排除自身，在距离矩阵的时候统计了自身和自身的距离0
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
%             % 不存在密度比当前点 i 更高的点时，取当前点到所有其他点的最大距离
%             delta(i) = max(dist_matrix(i,:));
%         else
%             % 当存在密度更高的点时，取当前点到所有密度更高点的最小距离
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
% 
% % 保存每个模型的测试结果
% function save_model_results(TestSamOut, TestNetOut, model_name)
%     results.actual = TestSamOut;
%     results.predicted = TestNetOut;
%     
%     % 创建统一的保存路径
%     save_path = '../MG results/';
%     if ~exist(save_path, 'dir')
%         mkdir(save_path);
%     end
%     
%     % 保存结果
%     save([save_path, model_name, '_results.mat'], 'results');
% end





%%%%%%%%%%%%%%%%%%%%%%%%数据集采用MG时间序列；测试集与训练集=1:3；自适应k均值聚类自动确定k值；改进的稀疏插值规则生长；
%% 清空工作区
clc;
clear;
close all;
format long

%% 进行50次独立试验
num_trials = 2;  % 50次独立试验

% 预分配存储所有试验结果的数组
train_rmse_all = zeros(1, num_trials);
train_mae_all = zeros(1, num_trials);
train_r2_all = zeros(1, num_trials);
train_mape_all = zeros(1, num_trials);
train_time_all = zeros(1, num_trials);

test_rmse_all = zeros(1, num_trials);
test_mae_all = zeros(1, num_trials);
test_r2_all = zeros(1, num_trials);
test_mape_all = zeros(1, num_trials);
test_time_all = zeros(1, num_trials);

rule_num_all = zeros(1, num_trials);  % 存储每次试验确定的规则数量

%% 生成MG时间序列（只需要生成一次）
x = ones(1, 4000);
x(1) = 1.2;
for t = 18:4017
    x(t+1) = 0.9 * x(t) + 0.2 * x(t-17) / (1 + x(t-17).^10);
end

% 调整切片范围以适应样本数量
start_idx = 136;
train_end = start_idx + 750 - 1;
test_end = train_end + 250;

% 训练集输入
x1 = x(start_idx:train_end); 
x2 = x(start_idx-6:train_end-6);
x3 = x(start_idx-12:train_end-12);
x4 = x(start_idx-18:train_end-18);

% 测试集输入
x5 = x(train_end+1:test_end);
x6 = x(train_end-5:test_end-6);
x7 = x(train_end-11:test_end-12);
x8 = x(train_end-17:test_end-18);

% 训练样本和测试样本（固定不变）
TrainSamIn = [x1; x2; x3; x4];
TrainSamOut = x(start_idx+1:train_end+1);
TestSamIn = [x5; x6; x7; x8];
TestSamOut = x(train_end+2:test_end+1);

% 数据标准化（只需要做一次）
[TrainSamIn_scaled, ps_X] = auto(TrainSamIn);
[TrainSamOut_scaled, ps_Y] = auto(TrainSamOut);
TestSamIn_scaled = scale(TestSamIn, ps_X);
TestSamOut_scaled = scale(TestSamOut, ps_Y);

% 获取输入维度和样本数量
InDim = size(TrainSamIn, 1);
TrainSamNum = size(TrainSamIn, 2);
TestSamNum = size(TestSamIn, 2);

% 打印样本划分信息
fprintf('训练集大小: %d\n', TrainSamNum);
fprintf('测试集大小: %d\n', TestSamNum);
fprintf('总样本数: %d\n', TrainSamNum + TestSamNum);

%% 多次试验循环
for trial = 1:num_trials
    fprintf('\n=== 第 %d/%d 次试验 ===\n', trial, num_trials);
    
    % 设置不同的随机数种子，保证试验独立性和可重复性
    rand('seed', 9 + trial);    % 基础种子9，每次试验递增
    randn('seed', 20 + trial);  % 基础种子20，每次试验递增
    
    %% 初始化参数
    M_max = 23;                  % 最大模糊规则数
    T_max = 300;                 % 每次尝试生成的候选参数数
    epsilon = 0.03;              % 误差容忍度
    r = 0.5;                     % 监督机制超参数
    
    % 监督机制的约束参数
    lambda_L = 0.01;             % 下界正则化参数
    lambda_H = 0.01;             % 上界正则化参数
    lambda_gen_L = 15;           % 下界候选参数生成范围上限
    lambda_gen_H = 15;           % 上界候选参数生成范围上限
    
    % 使用自适应k均值方法确定最优k值和中心
    fprintf('自适应k均值聚类过程...\n');
    [Fuzzy_RuleNum, Fuzzy_Center] = hybrid_density_kmeans(TrainSamIn_scaled);
    fprintf('确定的规则数量: %d\n', Fuzzy_RuleNum);
    rule_num_all(trial) = Fuzzy_RuleNum;  % 记录规则数量
    
    % 初始化宽度
    Fuzzy_Width_up = 1.3*ones(InDim, Fuzzy_RuleNum);   % 上界宽度
    Fuzzy_Width_low = 0.55*ones(InDim, Fuzzy_RuleNum);  % 下界宽度
    
    % 后件参数初始化
    v_i_L = -0.5 + rand(Fuzzy_RuleNum, 1);  % 初始化为随机小数值
    v_i_H = v_i_L + 0.1 * rand(Fuzzy_RuleNum, 1);  % 上界略高于下界
    
    % 初始化历史误差数组
    historical_error_L = [];
    historical_error_H = [];
    
    %% 训练阶段
    train_start = tic;
    
    % 初始化总体误差
    total_error_L = Inf;
    total_error_H = Inf;
    
    % 初始输出准备
    current_output_L = zeros(1, TrainSamNum);
    current_output_H = zeros(1, TrainSamNum);
    
    % 预分配内存
    u_up = zeros(InDim, Fuzzy_RuleNum, TrainSamNum);
    u_low = zeros(InDim, Fuzzy_RuleNum, TrainSamNum);
    h_L_opt = zeros(Fuzzy_RuleNum, TrainSamNum);
    h_H_opt = zeros(Fuzzy_RuleNum, TrainSamNum);
    
    % 前向传播的矩阵计算
    for i = 1:InDim
        x_i = reshape(TrainSamIn_scaled(i,:), 1, 1, []);
        centers = reshape(Fuzzy_Center(i,:), 1, [], 1);
        widths_up = reshape(Fuzzy_Width_up(i,:), 1, [], 1);
        widths_low = reshape(Fuzzy_Width_low(i,:), 1, [], 1);
        
        diff_sq = bsxfun(@minus, x_i, centers).^2;
        u_up(i,:,:) = exp(-diff_sq./(2*widths_up.^2));
        u_low(i,:,:) = exp(-diff_sq./(2*widths_low.^2));
    end
    
    % 计算激活强度
    n3_up = squeeze(prod(u_up, 1));    % Fuzzy_RuleNum×TrainSamNum
    n3_low = squeeze(prod(u_low, 1));  % Fuzzy_RuleNum×TrainSamNum
    
    % 计算隐层输出
    v_i_L_reshaped = reshape(v_i_L, [], 1);
    v_i_H_reshaped = reshape(v_i_H, [], 1);
    h_L_opt = 1./(1 + exp(-bsxfun(@times, n3_low, v_i_L_reshaped)));
    h_H_opt = 1./(1 + exp(-bsxfun(@times, n3_up, v_i_H_reshaped)));
    
    % 计算权重
    beta_L_opt = (h_L_opt * h_L_opt' + lambda_L * eye(Fuzzy_RuleNum)) \ (h_L_opt * TrainSamOut_scaled');
    beta_H_opt = (h_H_opt * h_H_opt' + lambda_H * eye(Fuzzy_RuleNum)) \ (h_H_opt * TrainSamOut_scaled');
    
    % 计算初始输出和误差
    current_output_L = (h_L_opt' * beta_L_opt)';
    current_output_H = (h_H_opt' * beta_H_opt)';
    total_error_L = sqrt(mean((TrainSamOut_scaled - current_output_L).^2));
    total_error_H = sqrt(mean((TrainSamOut_scaled - current_output_H).^2));
    
    % 主循环 - 规则生长
    while Fuzzy_RuleNum < M_max && (total_error_L > epsilon || total_error_H > epsilon)
        % 生成新的模糊规则
        [new_center, new_width_up, new_width_low] = generate_new_membership_function(Fuzzy_Center, Fuzzy_Width_up, Fuzzy_Width_low, InDim);
        
        % 更新隶属函数参数
        Fuzzy_Center = [Fuzzy_Center, new_center];
        Fuzzy_Width_up = [Fuzzy_Width_up, new_width_up];
        Fuzzy_Width_low = [Fuzzy_Width_low, new_width_low];
        Fuzzy_RuleNum = Fuzzy_RuleNum + 1;
        
        % 计算新规则对所有样本的激活度
        new_n3_up = zeros(1, TrainSamNum);
        new_n3_low = zeros(1, TrainSamNum);
        
        for sample_idx = 1:TrainSamNum
            SamIn = TrainSamIn_scaled(:, sample_idx);
            new_u_up = zeros(InDim, 1);
            new_u_low = zeros(InDim, 1);
            
            for i = 1:InDim
                new_u_up(i) = gaussmf(SamIn(i), [new_width_up(i), new_center(i)]);
                new_u_low(i) = gaussmf(SamIn(i), [new_width_low(i), new_center(i)]);
            end
            
            new_n3_up(sample_idx) = prod(new_u_up);
            new_n3_low(sample_idx) = prod(new_u_low);
        end
        
        %% 1. 随机生成候选后件参数（下界）
        lower_bound_L = -lambda_gen_L;
        upper_bound_L = lambda_gen_L;
        candidate_v_L = lower_bound_L + (upper_bound_L - lower_bound_L) * rand(T_max, 1);
        
        valid_xi_L = [];
        valid_candidate_v_L = [];
        existing_output_L = (h_L_opt' * beta_L_opt)';
        
        for t = 1:T_max
            mu_M_L = (1-r)/(Fuzzy_RuleNum);
            
            % 计算新规则对所有样本的输出
            new_rule_output = 1 ./ (1 + exp(-new_n3_low * candidate_v_L(t)));
            
            % 修改后的监督机制公式
            xi_L = sum(((TrainSamOut_scaled - existing_output_L) .* new_rule_output).^2) / ...
                ((norm(new_rule_output)^2 + lambda_L)^2 / (norm(new_rule_output)^2 + 2 * lambda_L)) - ...
                (1 - r - mu_M_L) * norm(TrainSamOut_scaled - existing_output_L)^2;
            
            if xi_L >= 0
                valid_candidate_v_L = [valid_candidate_v_L; candidate_v_L(t)];
                valid_xi_L = [valid_xi_L; xi_L];
            end
        end
        
        % 选择最优下界参数
        if ~isempty(valid_xi_L)
            [~, idx_max_L] = max(valid_xi_L);
            v_M_L_opt = valid_candidate_v_L(idx_max_L);
        else
            v_M_L_opt = candidate_v_L(1);
        end
        
        %% 2. 随机生成候选后件参数（上界）
        lower_bound_H = -lambda_gen_H;
        upper_bound_H = lambda_gen_H;
        candidate_v_H = lower_bound_H + (upper_bound_H - lower_bound_H) * rand(T_max, 1);
        
        valid_xi_H = [];
        valid_candidate_v_H = [];
        existing_output_H = (h_H_opt' * beta_H_opt)';
        
        for t = 1:T_max
            mu_M_H = (1-r)/(Fuzzy_RuleNum);
            
            % 计算新规则对所有样本的输出
            new_rule_output = 1 ./ (1 + exp(-new_n3_up * candidate_v_H(t)));
            
            % 修改后的监督机制公式
            xi_H = sum(((TrainSamOut_scaled - existing_output_H) .* new_rule_output).^2) / ...
                ((norm(new_rule_output)^2 + lambda_H)^2 / (norm(new_rule_output)^2 + 2 * lambda_H)) - ...
                (1 - r - mu_M_H) * norm(TrainSamOut_scaled - existing_output_H)^2;
            
            if xi_H >= 0
                valid_candidate_v_H = [valid_candidate_v_H; candidate_v_H(t)];
                valid_xi_H = [valid_xi_H; xi_H];
            end
        end
        
        % 选择最优上界参数
        if ~isempty(valid_xi_H)
            [~, idx_max_H] = max(valid_xi_H);
            v_M_H_opt = valid_candidate_v_H(idx_max_H);
        else
            v_M_H_opt = candidate_v_H(1);
        end
        
        % 确保上界大于等于下界
        if v_M_H_opt < v_M_L_opt
            v_M_H_opt = v_M_L_opt;
        end
        
        %% 3. 更新模型参数
        v_i_L = [v_i_L; v_M_L_opt];
        v_i_H = [v_i_H; v_M_H_opt];
        
        % 计算新的隐层输出
        new_h_L = 1 ./ (1 + exp(-new_n3_low * v_M_L_opt));
        new_h_H = 1 ./ (1 + exp(-new_n3_up * v_M_H_opt));
        
        % 更新隐层输出矩阵
        h_L_opt = [h_L_opt; new_h_L];
        h_H_opt = [h_H_opt; new_h_H];
        
        % 更新权重
        beta_L_opt = (h_L_opt * h_L_opt' + lambda_L * eye(Fuzzy_RuleNum)) \ (h_L_opt * TrainSamOut_scaled');
        beta_H_opt = (h_H_opt * h_H_opt' + lambda_H * eye(Fuzzy_RuleNum)) \ (h_H_opt * TrainSamOut_scaled');
        
        % 计算新的输出和误差
        current_output_L = (h_L_opt' * beta_L_opt)';
        current_output_H = (h_H_opt' * beta_H_opt)';
        total_error_L = sqrt(mean((TrainSamOut_scaled - current_output_L).^2));
        total_error_H = sqrt(mean((TrainSamOut_scaled - current_output_H).^2));
        
        % 记录历史误差
        historical_error_L = [historical_error_L; total_error_L];
        historical_error_H = [historical_error_H; total_error_H];
        
        disp(['规则数: ', num2str(Fuzzy_RuleNum), ...
              ', 总体误差: ', num2str(total_error_L), ' (下界), ', ...
              num2str(total_error_H), ' (上界)']);
    end
    
    %% 第二阶段：SCN训练
    fprintf('开始第二阶段训练...\n');
    
    % 准备第二阶段输入
    H_L = h_L_opt';  % 转置为样本数×规则数
    H_H = h_H_opt';  % 转置为样本数×规则数
    
    % 创建SCN实例
    scn = qiuqiul_SCN(H_L, H_H);
    scn.debug = false;  % 关闭调试信息
    
    % 训练模型并计时
    train_start_time = tic;
    [scn, per] = scn.Regression(TrainSamOut_scaled');
    train_time = toc(train_start_time);
    train_time_all(trial) = train_time;  % 记录训练时间
    fprintf('训练时间: %.4f 秒\n', train_time);
    
    % 获取训练集预测结果
    train_fls.L = h_L_opt';
    train_fls.H = h_H_opt';
    TrainNetOut_scaled = scn.GetOutput(train_fls, TrainSamOut_scaled')';
    
    %% 测试阶段
    test_start_time = tic;
    
    % 计算测试集的隐层输出
    h_L_test = zeros(Fuzzy_RuleNum, TestSamNum);
    h_H_test = zeros(Fuzzy_RuleNum, TestSamNum);
    
    % 确保输入数据维度正确
    if size(TestSamIn_scaled, 1) ~= InDim
        TestSamIn_scaled = TestSamIn_scaled';
    end
    
    % 对每个测试样本计算IT2-FLS输出
    for sample_idx = 1:TestSamNum
        SamIn = TestSamIn_scaled(:, sample_idx);
        
        % 计算隶属度
        u_up = zeros(InDim, Fuzzy_RuleNum);
        u_low = zeros(InDim, Fuzzy_RuleNum);
        for i = 1:InDim
            for j = 1:Fuzzy_RuleNum
                u_up(i, j) = gaussmf(SamIn(i), [Fuzzy_Width_up(i, j), Fuzzy_Center(i, j)]);
                u_low(i, j) = gaussmf(SamIn(i), [Fuzzy_Width_low(i, j), Fuzzy_Center(i, j)]);
            end
        end
        
        % 计算激活强度
        n3_up = prod(u_up, 1);
        n3_low = prod(u_low, 1);
        
        % 计算隐层输出
        for i = 1:Fuzzy_RuleNum
            h_L_test(i, sample_idx) = 1 / (1 + exp(-n3_low(i) * v_i_L(i)));
            h_H_test(i, sample_idx) = 1 / (1 + exp(-n3_up(i) * v_i_H(i)));
        end
    end
    
    % 测试集预测
    test_fls.L = h_L_test';
    test_fls.H = h_H_test';
    TestNetOut_scaled = scn.GetOutput(test_fls, TestSamOut_scaled')';
    
    % 测试计时结束
    test_time = toc(test_start_time);
    test_time_all(trial) = test_time;  % 记录测试时间
    fprintf('测试时间: %.4f 秒\n', test_time);
    
    %% 反归一化
    TrainNetOut = rescale(TrainNetOut_scaled, ps_Y);
    TestNetOut = rescale(TestNetOut_scaled, ps_Y);
    
    %% 计算性能指标
    % 训练集指标
    train_rmse = sqrt(mean((TrainSamOut - TrainNetOut).^2));
    train_mae = mean(abs(TrainSamOut - TrainNetOut));
    train_r2 = 1 - sum((TrainSamOut - TrainNetOut).^2)/sum((TrainSamOut - mean(TrainSamOut)).^2);
    train_mape = mean(abs((TrainSamOut - TrainNetOut)./TrainSamOut)) * 100;
    
    % 测试集指标
    test_rmse = sqrt(mean((TestSamOut - TestNetOut).^2));
    test_mae = mean(abs(TestSamOut - TestNetOut));
    test_r2 = 1 - sum((TestSamOut - TestNetOut).^2)/sum((TestSamOut - mean(TestSamOut)).^2);
    test_mape = mean(abs((TestSamOut - TestNetOut)./TestSamOut)) * 100;
    
    % 存储指标结果
    train_rmse_all(trial) = train_rmse;
    train_mae_all(trial) = train_mae;
    train_r2_all(trial) = train_r2;
    train_mape_all(trial) = train_mape;
    
    test_rmse_all(trial) = test_rmse;
    test_mae_all(trial) = test_mae;
    test_r2_all(trial) = test_r2;
    test_mape_all(trial) = test_mape;
    
    % 打印当前试验的指标
    fprintf('当前试验指标:\n');
    fprintf('训练集 RMSE: %.4f, MAE: %.4f, R²: %.4f, MAPE: %.2f%%\n', ...
        train_rmse, train_mae, train_r2, train_mape);
    fprintf('测试集 RMSE: %.4f, MAE: %.4f, R²: %.4f, MAPE: %.2f%%\n', ...
        test_rmse, test_mae, test_r2, test_mape);
end

 %% 计算统计结果（新增部分：定义results结构体并计算均值和标准差）
results = struct();

% 规则数量统计
results.rule_num_mean = mean(rule_num_all);
results.rule_num_std = std(rule_num_all);

% 训练集指标统计
results.train_rmse_mean = mean(train_rmse_all);
results.train_rmse_std = std(train_rmse_all);
results.train_mae_mean = mean(train_mae_all);
results.train_mae_std = std(train_mae_all);
results.train_r2_mean = mean(train_r2_all);
results.train_r2_std = std(train_r2_all);
results.train_mape_mean = mean(train_mape_all);
results.train_mape_std = std(train_mape_all);

% 测试集指标统计
results.test_rmse_mean = mean(test_rmse_all);
results.test_rmse_std = std(test_rmse_all);
results.test_mae_mean = mean(test_mae_all);
results.test_mae_std = std(test_mae_all);
results.test_r2_mean = mean(test_r2_all);
results.test_r2_std = std(test_r2_all);
results.test_mape_mean = mean(test_mape_all);
results.test_mape_std = std(test_mape_all);

% 时间统计
results.train_time_mean = mean(train_time_all);
results.train_time_std = std(train_time_all);
results.test_time_mean = mean(test_time_all);
results.test_time_std = std(test_time_all);
%% 打印统计结果
fprintf('\n\n=== 50次试验统计结果 ===\n');
fprintf('规则数量: 平均值 = %.2f, 标准差 = %.2f\n\n', ...
    results.rule_num_mean, results.rule_num_std);

fprintf('训练集指标:\n');
fprintf('RMSE: 平均值 = %.4f (±%.4f)\n', results.train_rmse_mean, results.train_rmse_std);
fprintf('MAE: 平均值 = %.4f (±%.4f)\n', results.train_mae_mean, results.train_mae_std);
fprintf('R²: 平均值 = %.4f (±%.4f)\n', results.train_r2_mean, results.train_r2_std);
fprintf('MAPE: 平均值 = %.2f%% (±%.2f%%)\n\n', results.train_mape_mean, results.train_mape_std);

fprintf('测试集指标:\n');
fprintf('RMSE: 平均值 = %.4f (±%.4f)\n', results.test_rmse_mean, results.test_rmse_std);
fprintf('MAE: 平均值 = %.4f (±%.4f)\n', results.test_mae_mean, results.test_mae_std);
fprintf('R²: 平均值 = %.4f (±%.4f)\n', results.test_r2_mean, results.test_r2_std);
fprintf('MAPE: 平均值 = %.2f%% (±%.2f%%)\n\n', results.test_mape_mean, results.test_mape_std);

fprintf('时间统计:\n');
fprintf('训练时间: 平均值 = %.4f 秒 (±%.4f)\n', results.train_time_mean, results.train_time_std);
fprintf('测试时间: 平均值 = %.4f 秒 (±%.4f)\n', results.test_time_mean, results.test_time_std);

%% 保存统计结果
save('50_trials_statistics.mat', 'results');
fprintf('\n统计结果已保存至 50_trials_statistics.mat\n');

%% 辅助函数（保持不变）
function [scaled_data, ps] = auto(data)
    [scaled_data, ps] = mapminmax(data, -1, 1);
end

function scaled_data = scale(data, ps)
    scaled_data = mapminmax('apply', data, ps);
end

function rescaled_data = rescale(scaled_data, ps)
    rescaled_data = mapminmax('reverse', scaled_data, ps);
end

function [new_center, new_width_up, new_width_low] = generate_new_membership_function(Fuzzy_Center, Fuzzy_Width_up, Fuzzy_Width_low, InDim)
    new_center = zeros(InDim, 1);
    new_width_up = zeros(InDim, 1);
    new_width_low = zeros(InDim, 1);
    
    % 1. 计算距离矩阵
    num_rules = size(Fuzzy_Center, 2);
    dist_matrix = zeros(num_rules);
    for i = 1:num_rules
        for j = i+1:num_rules
            dist_matrix(i,j) = norm(Fuzzy_Center(:,i) - Fuzzy_Center(:,j));
            dist_matrix(j,i) = dist_matrix(i,j);
        end
    end
    
    % 2. 计算每对规则之间的空白度评分
    vacancy_scores = zeros(num_rules);
    for i = 1:num_rules
        for j = i+1:num_rules
            % 计算两个规则中心的中点
            midpoint = (Fuzzy_Center(:,i) + Fuzzy_Center(:,j)) / 2;
            
            % 计算其他规则到这个中点的距离
            distances_to_mid = zeros(1, num_rules);
            for k = 1:num_rules
                if k ~= i && k ~= j
                    distances_to_mid(k) = norm(Fuzzy_Center(:,k) - midpoint);
                end
            end
            
            % 计算空白度评分
            min_dist_to_others = min(distances_to_mid(distances_to_mid > 0));
            vacancy_score = dist_matrix(i,j) * exp(-0.5 * min_dist_to_others / mean(dist_matrix(:)));
            
            vacancy_scores(i,j) = vacancy_score;
            vacancy_scores(j,i) = vacancy_score;
        end
    end
    
    % 3. 选择空白度评分最高的规则对
    [max_score, max_idx] = max(vacancy_scores(:));
    [i_max, j_max] = ind2sub(size(vacancy_scores), max_idx);
    
    % 获取选中规则对之间的距离
    selected_dist = dist_matrix(i_max, j_max);
    
    % 4. 生成新中心时考虑局部密度
    alpha = rand();  % 随机插值系数
    interpolated_center = Fuzzy_Center(:,i_max) * (1-alpha) + Fuzzy_Center(:,j_max) * alpha;
    
    % 计算局部密度，用于调整扰动大小
    local_density = sum(exp(-pdist2(interpolated_center', Fuzzy_Center')));
    density_factor = exp(-local_density / num_rules);
    
    % 根据局部密度调整扰动大小
    perturbation = randn(InDim, 1) * 0.1 * selected_dist * density_factor;
    new_center = interpolated_center + perturbation;
    
    % 计算上下界宽度比例
    width_ratio = mean(Fuzzy_Width_low ./ Fuzzy_Width_up, 2);
    
    % 基于相邻规则的宽度计算新规则的宽度
    local_width_up = (Fuzzy_Width_up(:,i_max) + Fuzzy_Width_up(:,j_max)) / 2;
    local_width_low = (Fuzzy_Width_low(:,i_max) + Fuzzy_Width_low(:,j_max)) / 2;
    
    % 根据距离调整宽度
    dist_factor = exp(-selected_dist/mean(dist_matrix(:)));
    
    % 计算新规则的宽度
    new_width_up = local_width_up * (1 + dist_factor);
    new_width_low = local_width_low * (1 + dist_factor);
    
    % 确保宽度在合理范围内
    min_width_up = 0.1 * mean(Fuzzy_Width_up, 2);
    min_width_low = 0.1 * mean(Fuzzy_Width_low, 2);
    max_width_up = 2 * mean(Fuzzy_Width_up, 2);
    
    % 应用约束
    new_width_up = min(max(new_width_up, min_width_up), max_width_up);
    new_width_low = min(max(new_width_low, min_width_low), new_width_up);
    
    % 确保维持上下界宽度比例关系
    if any(new_width_low ./ new_width_up > width_ratio)
        new_width_low = new_width_up .* width_ratio;
    end
end

function [Fuzzy_RuleNum, Fuzzy_Center] = hybrid_density_kmeans(data)
    % 1. 计算局部密度和密度距离矩阵
    [local_density, dist_matrix, dc] = compute_local_density(data);
    
    % 2. 识别密度峰值
    peak_points = find_density_peaks(local_density, dist_matrix);
    
    % 3. 确定初始k值
    Fuzzy_RuleNum = length(peak_points);
    if Fuzzy_RuleNum < 2  % 确保至少有2个聚类
        Fuzzy_RuleNum = 2;
    end
    
    % 4. 使用确定的k值进行k-means聚类
    [~, Fuzzy_Center] = kmeans(data', Fuzzy_RuleNum, 'Distance', 'sqeuclidean', ...
        'MaxIter', 200, 'Replicates', 5);  % 增加重复次数提高稳定性
    Fuzzy_Center = Fuzzy_Center';
    
    fprintf('自动确定的规则数量: %d (截断距离 dc = %.4f)\n', Fuzzy_RuleNum, dc);
end

function [local_density, dist_matrix, dc] = compute_local_density(data)
    % 计算距离矩阵
    dist_matrix = pdist2(data', data');
    
    % 估算截断距离dc (取所有距离的2%分位数)
    all_dists = dist_matrix(triu(true(size(dist_matrix)), 1));
    dc = prctile(all_dists, 2);
    
    % 按照公式计算局部密度ρi
    n = size(data, 2);
    local_density = zeros(n, 1);
    
    for i = 1:n
        % 计算ρi = Σj c(dij - dc)
        local_density(i) = sum(dist_matrix(i,:) < dc) - 1;  % 减1排除自身
    end
end

function peak_points = find_density_peaks(local_density, dist_matrix)
    n = length(local_density);
    delta = zeros(n, 1);  % δi距离
    
    % 计算每个点的δi (到密度更高点的最小距离)
    for i = 1:n
        higher_density_idx = find(local_density > local_density(i));
        if isempty(higher_density_idx)
            % 不存在密度更高的点时，取到所有其他点的最大距离
            delta(i) = max(dist_matrix(i,:));
        else
            % 存在密度更高的点时，取到所有密度更高点的最小距离
            delta(i) = min(dist_matrix(i,higher_density_idx));
        end
    end
    
    % 计算决策值 γi = ρi * δi
    decision = local_density .* delta;
    
    % 使用自适应阈值选择密度峰值
    threshold = mean(decision) + 2*std(decision);
    peak_points = find(decision > threshold);
    
    % 如果没有找到足够的峰值点,降低阈值
    if length(peak_points) < 2
        threshold = mean(decision) + std(decision);
        peak_points = find(decision > threshold);
    end
end

function save_model_results(TestSamOut, TestNetOut, model_name)
    results.actual = TestSamOut;
    results.predicted = TestNetOut;
    
    % 创建统一的保存路径
    save_path = '../MG results/';
    if ~exist(save_path, 'dir')
        mkdir(save_path);
    end
    
    % 保存结果
    save([save_path, model_name, '_results.mat'], 'results');
end