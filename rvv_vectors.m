function [r_0_k,v_v_x_k,v_v_u_k] = rvv_vectors(v_x_tilde_k,v_u_tilde_k,m_Q_k,m_R_k,m_N_k)

  r_0_k = v_x_tilde_k'*m_Q_k*v_x_tilde_k + 2*v_x_tilde_k'*m_N_k*v_u_tilde_k + v_u_tilde_k'*m_R_k*v_u_tilde_k ;
v_v_x_k = m_N_k*v_u_tilde_k + m_Q_k*v_x_tilde_k ;
v_v_u_k = m_R_k*v_u_tilde_k + m_N_k*v_x_tilde_k ;
