% ERR_RATES_CODED_UNCODED Plots error rate vs. Es_N0 for coded and uncoded BPSK modulation
%    [uncoded_BER, coded_BER] = ERR_RATES_CODED_UNCODED(NUM_BITS, Es_sigma2) 
%    simulates the transmission of a sequence of NUM_BITS bits over an AWGN
%    channel using BPSK modulation, both uncoded and coded (with a convolutional
%    code of rate 1/2 and octal generators [5 7]). The second input, Es_sigma2,
%    specifies, in dB, the ratio of the average energy per symbol to the
%    noise variance at the matched filter output (sigma2 = N0/2). It can be 
%    a scalar or a vector containing multiple values.
%
%    The function also plots the bit error rates vs. Es_sigma2

function [uncoded_BER, coded_BER] = err_rates_coded_uncoded(num_bits, Es_sigma2)

    if (nargin < 1)
        num_bits = 1E6;
    end
    
    if (nargin < 2)
    	Es_sigma2 = (3:0.5:12); % ratio of average energy per bit to noise power spectral density, in dB
    end	

    % Convolutional encoder: values determined by simulation - correspond to the default Es_sigma2 = 3:0.5:12
    coded_BER_theo_soft_decisions = [0.0035684 0.0015926 0.00064695 0.00024045 8.11e-05 2.64e-05 6.95e-06 1.55e-06 4.5e-07 1e-7 ...
        nan nan nan nan nan nan nan nan nan];
    x_values_convenc = 3:0.5:12; y_values_convenc = coded_BER_theo_soft_decisions;
    legend_convenc = 'coded (reference, soft decisions)';
    
    if nargin == 2
        % Test if the new vector of SNR's is contained in the original one
        snr_orig = 3:0.5:12;
        % If yes, take the values from the precomputed BER vector above
        if length(snr_orig(ismember(snr_orig,Es_sigma2))) == length(Es_sigma2)
            x_values_convenc = snr_orig(ismember(snr_orig,Es_sigma2));
            y_values_convenc = coded_BER_theo_soft_decisions(ismember(snr_orig,Es_sigma2));
            legend_convenc = 'coded (reference, soft decisions)';
        % If not, use a tight upperbound for BER
        else
            x_values_convenc = Es_sigma2;
            % Tight upperbound for the considered convolutional code (generator = [5 7], constraint_length = 3)
            no_terms = 5;
            index = 1:no_terms;
            [x,y] = ndgrid(index, 10.^(Es_sigma2/10));
            y_values_convenc = sum(x.*qfunc(sqrt(y.*(x+4))).*2.^(x-1));
            legend_convenc = 'coded (reference, tight upperbound)';
        end
    end
    
	% Allocate space for bit-error-rate
	uncoded_BER = nan(1, length(Es_sigma2));
    coded_BER = nan(1, length(Es_sigma2));
		
    % Initialize wait bar
	h = waitbar(0, '');
	% evaluate coded / uncoded BER by simulation    
    for e = 1: length(Es_sigma2)
        
        waitbar(e/length(Es_sigma2), h, sprintf('Computing error rates for E_s/\\sigma^2 = %2.2f dB', Es_sigma2(e)));
        
        % generate vector of random bits
        s =  randi(2, num_bits, 1) - 1;
        [~, uncoded_BER(e)] = sol_transmit_bpsk(s, Es_sigma2(e));
        [~, coded_BER(e)] = sol_transmit_coded_bpsk(s, Es_sigma2(e));       
		
    end			
	close(h); % close the progress bar when done
	
	%% Plot results	
    
    % theoretical/reference results for comparison
    Eb_N0 = Es_sigma2 - 3; % Es = Eb, sigma2 = N0/2;
    uncoded_BER_theo = berawgn(Eb_N0, 'psk', 2, 'nondiff');
    
	figure();
    semilogy(Es_sigma2, uncoded_BER, 'ob'); hold on; grid on; % simulated, uncoded
    semilogy(Es_sigma2, uncoded_BER_theo, '-b');              % theoretical, uncoded
    
	semilogy(Es_sigma2, coded_BER, 'sr'); % simulated, coded, soft decisions
    semilogy(x_values_convenc, y_values_convenc, '-.r'); % reference, coded, soft decisions
        
    legend('uncoded (simulation)', 'uncoded (theory)', 'coded (simulation, soft decisions)', legend_convenc);
    
    xlabel('E_s/\sigma^2 [dB]'); ylabel('Bit Error Rate (BER)');
	title({'Comparison of coded and uncoded BER for BPSK', 'Rate 1/2 convolutional code with octal generators [5 7]'});
	axis([Es_sigma2(1) Es_sigma2(end) 1E-6 1E-0]);    
    
end
