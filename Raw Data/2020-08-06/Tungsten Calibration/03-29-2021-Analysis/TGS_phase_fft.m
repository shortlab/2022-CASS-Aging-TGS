function [fft] = TGS_phase_fft(pos_file,neg_file,grat,psd_out)
%   For this use only, generate filtered fft for input data
%   pos_file: positive phase data pos_file
%   neg_file: negative phase data neg_file
%   grat: grating, either calibrated or estimated, in um
%   psd: if psd=1, save out power spectrum else, save out fft magnitude

if nargin<4
    psd_out=1;
end

%Boolean options for plotting and processing
derivative=0;
plotty=0;
plotfft=0;
saveout=0;
combo=1;            % Calculates a linear combination of normal FFT and FFT from derv of 'flat'
rangefrac=0.5;      % The fraction of 'flat' that is used to calculate the FFT
cut_tails=2000;     % Fraction of data removed from beginning and end of FFT spectra

hdr_len=16;

pos=dlmread(pos_file,'',hdr_len,0);
neg=dlmread(neg_file,'',hdr_len,0);

pos(:,2)=pos(:,2)-mean(pos(1:50,2));
neg(:,2)=neg(:,2)-mean(neg(1:50,2));

[~,time_index]=max(neg(1:1000,2));
time_naught=neg(time_index,1);


%If recorded traces differ in length, fix them to shorter of the two
if length(pos(:,1))>length(neg(:,1))
    pos=pos(1:length(neg(:,1)),:);
elseif length(pos(:,1))<length(neg(:,1))
    neg=neg(1:length(pos(:,1)),:);
end

fixed_short=[pos(:,1) pos(:,2)-neg(:,2)];

[~,fix_index]=max(fixed_short(:,2));
fixed_short=fixed_short(fix_index:end,:);

if saveout
    dlmwrite('dat_temp.txt',fixed_short);
end

if plotty
    figure()
    plot(fixed_short(:,1),fixed_short(:,2),'r')
    title('this is fixed short');
end

%normalize to initial level before pump pulse
fixed_short(:,2)=fixed_short(:,2)-mean(fixed_short(end-50:end,2));

fixed_short(:,1)=fixed_short(:,1)-fixed_short(1,1); %slide peak back to 0 to fit more easily

%Take a fit to a purely erfc() decay to subtract a decay profile before
%taking fft
q=2*pi/(grat*10^(-6));
LB=[0 0 0];
UB=[10 5*10^-4 0.1];
ST=[0.05 5*10^-5 0];
OPS=fitoptions('Method','NonLinearLeastSquares','Lower',LB,'Upper',UB,'Start',ST);
TYPE=fittype('A.*erfc(q*sqrt(k*(x)))+c;','options',OPS,'problem','q','coefficients',{'A','k','c'});

[f0,~]=fit(fixed_short(:,1),fixed_short(:,2),TYPE,'problem',q);

if plotty
    %plot fit to see how well it matches
    figure()
    plot(fixed_short(:,1),f0(fixed_short(:,1)),'b',fixed_short(:,1),fixed_short(:,2),'r');
    title('this is an erfc(..) fit of fixed short');
end

%this is the thermal decay filtering of the signal recorded vs time. This will clean up the DC end of the power spectrum
flat1=[fixed_short(:,1) fixed_short(:,2)-f0(fixed_short(:,1))];

% Shorten 'flat1' to 'flat' so the FFT samples better data
newlength=ceil(numel(fixed_short(:,1))*rangefrac);
flat=zeros(newlength,2);
flat(:,1)=flat1(1:newlength,1);
flat(:,2)=flat1(1:newlength,2)/max(flat1(1:newlength,2));

if plotty
    figure()
    plot(flat(:,1),flat(:,2),'b-')
    title('this is fixed short minus the erfc(..) fit and shortened');
end

% Time step info necessary for differentiation and flat padding
tstep=flat(end,1)-flat(end-1,1);

% If option selected, take transform of derivative of recorded signal
% to filter out DC even more than just the background subtraction
d_flat=diff(flat(:,2))/tstep;
d_flat=d_flat/max(d_flat);
if derivative
    flat=[flat(1:length(d_flat),1) d_flat];
end

if combo
    dflat=[flat(1:length(d_flat),1) d_flat];
%     flat=[flat(1:length(d_flat),1) d_flat+flat(1:length(d_flat),2)];
end


% Find the stuff we need to take the spectral profile
num=length(flat(:,1));
fs=num/(flat(end,1)-flat(1,1));
p=18; %magnitude of zero padding to increase resolution in power spectrum
pdsize=2^p-num-2; %more padding = smoother transform

%Only pad on the positive end
pad_val=0;
% pad_val=mean(flat(end-50:end,2));
pad=zeros(pdsize,1);
pad(1:end)=pad_val;
tpad=flat(end,1):tstep:flat(end,1)+(pdsize-1)*tstep;

flat_pad=[flat(:,1) flat(:,2);tpad' pad];

nfft=length(flat_pad(:,2));
%Find the Power Spectral density

%Use a hamming window and a Welchs method. Hamming does the best of the
%ones I've tried and Welch does slightly better than the normal
%periodogram.
[psd,freq]=periodogram(flat_pad(:,2),rectwin(nfft),nfft,fs); %periodogram method

psdlenadj=ceil(numel(psd)*(1/10))-cut_tails;
psd(1:cut_tails)=0;
psd(psdlenadj:end)=0;
psd=psd/(max(psd));

if combo
    dflat_pad=[dflat(:,1) dflat(:,2);tpad' pad];
    nfftd=length(dflat_pad(:,2));
    [psd_d,freq_d]=periodogram(dflat_pad(:,2),rectwin(nfftd),nfftd,fs); %periodogram method
    
    psdlenadj=ceil(numel(psd_d)*(1/10))-cut_tails;
    psd_d(1:cut_tails)=0;
    psd_d(psdlenadj:end)=0;
    psd_d=psd_d/(max(psd_d));
    
    psd=psd(1:end-1)+psd_d(1:end);
end

%Don't save out DC spike in FFT/PSD
if psd_out
    amp=psd(1:end);
else
    amp=sqrt(psd(1:end));
end

fft=[freq(1:end-1) amp(1:length(freq(1:end-1)))];

if saveout
    dlmwrite('dat_spec.txt',out);
end

if plotfft
    figure()
    axes('Position',[0 0 1 1],'xtick',[],'ytick',[],'box','on','handlevisibility','off','LineWidth',5)
    plot(freq(1:end-1),amp(1:length(freq(1:end-1)))/max(amp),'k','LineWidth',2);
    hold on
    xlim([0 1.0e9]);
    set(gca,...
        'FontUnits','points',...
        'FontWeight','normal',...
        'FontSize',24,...
        'FontName','Helvetica',...
        'LineWidth',3)
    ylabel({'Intensity [a.u.]'},...
        'FontUnits','points',...
        'FontSize',24,...
        'FontName','Helvetica')
    xlabel({'Frequency [GHz]'},...
        'FontUnits','points',...
        'FontSize',24,...
        'FontName','Helvetica')
end


end
