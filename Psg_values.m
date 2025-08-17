
function [m_P_k,v_s_k,g_k] =...
          Psg_values(m_Q_k,m_K_k,v_v_k,m_M_k,m_N_k,v_v_x_k,v_v_u_k,m_A_k,m_B_k,v_c_k,r_0_k,tr_PVar_k,gamma,m_P_kp1,v_s_kp1,g_kp1) 

m_P_k =  m_Q_k + m_K_k'*m_M_k*m_K_k + 2*m_N_k*m_K_k + gamma*m_A_k'*m_P_kp1*(m_A_k+2*m_B_k*m_K_k) ;
v_s_k =  (m_K_k'*m_M_k'+m_N_k)*v_v_k - v_v_x_k - m_K_k'*v_v_u_k + gamma*((m_A_k'+m_K_k'*m_B_k')*(m_P_kp1*v_c_k+v_s_kp1) + m_A_k'*m_P_kp1*m_B_k*v_v_k) ;
  g_k =  r_0_k + v_v_k'*m_M_k*v_v_k - 2*v_v_k'*v_v_u_k + gamma*(g_kp1 + v_c_k'*m_P_kp1*v_c_k + tr_PVar_k +2*( v_s_kp1'*v_c_k + (v_c_k'*m_P_kp1 + v_s_kp1')*m_B_k*v_v_k )) ;

