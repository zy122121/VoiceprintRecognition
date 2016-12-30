%mfcc
function  mfc=mfcc(x,fs)
%%%%%%%%%%%%%%%%%%%%%%%%%
%���������������x����mfcc������ȡ������mfcc������һ�ײ��mfcc������mel�˲����Ľ���Ϊ23
%fft�任����Ϊ256������Ƶ��Ϊ8000HZ,��x 256���Ϊһ֡
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bank=melbankm(24,256,fs,0,0.5,'m');
%��һ��mel�˲��������
bank=full(bank);
bank=bank/max(bank(:));

%DCTϵ����12*24
for k=1:12
    n=0:23;
    %dctcoef(:,k)=cos((2*n+1)*k*pi/(2*24));
    dctcoef(k,:)=cos((2*n+1)*k*pi/(2*24));
end

%��һ��������������
w=1+6*sin(pi*[1:12]./12);
w=w/max(w);

%Ԥ�����˲���
xx=double(x);
xx=filter([1-0.9375],1,xx);

%�����źŷ�֡
xx=enframe(xx,256,80);
%xx=enframe(xx,256,128);

%����ÿ֡��mfcc����
for i=1:size(xx,1) %
    y=xx(i,:);
    s=y'.*hamming(256);
    t=abs(fft(s));
    t=t.^2;%��������
    c1=dctcoef*log(bank*t(1:129));%dctcoefΪdctϵ����bank��һ��mel�˲�����ϵ��
    c2=c1.*w';%wΪ��һ��������������
    m(i,:)=c2';
end

%���ϵ��
dtm=zeros(size(m));
for i=3:size(m,1)-2;
    dtm(i,:)=-2*m(i-2,:)-m(i-1,:)+m(i+1,:)+2*m(i+2,:);
end
dtm=dtm/3;

%�ϲ�mfcc������һ�ײ��mfcc����
mfc=[m dtm];
%ȥ����β��֡����Ϊ����֡��һ�ײ�ֲ���Ϊ0
mfc=mfc(3:size(m,1)-2,:);

subplot(211)
mfc_1=mfc(:,1);
plot(mfc_1);title('MFCC');