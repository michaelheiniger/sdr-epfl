% FUNCTION_MAPPER Script to initialize function handles so that different implementations of a function can be easily interchanged
% Comment/uncomment one line of every pair to choose between your implementation and the compiled solution


% functions called from ldpcdecoder.m

    generateDecodingMatrices = str2func('my_generateDecodingMatrices');   % uncomment to use your own implementation
%       generateDecodingMatrices = str2func('sol_generateDecodingMatrices');  % uncomment to use the compiled solution

% functions called from test_ldpc.m:

   ldpcdecoder = str2func('my_ldpcdecoder');  % uncomment to use your own implementation
%      ldpcdecoder = str2func('sol_ldpcdecoder'); % uncomment to use the compiled solution
      

      
%% From past homework
      %ldpcencoder  = str2func('my_ldpcencoder');  % uncomment to use your own implementation
      ldpcencoder = str2func('sol_ldpcencoder'); % uncomment to use the compiled solution
      
      % extractmatrices = str2func('my_extractmatrices');  % uncomment to use your own implementation
      extractmatrices = str2func('sol_extractmatrices'); % uncomment to use the compiled solution
      
      % makeh = str2func('my_makeh');  % uncomment to use your own implementation
      makeh = str2func('sol_makeh'); % uncomment to use the compiled solution