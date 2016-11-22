% complete the following code. 
% nb: you find the needed routines in the same directory. 

function y = n_tuple_output(sat,n_bits,doppler,tau_bit)

gpsConfig();
global gpsc;

% use getData to load exactly n_bits worth of samples, starting at tau_bit
r = getData(tau_bit,tau_bit+n_bits*gpsc.spb-1);

% set up a time variable that you use to remove the doppler 
t = (0:length(r)-1) * gpsc.Ts;

% remove the doppler to the entire data vector r
rd = r.*exp(-1j*2*pi*doppler*t);

% load the code of satellite "sat", appropriately sampled 
c = satCode(sat, 'fs');

% form the code of one bit  
c_bit = repmat(c, 1, gpsc.cpb);

% form the matrix A needed in the last line of this code
A = reshape(rd, length(c_bit), n_bits);

% obtain the n_tuple_output (MF output) that corresponds to the n_bits
y = c_bit * A;

end

