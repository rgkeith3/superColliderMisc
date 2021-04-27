ProxySpace.push(s.boot)

b = Buffer.read(s, "/Users/greykeith/superCollider/utils/b_format_samples/b-format_gun_fire.wav")
b = Buffer.read(s, "/Users/greykeith/superCollider/utils/b_format_samples/b-format_take_off.wav")

(~a = {
	var foa;
	foa = PlayBuf.ar(4, b, BufRateScale.ir(b), loop: 1);
	foa = FoaRTT.ar(foa, LFNoise1.kr(1).range(-pi, pi), LFNoise1.kr(1).range(-pi, pi), LFNoise1.kr(1).range(-pi, pi));
	FoaDecode.ar(foa, FoaDecoderMatrix.newStereo());
})

~a.play
~a.scope