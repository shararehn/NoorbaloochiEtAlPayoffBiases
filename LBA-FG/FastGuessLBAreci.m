function [higivenhl, logivenhl] = FastGuessLBAreci( muf,sigmaf,pf,ph,pf_n,T0,A, muC, sigma,bound,baseDrift )

pfc_n = 0.5; % probabilty of correct fast guess in the neutral condition
step = 20;
tend = 700;
v1 = baseDrift+muC;
v2 =  baseDrift-muC;

for t=1:1:tend
    
    t1 = max(t-T0, 0); % incorporating the non-decision time
    t_fast = max(t-(T0-50),0);% fast guess process begins 50 ms sooner than stim-driven process
    % neutral condition
    [f1n(t) f2n(t) F1n(t) F2n(t)] = LBAclosed(A,v1,v2, bound, sigma,t1);
    
    pc_neut(t) = f1n(t) * (1-F2n(t));
    pe_neut(t) = f2n(t) * (1-F1n(t));
    
    % congruent payoff condition
    [f1cong(t) f2cong(t) F1cong(t) F2cong(t)] = LBAclosed(A,v1,v2, bound, sigma,t1);

    pc_cong(t) = f1cong(t) * (1-F2cong(t));
    pe_cong(t) = f2cong(t) * (1-F1cong(t));
    
    % congruent payoff condition
    [f1incong(t) f2incong(t) F1incong(t) F2incong(t)] = LBAclosed(A,v1,v2, bound, sigma,t1);
    
    pc_incong(t) = f1incong(t) * (1-F2incong(t));
    pe_incong(t) = f2incong(t) * (1-F1incong(t));
    
    %-------------- Race model of fast guess process and evidence accum process
    
    
    % The probability of neither accumulators reaching a bound is:
    pNDcong(t) = 1- (F1cong(t)+F2cong(t)-F1cong(t)*F2cong(t)); % (1-F1cong(t))*(1-F2cong(t))  
    pNDincong(t) = 1- (F1incong(t)+F2incong(t)-F1incong(t)*F2incong(t)); 
    pNDneut(t) = 1- (F1n(t)+F2n(t)-F1n(t)*F2n(t)); 

    % ----------------------------------
    pfhi_cong(t) = pf*RECIpdf(t_fast,muf,sigmaf) * ph * pNDcong(t);
    pshi_cong(t) = pc_cong(t)*(1-pf*RECIcdf(t_fast,muf,sigmaf));%
    %pshi_cong(t) =(pf*pc_cong(t)* (1 - RECIcdf(t,muf,sigmaf))...
    %   + (1-pf)*pc_cong(t);
    
    pflo_cong(t) = pf * RECIpdf(t_fast,muf,sigmaf) * (1-ph) * pNDcong(t);
    pslo_cong(t) =  pe_cong(t)* (1 - pf*RECIcdf(t_fast,muf,sigmaf));
    
    pfhi_incong(t) = pf * RECIpdf(t_fast,muf,sigmaf) * ph* pNDincong(t);
    pshi_incong(t) =  pe_incong(t)* (1 - pf*RECIcdf(t_fast,muf,sigmaf));
    
    pflo_incong(t) = pf * RECIpdf(t_fast,muf,sigmaf) * (1-ph)* pNDincong(t);
    pslo_incong(t) =  pc_incong(t)* (1 - pf*RECIcdf(t_fast,muf,sigmaf));
    
    pfc_neut(t) = pf_n * RECIpdf(t_fast,muf,sigmaf) * pNDneut(t)* pfc_n;
    psc_neut(t) =  pc_neut(t)* (1 - pf_n*RECIcdf(t_fast,muf,sigmaf));
    
    pfe_neut(t) = pf_n * RECIpdf(t_fast,muf,sigmaf) *pNDneut(t)* (1-pfc_n);
    pse_neut(t) = pe_neut(t)* (1 - pf_n*RECIcdf(t_fast,muf,sigmaf));
    
 end

phi_cong = pfhi_cong + pshi_cong;
plo_cong = pflo_cong + pslo_cong;
phi_incong = pfhi_incong + pshi_incong;
plo_incong = pflo_incong + pslo_incong;
pc_neut = pfc_neut + psc_neut;
pe_neut = pfe_neut + pse_neut;

if step ~=1
    phi_congbin = sum(reshape(phi_cong,step, 700/step));
    plo_congbin = sum(reshape(plo_cong,step, 700/step));
    phi_incongbin = sum(reshape(phi_incong,step, 700/step));
    plo_incongbin = sum(reshape(plo_incong,step, 700/step));
    pc_neutbin = sum(reshape(pc_neut,step, 700/step));
    pe_neutbin = sum(reshape(pe_neut,step, 700/step));
    
else
    phi_congbin =nhi_cong;
    plo_congbin = nlo_cong;
    phi_incongbin = nhi_incong;
    plo_incongbin = nlo_incong;
    pc_neutbin = nc_neut;
    pe_neutbin = ne_neut;
    
end
higivenhl(1,:)= phi_congbin;
higivenhl(2,:)= phi_incongbin;
logivenhl(1,:) = plo_congbin;
logivenhl(2,:)= plo_incongbin;
higivenhl(3,:) = pc_neutbin;
logivenhl(3,:) = pe_neutbin;

end


function [f1 f2 F1 F2] = LBAclosed(A,v1,v2, b, sigma,t)
    
    b1=b; b2=b; 
    F1 = 1 + (b1-A-t*v1)/A * normcdf((b1-A-t*v1)/(t*sigma))...
        - (b1-t*v1)/A* normcdf((b1-t*v1)/(t*sigma))...
        + (t*sigma)/A *normpdf((b1-A-t*v1)/(t*sigma))...
        - (t*sigma)/A * normpdf( (b1-t*v1)/(t*sigma));

    F2 = 1 + (b2-A-t*v2)/A * normcdf((b2-A-t*v2)/(t*sigma))...
        - (b2-t*v2)/A* normcdf((b2-t*v2)/(t*sigma))...
        + (t*sigma)/A *normpdf((b2-A-t*v2)/(t*sigma))...
        - (t*sigma)/A * normpdf( (b2-t*v2)/(t*sigma));

    f1 = 1/A * (-v1*normcdf((b1-A-t*v1)/(t*sigma))+...
        sigma*normpdf((b1-A-t*v1)/(t*sigma))+...
        v1*normcdf((b1-t*v1)/(t*sigma))-...
        sigma*normpdf((b1-t*v1)/ (t*sigma)));
    f2 = 1/A * (-v2*normcdf((b2-A-t*v2)/(t*sigma))+...
        sigma*normpdf((b2-A-t*v2)/(t*sigma))+...
        v2*normcdf((b2-t*v2)/(t*sigma))-...
    sigma*normpdf((b2-t*v2)/ (t*sigma)));
end

