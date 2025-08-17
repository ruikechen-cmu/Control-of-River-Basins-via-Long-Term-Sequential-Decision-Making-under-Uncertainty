
function  [V_s,v_r_s,m_x_s,m_u_s] = MC_sim(list_Ks,list_vs,...
                                           list_x_tilde,list_u_tilde,...
                                           list_Qs,list_Rs,list_Ns,...
                                           list_As,list_Bs,list_cs,list_Vws,gamma,n_X,n_T,...
                                           v_mu_x_o,v_std_x_o)

m_x_s = zeros(n_X,n_T) ;
m_u_s = zeros(n_X,n_T) ;
v_r_s = zeros(  1,n_T) ;

v_x_k = v_mu_x_o + randn*v_std_x_o ;

for  kk = 1:n_T
    
     m_x_s(:,kk) = v_x_k ;
% - - - - - - - - - - - - - - - - - - - - -
% optimal action
     m_K_k = list_Ks{ kk} ;
     v_v_k = list_vs{ kk} ;
     
     u_free = m_K_k*v_x_k + v_v_k ;
     v_u_k  = max(u_free, 0);
     %v_u_k = m_K_k*v_x_k + v_v_k ;    
     
     m_u_s(:,kk) = v_u_k ;
     
% - - - - - - - - - - - - - - - - - - - - -  
% immediate loss
    v_x_tilde_k = list_x_tilde{kk} ;
    v_u_tilde_k = list_u_tilde{kk} ;
          m_Q_k = list_Qs{kk} ;
          m_R_k = list_Rs{kk} ;
          m_N_k = list_Ns{kk} ;
          
      r_k = (v_x_k-v_x_tilde_k)'*m_Q_k*(v_x_k-v_x_tilde_k) +...
            (v_u_k-v_u_tilde_k)'*m_R_k*(v_u_k-v_u_tilde_k) ;
      
    v_r_s(kk) = r_k ;
    
% - - - - - - - - - - - - - - - - - - - - -     
% dynamic 
     m_A_k = list_As{kk} ;
     m_B_k = list_Bs{kk} ;
     v_c_k = list_cs{kk} ;
    m_Vw_k = list_Vws{kk} ;
   std_w_k = sqrt(m_Vw_k) ;
     v_w_k = std_w_k*randn(n_X,1) ;
     
     v_x_k = m_A_k*v_x_k + m_B_k*v_u_k + v_c_k + v_w_k ;
     
% - - - - - - - - - - - - - - - - - - - - -

end

V_s = v_r_s*( gamma.^(0:(n_T-1))' ) ;
