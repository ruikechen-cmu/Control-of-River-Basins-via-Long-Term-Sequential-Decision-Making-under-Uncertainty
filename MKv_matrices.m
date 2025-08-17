
function [m_M_k,m_K_k,v_v_k] =...
          MKv_matrices(m_R_k,m_N_k,v_v_u_k,m_A_k,m_B_k,v_c_k,m_P_kp1,v_s_kp1,gamma) 

m_M_k =  m_R_k + gamma*m_B_k'*m_P_kp1*m_B_k ;
m_K_k = -m_M_k\(m_N_k'  + gamma*m_B_k'*m_P_kp1*m_A_k) ;
v_v_k =  m_M_k\(v_v_u_k - gamma*m_B_k'*(m_P_kp1*v_c_k+v_s_kp1)) ;
