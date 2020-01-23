
params = struct;
deviceID = 12; % HDMI ALSA output

params.samplerate = 48000;
params.intervallen = 750 * (params.samplerate / 1000); % duration of interval, in ms
params.ramplen = round(5 * (params.samplerate / 1000));


shiftLength = 5 * (params.samplerate / 1000); % in ms
wn1 = real( ifft( scut(fft(randn(params.intervallen, 1)), 0, 3000, params.samplerate ) ) );
indx = length(wn1) - shiftLength;
wn2 = vertcat(zeros(shiftLength,1),wn1(1:indx));
% attenuate delayed signal
for ripple_db = 0:2:14 % dB scale; 

    wn2_att = wn2 * 10^(-ripple_db/20); % should it be 20? or 10? converting from dB to regular attenuation

    res1 =( wn1 + wn2_att) / 2;
    res1_filtered = real(ifft(scut(fft(res1), 300, 3000, params.samplerate)));


    playerObj = audioplayer(res1_filtered,params.samplerate,24,deviceID);
    playblocking(playerObj);
    plPause = audioplayer(zeros(1,params.intervallen), params.samplerate, 24, deviceID);
    playblocking(plPause);
end