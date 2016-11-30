% FUNCTION_MAPPER Script to initialize function handles so that different implementations of a function can be easily interchanged
% Comment/uncomment one line of every pair to choose between your implementation and the compiled solution


% functions called test_ldpc_encoder.m

    makeh = str2func('my_makeh');   % uncomment to use your own implementation
%       makeh = str2func('sol_makeh');  % uncomment to use the compiled solution
    
   ldpcencoder = str2func('my_ldpcencoder');   % uncomment to use your own implementation
%       ldpcencoder = str2func('sol_ldpcencoder');  % uncomment to use the compiled solution

% functions called from ldpcencoder.m:

    extractmatrices = str2func('my_extractmatrices');  % uncomment to use your own implementation
%       extractmatrices = str2func('sol_extractmatrices'); % uncomment to use the compiled solution