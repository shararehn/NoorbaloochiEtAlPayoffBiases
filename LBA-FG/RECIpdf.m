function y = RECIpdf(x,mu,sigma)
% RECIpdf Recinormal probability density function (pdf).
%   Y = RECIpdf(X,MU,SIGMA) returns the pdf of the recinormal distribution with
%   parameters MU and SIGMA, evaluated at the values in X.
%   The size of Y is the common size of the input arguments.  A scalar
%   input functions as a constant matrix of the same size as the other
%   inputs.
%
% Sharareh Noorbaloochi, Jan 2013

if nargin<1
    error(message('stats:normpdf:TooFewInputs'));
end
if nargin < 2
    mu = 0;
end
if nargin < 3
    sigma = 1;
end

if x==0
    y=0;
else
    y = normpdf(1/x,mu,sigma)*(1/(x^2));
end