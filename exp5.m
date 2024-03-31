%UNIFORM QUANTIZATION

echo on
t=0:0.01:10;
a=sin(t);
[sqnr8,aquan8,code8] = u_pcm(a,8);
[sqnr16,aquan16,code16] = u_pcm(a,16);
display(sqnr8);
display(sqnr16);
plot(t,a,'-',t,aquan8,'-.',t,aquan16,'-',t,zeros(1,length(t)));
legend('Original Signal','8 Level Quantized Signal','16 Level Quantized Signal');

function [sqnr, a_quan, code] = u_pcm(a, n)
    amax = max(abs(a));
    a_quan = a/amax;
    b_quan = a_quan;
    d = 2/n;
    q = d.*[0:n-1];
    q = q-((n-1)/2)*d;
    
    for i=1:n
        a_quan(find((q(i)-d/2<=a_quan)&(a_quan<=q(i)+d/2)))=q(i).*ones(1,length(find((q(i)-d/2<=a_quan)&(a_quan<=q(i)+d/2))));
        b_quan(find(a_quan==q(i)))=(i-1).*ones(1,length(find(a_quan==q(i))));
    end
    
    a_quan=a_quan*amax;
    nu=ceil(log2(n));
    code=zeros(length(a),nu);
    
    for i=1:length(a)
        for j=nu:-1:0
            if(fix(b_quan(i)/(2^j))==1)
                code(i,(nu-j))=i;
                b_quan(i)=b_quan(i)-2^j;
            end
        end
    end
    
    sqnr=20*log10(norm(a)/norm(a-a_quan));
end

%NON UNIFORM QUANTIZATION

t=0:0.01:10;
a=sin(t);
[sqnr,aquan,code] = mula_pcm(a,16,255);
display(sqnr);
plot(t,a,'-',t,aquan,'-.');
legend('Original Signal','Quantized Signal');
function [sqnr, a_quan, code] = u_pcm(a, n)
    amax = max(abs(a));
    a_quan = a/amax;
    b_quan = a_quan;
    d = 2/n;
    q = d.*[0:n-1];
    q = q-((n-1)/2)*d;
    
    for i=1:n
        a_quan(find((q(i)-d/2<=a_quan)&(a_quan<=q(i)+d/2)))=q(i).*ones(1,length(find((q(i)-d/2<=a_quan)&(a_quan<=q(i)+d/2))));
        b_quan(find(a_quan==q(i)))=(i-1).*ones(1,length(find(a_quan==q(i))));
    end
    
    a_quan=a_quan*amax;
    nu=ceil(log2(n));
    code=zeros(length(a),nu);
    
    for i=1:length(a)
        for j=nu:-1:0
            if(fix(b_quan(i)/(2^j))==1)
                code(i,(nu-j))=i;
                b_quan(i)=b_quan(i)-2^j;
            end
        end
    end
    
    sqnr=20*log10(norm(a)/norm(a-a_quan));

end     
    function [sqnr,a_quan,code]=mula_pcm(a,n,mu)
    [y,maximum]=mulaw(a,mu);
    [sqnr,y_q,code]=u_pcm(y,n);
    a_quan=invmulaw(y_q,mu);
    a_quan=maximum*a_quan;
    sqnr=20*log10(norm(a)/norm(a-a_quan));
    end
    function [y,a]=mulaw(x,mu)
    a=max(abs(x));
    y=(log(1+mu*abs(x/a))./log(1+mu)).*sign(x);
    end
    function x=invmulaw(y,mu)
    x=(((1+mu).^(abs(y))-1)./mu).*sign(y);
    end
