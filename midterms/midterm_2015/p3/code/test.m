gpsConfig();
global gpsc;

% load one bit worth of data
r = getData(1,1+gpsc.spb-1);

% remove the C/A code so that the result is only a carrier 
ca_code = satCode(1,'fs');
ca_code_bit = repmat(ca_code, 1, gpsc.cpb);
rc = r.*ca_code_bit;

plot(ca_code.*ca_code)