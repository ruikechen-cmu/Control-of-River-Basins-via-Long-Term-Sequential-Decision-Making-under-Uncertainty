
function  [list_r_0s,list_v_xs,list_v_us,list_Ms,list_Ks,list_vs,list_Ps,list_ss,list_gs] = ...
                        LQR_tv(list_x_tilde,list_u_tilde,...
                               list_Qs,list_Rs,list_Ns,...
                               list_As,list_Bs,list_cs,list_Vws,gamma,n_X,n_T)

list_r_0s=[] ; list_v_xs=[] ; list_v_us=[] ; list_Ms=[] ; list_Ks=[] ; list_vs=[] ; list_Ps=[] ; list_ss=[] ; list_gs=[] ; 

m_P_kp1 = zeros(n_X,n_X) ;   v_s_kp1 = zeros(n_X,1) ;   g_kp1 = zeros(1,1) ;

for  kk = n_T:-1:1
    
    v_x_tilde_k = list_x_tilde{kk} ;
    v_u_tilde_k = list_u_tilde{kk} ;
    m_Q_k       = list_Qs{ kk} ;
    m_R_k       = list_Rs{ kk} ;
    m_N_k       = list_Ns{ kk} ;
    m_A_k       = list_As{ kk} ;
    m_B_k       = list_Bs{ kk} ;
    v_c_k       = list_cs{ kk} ;
    m_Var_w_k   = list_Vws{kk} ;

    tr_PVar_k   = trace(m_P_kp1*m_Var_w_k) ;
    
    [r_0_k,v_v_x_k,v_v_u_k] =...
        rvv_vectors(v_x_tilde_k,v_u_tilde_k,m_Q_k,m_R_k,m_N_k) ;
    
    [m_M_k,m_K_k,v_v_k] =...
        MKv_matrices(m_R_k,m_N_k,v_v_u_k,m_A_k,m_B_k,v_c_k,m_P_kp1,v_s_kp1,gamma) ;
    
    [m_P_k,v_s_k,g_k] =...
        Psg_values(m_Q_k,m_K_k,v_v_k,m_M_k,m_N_k,v_v_x_k,v_v_u_k,m_A_k,m_B_k,v_c_k,r_0_k,tr_PVar_k,gamma,m_P_kp1,v_s_kp1,g_kp1) ;
    
    m_P_kp1 = m_P_k ;   v_s_kp1 = v_s_k ;   g_kp1 = g_k ;

    list_r_0s{kk} =   r_0_k ;
    list_v_xs{kk} = v_v_x_k ;
    list_v_us{kk} = v_v_u_k ;
    list_Ms{kk}   =   m_M_k ;
    list_Ks{kk}   =   m_K_k ;
    list_vs{kk}   =   v_v_k ;
    list_Ps{kk}   =   m_P_k ;
    list_ss{kk}   =   v_s_k ;
    list_gs{kk}   =     g_k ;
    
end