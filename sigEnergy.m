function y = sigEnergy(t, tau)
%Calculates the energy of the sampled signal in x

if(nargin == 1)
  y = sum(abs(t).^2) ;
elseif(nargin == 2)
  y = sum(abs(t).^2) * mean(diff(tau));
end


