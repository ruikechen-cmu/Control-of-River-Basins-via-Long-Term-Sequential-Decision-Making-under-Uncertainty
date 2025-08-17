
for  kk = 1:n_T
    
    list_x_tilde{kk} = v_x_tilde(kk) ;
    list_u_tilde{kk} = v_u_tilde(kk) ;
    list_Qs{ kk} = v_q(kk) ;
    list_Rs{ kk} = v_r(kk) ;
    list_Ns{ kk} = v_n(kk) ;
    list_As{ kk} = v_a(kk) ;
    list_Bs{ kk} = v_b(kk) ;
    list_cs{ kk} = v_c(kk) ;
    list_Vws{kk} = v_var_w(kk) ;

end

[list_r_0s,list_v_xs,list_v_us,list_Ms,list_Ks,list_vs,list_Ps,list_ss,list_gs] = ...
                        LQR_tv(list_x_tilde,list_u_tilde,...
                               list_Qs,list_Rs,list_Ns,...
                               list_As,list_Bs,list_cs,list_Vws,gamma,n_X,n_T);