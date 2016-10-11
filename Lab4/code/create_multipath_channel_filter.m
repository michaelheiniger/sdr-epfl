function h = create_multipath_channel_filter(amplitudes, delays)

% CREATE_MULTIPATH_CHANNEL_FILTER(AMPLITUDES, DELAYS) Create sampled response of multipath channel
% H = CREATE_MULTIPATH_CHANNEL_FILTER(AMPLITUDES, DELAYS)
%
% We assume that the shaping pulse is square. In this case, the
% autocorrelation function will be a triangle.
%
% DELAYS and AMPLITUDES are vectors of the same length, specifying the
% strength and delay of each path. The DELAYS must be specified relative to
% the sampling period.
%
% H contains the samples of filtered impulse response.


    if (numel(amplitudes) ~= numel(delays))
        error('create_multipath_channel_filter:wrongInputDimensions', 'AMPLITUDES and DELAYS must be vectors of the same length');
    end

    

L=max(floor(delays))+1;
M=numel(delays);

% This implementation is the same as the alternative one proposed
% later, but it is just more compact. It uses the fact that a certain delay
% can affect only two consecutive Rp (Rp is a triangle in our case).
h=zeros(1,L+1);
for i=1:M
    n=floor(delays(i))+1;
    h(n)=h(n)+amplitudes(i)*(n-delays(i));
    h(n+1)=h(n+1)+amplitudes(i)*(delays(i)-n+1);
end

%remove the additional zero at the end when the last delay is integer
h=h(1:max(ceil(delays)));
   
    
% % alternative: this follows closely the lecture notes by building the
% % matrix R, and then computing c = R*\alpha
% % first we compute the channel length (in symbols)
% L=max(ceil(delays))+1;
%
% % get the size of delays/amplitudes vector
% M=numel(delays);
% 
% R1=repmat([0:L-1]',1,M);
% R1=1-abs(R1-repmat(delays, L,1)); % this is the triangle Rp
% R1(R1<0)=0; % we want a triangle only at positive values (above y axis)
% 
% h=R1*amplitudes(:); % do the multiplication c = R*\alpha
% 
% %convert to row vector
% h=reshape(h,1,numel(h))


