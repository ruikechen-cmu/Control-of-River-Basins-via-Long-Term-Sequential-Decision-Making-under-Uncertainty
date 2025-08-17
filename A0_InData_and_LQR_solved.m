% read data from csv
m_T      = readtable('reservoir_data.csv');
m_flows  = m_T{:,2:13};             % [n_years × 12]

n_years = size(m_flows,1);
days  = [31,28,31,30,31,30,31,31,30,31,30,31];

% unit conversion
taf2millm3         = 1000 * 1233.48 / 1e6;   % 1 TAF = 1000 acre-ft, 1 acre-ft ≈ 1 233.48 m³

T_w   = readtable('weekly_mean_std_by_day.csv');
v_day_mean_cfs = T_w.mean_inflow;        % [365×1]
cfs_to_m3s = 0.0283168466;
sec_per_day = 24*3600;

v_day_mean_m3 = v_day_mean_cfs * cfs_to_m3s * sec_per_day /1e6/30;
v_day          = v_day_mean_m3(:);           % 365×1
monthly_sum    = zeros(1,12);
idx            = 1;
for m = 1:12
    monthly_sum(m) = sum( v_day(idx:idx + days(m) - 1) );
    idx = idx + days(m);
end

% replicated cross all months → length 1×(12·n_years)
v_c    = repmat(monthly_sum, 1, n_years);

% monthly discount factor
gamma = 0.95^(1/12) ;

% number of steps
n_T = numel(v_c) ;

% long term cut
gamma_n_T = gamma^n_T;

% size of the state
n_X = 1 ;

% size of decision
n_U = 1 ;

% time in weeks
v_T = 1:n_T ;

% target values
phase_shift = 3; 
v_u_season = 1 + 0.5*sin(2*pi*((1:12)-phase_shift)/12);   % 1×12

% build a full‐length vector by repeating both the month‐means
%    and the seasonal shape
v_u_rep = repmat(v_u_season,1,n_years);                % seasonal multiplier

% scale so ∑u = ∑v_c exactly
v_u_tilde = v_u_rep * (sum(v_c)/sum(v_u_rep));  

% check:
sum(v_u_tilde) - sum(v_c) ;

cap_taf = 520.528;          % Unit：TAF 
cap_m3  = cap_taf * taf2millm3; % Change to be m^3，total capacity ≈642×10^6 m^3

% taget water level tilde x_tilde: stay 60% of reservoir
v_x_tilde = cap_m3 * ones(1, n_T) * 0.6 ;  % [1×n_T]，unit 10^6 m^3

% error penalties
v_day_std_cfs = T_w.std_inflow;
v_day_std   = v_day_std_cfs * cfs_to_m3s * sec_per_day /1e6;
v_var_w_day = v_day_std.^2;
v_var_w     = repmat(v_var_w_day,1,n_years);
v_var_month    = zeros(1,12);
idx = 1;
for m = 1:12
    v_var_month(m) = sum( v_var_w_day(idx:idx+days(m)-1) );
    idx = idx + days(m);
end

% 3) monthly standard deviation → 1×12
v_std_month = sqrt(v_var_month);

% 4) replicated cross all months → 1×(12·n_years)
v_std_w = repmat(v_std_month,1,n_years);

alpha = 1 ;
beta  = 200 ;

v_q = alpha*ones(size(v_x_tilde));
v_r =  beta*ones(size(v_x_tilde));
v_n = zeros(1,n_T) ;     

% dinamics
v_a =  1*ones(1,n_T) ;
v_b = -1*ones(1,n_T) ;

figure(123)
plot(v_T,v_x_tilde,'r-',...     
     v_T,v_u_tilde,'b-',...     
     v_T,v_c     ,'g-')
xlabel('t [month]')
ylabel('x_{tilde}   [x10^{6}  m^3]    ,    c, u_{tilde}   [x10^{6} m^3/month]')
legend('x_{tilde}','u_{tilde}','c')

% - - - - - - - - - - - - - - - - - - -

v_c_lower = v_c - 2*v_std_w ;
v_c_upper = v_c + 2*v_std_w ;

figure(124)
plot(v_T,v_x_tilde,'r-',...     
     v_T,v_u_tilde,'b-',...     
     v_T,v_c_lower,'g-',...
     v_T,v_c_upper,'g-',...
     v_T,v_c      ,'g:')
xlabel('t [month]')
ylabel('x_{tilde}   [x10^{6}  m^3]    ,    c, u_{tilde}   [x10^{6} m^3/month]')
legend('x_{tilde}','u_{tilde}','c')

% - - - - - - - - - - - - - - - - - - -

% Solve_LQR ;

% - - - - - - - - - - - - - - - - - - -