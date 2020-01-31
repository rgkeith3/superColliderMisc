({
	var sig = SoundIn.ar();

	Convolution2.ar(sig, Select.kr(LFNoise0.kr().range(0, 48), w), Impulse.kr(MouseY.kr(0, 10)))
}.play)

~a = Pbind(\amp, Pwhite(), \degree, Prand([1,3,5,7], inf), \dur, Pwhite(0.1))

~a[10] = \filter -> {|in| Convolution2L.ar(in, Select.kr(LFNoise1.kr(0.1).range(0, 48).poll, w), Impulse.kr(25))}
