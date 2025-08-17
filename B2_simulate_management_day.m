
n_s = 1000 ;

v_V_s_traj = zeros(n_s,1) ;
m_x_s_traj = zeros(n_s,n_T) ;
m_u_s_traj = zeros(n_s,n_T) ;
m_r_s_traj = zeros(n_s,n_T) ;

 v_mu_x_o = v_x_tilde(1) ; 
v_std_x_o = 0 ;

for  ss = 1:n_s
    
    if  ss/100 == round(ss/100)
        ['sim. # ' num2str(ss) ' of ' num2str(n_s)]
    end

    % - - - - - - - - - - - - - - - - - - - - -

    [V_s,v_r_s,m_x_s,m_u_s] = MC_sim(list_Ks,list_vs,...
                                     list_x_tilde,list_u_tilde,...
                                     list_Qs,list_Rs,list_Ns,...
                                     list_As,list_Bs,list_cs,list_Vws,gamma,n_X,n_T,...
                                     v_mu_x_o,v_std_x_o) ;

    v_V_s_traj(ss)   = V_s ;
    m_x_s_traj(ss,:) = m_x_s ;
    m_u_s_traj(ss,:) = m_u_s ;
    m_r_s_traj(ss,:) = v_r_s ;
     
    % - - - - - - - - - - - - - - - - - - - - -
    
end

v_x_s_average = mean(m_x_s_traj) ;
v_x_s_std     =  std(m_x_s_traj) ;
v_x_s_lower   = v_x_s_average - 2*v_x_s_std ;
v_x_s_upper   = v_x_s_average + 2*v_x_s_std ;

v_u_s_average = mean(m_u_s_traj) ;
v_u_s_std     =  std(m_u_s_traj) ;
v_u_s_lower   = v_u_s_average - 2*v_u_s_std ;
v_u_s_upper   = v_u_s_average + 2*v_u_s_std ;

v_r_s_average = mean(m_r_s_traj) ;
v_r_s_std     =  std(m_r_s_traj) ;
v_r_s_lower   = v_r_s_average - 2*v_r_s_std ;
v_r_s_upper   = v_r_s_average + 2*v_r_s_std ;

v_lim_T = [1:(2*12*30)] ;

    V_hat = mean(v_V_s_traj) ;
std_V_hat =  std(v_V_s_traj)/sqrt(n_s) ;

v_CI_V = V_hat + 2*std_V_hat*[-1  1];

m_P_o = list_Ps{1} ;
v_s_o = list_ss{1} ;
  g_o = list_gs{1} ;

   Vo = v_mu_x_o'*m_P_o*v_mu_x_o + 2*v_s_o'*v_mu_x_o + g_o ;

[ v_CI_V(1)  Vo   v_CI_V(2) ];

and(v_CI_V(1)<Vo,Vo<v_CI_V(2))

% - - - - - - - - - - - - - - - - - - - - - - - - - - -

ratio_q_on_r = alpha/beta ;

n_s_plot = 20 ;

figure(210)
subplot(2,1,1)
plot(v_T(v_lim_T)/30/12, m_x_s_traj(1:n_s_plot,v_lim_T),'b:',...
     v_T(v_lim_T)/30/12, v_x_tilde(            v_lim_T),'r-')
ylabel('Reser. Vol. [ x10^6m^3 ]')
xlabel('t [year]')
%legend('x','x_{tilde}')
title(['Daily Control, Volume Tracking, with Q/R = ' num2str(ratio_q_on_r) ] ,'fontweight','normal')
grid on

subplot(2,1,2)
plot(v_T(v_lim_T)/30/12, m_u_s_traj(1:n_s_plot,v_lim_T),'b:',...
     v_T(v_lim_T)/30/12, v_u_tilde(            v_lim_T),'r-',...
     v_T(v_lim_T)/30/12, v_c(                  v_lim_T),'g-')
ylabel('Outflow & Inflow [ x10^6m^3/day ]')
xlabel('t [year]')
%legend('u','u_{tilde}','c')
title('Daily Control, Reservoir Release and Inflow Over Time','fontweight','normal')
grid on

% - - - - - - - - - - - - - - -

figure(211)
subplot(2,1,1)
plot(v_T(v_lim_T)/30/12, v_x_s_lower(  :,v_lim_T),'b:',...
     v_T(v_lim_T)/30/12, v_x_tilde(      v_lim_T),'r--',...
     v_T(v_lim_T)/30/12, v_x_s_upper(  :,v_lim_T),'b:',...
     v_T(v_lim_T)/30/12, v_x_s_average(:,v_lim_T),'b--')
ylabel('Reser. Vol. [ x10^6m^3 ]')
xlabel('t [year]')
title(['Daily Control, Volume Tracking, with Q/R = ' num2str(ratio_q_on_r) ] ,'fontweight','normal')
%legend('CI(X_t)','X_{tilde,t}')
grid on

subplot(2,1,2)
plot(v_T(v_lim_T)/30/12, v_u_s_lower(  :,v_lim_T),'b:',...
     v_T(v_lim_T)/30/12, v_u_tilde(      v_lim_T),'r-',...
     v_T(v_lim_T)/30/12, v_c(            v_lim_T),'g-',...
     v_T(v_lim_T)/30/12, v_u_s_upper(  :,v_lim_T),'b:',...
     v_T(v_lim_T)/30/12, v_u_s_average(:,v_lim_T),'b--')
ylabel('Outflow & Inflow  [ x10^6m^3/day ]')
xlabel('t [year]')
%legend('CI(U_t)','U_{tilde,t}','C_t')
title('Daily Control, Reservoir Release and Inflow Over Time','fontweight','normal')
grid on

% - - - - - - - - - - - - - - -
