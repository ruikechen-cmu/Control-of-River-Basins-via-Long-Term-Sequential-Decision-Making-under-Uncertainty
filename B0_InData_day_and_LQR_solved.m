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

v_day_mean_m3 = v_day_mean_cfs * cfs_to_m3s * sec_per_day /1e6;

% replicated cross all months → length 1×(12·n_years)
v_c = repmat(v_day_mean_m3', 1, n_years);  

% monthly discount factor
gamma = 0.95^(1/12/30) ;

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
v_u_season = 1 + 0.5*sin(2*pi*((1:(12*30))-phase_shift)/(12*30));   % 1×12
v_u_season_mon = 1 + 0.5*sin(2*pi*((1:12)-phase_shift)/12);
v_u_season_day = [];
for mm = 1:12
    v_u_season_day = [ v_u_season_day, ...
        repmat(v_u_season_mon(mm),1,days(mm)) ];
end
% build a full‐length vector by repeating both the month‐means
%    and the seasonal shape
v_u_rep   = repmat(v_u_season_day,1,ceil(n_T/365));  
% scale so ∑u = ∑v_c exactly
v_u_tilde = v_u_rep * (sum(v_c)/sum(v_u_rep(1:n_T)));  

% check:
sum(v_u_tilde) - sum(v_c) 

cap_taf = 520.528;          % Unit：TAF 
cap_m3  = cap_taf * taf2millm3; % Change to be m^3，total capacity ≈6.42×10^8 m^3

% taget water level tilde x_tilde: stay 60% of reservoir
v_x_tilde = cap_m3 * 0.6 * ones(1, n_T);  % [1×n_T]，unit m^3

% error penalties
v_day_std_cfs = T_w.std_inflow;
v_day_std   = v_day_std_cfs * cfs_to_m3s * sec_per_day /1e6;
v_var_w_day = v_day_std.^2;
v_var_w     = repmat(v_var_w_day,1,n_years);
v_std_w_mat = sqrt(v_var_w) ;
v_std_w     = reshape(v_std_w_mat,1,[]);

alpha = 200 ;
beta  = 1 ;

v_q = alpha*ones(size(v_x_tilde));
v_r =  beta*ones(size(v_x_tilde));
v_n = zeros(1,n_T) ;     

% dinamics
v_a =  1*ones(1,n_T) ;
v_b = -1*ones(1,n_T) ;


figure(123)
plot(v_T/360,v_x_tilde,'r-',...     
     v_T/360,v_u_tilde,'b-',...     
     v_T/360,v_c     ,'g-')
xlabel('t [year]')
ylabel('x_{tilde}   [x10^{6}  m^3]    ,    c, u_{tilde}   [x10^{6} m^3/day]')
legend('x_{tilde}','u_{tilde}','c')

% - - - - - - - - - - - - - - - - - - -

v_c_lower = v_c - 2*v_std_w ;
v_c_upper = v_c + 2*v_std_w ;

figure(124)
plot(v_T/360,v_x_tilde,'r-',...     
     v_T/360,v_u_tilde,'b-',...     
     v_T/360,v_c_lower,'g-',...
     v_T/360,v_c_upper,'g-',...
     v_T/360,v_c      ,'g:')
xlabel('t [year]')
ylabel('x_{tilde}   [x10^{6}  m^3]    ,    c, u_{tilde}   [x10^{6} m^3/day]')
legend('x_{tilde}','u_{tilde}','c')

% - - - - - - - - - - - - - - - - - - -

% Solve_LQR ;

% - - - - - - - - - - - - - - - - - - -