function b = inv_mod2(a)

% determine the inverse of a binary matrix using Gaussian elimination

% a: square matrix containing values 0 and 1
% b: the modulo 2 inverse of a


% Find the dimensions of the input matrix
[r,c] = size(a);
b=eye(r);


for i=1:r  % take each line

    %put an one at a(i,i)
    flag1=0;
    while(flag1==0)    
        for jj=i:r
            if a(i,jj)~=0
                aux=a(:,i); a(:,i)=a(:,jj); a(:,jj)=aux;
                aux=b(:,i); b(:,i)=b(:,jj); b(:,jj)=aux;
                flag1=1;
                break;
            end
        end
    end
    
    if flag1==0
        error('singular matrix');
    end

    % column operations to have zeros for jj>i
    for jj=i+1:r
        if (a(i,jj)==1)
           a(:,jj)=mod(a(:,jj)+a(:,i),2);
           b(:,jj)=mod(b(:,jj)+b(:,i),2);
        end
    end
end

%at this point we have a lower triangular matrix

for i=r:-1:1
    for jj=i-1:-1:1
        if (a(i,jj)==1)
           a(:,jj)=mod(a(:,jj)+a(:,i),2);
           b(:,jj)=mod(b(:,jj)+b(:,i),2);
        end
    end
end
