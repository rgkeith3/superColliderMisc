(~a[0] = Pbind(\instrument, \stOneShot, \buf, Prand(d[\stereo_samples][\Miserere], inf), \dur, 1, \atk, 0.5, \rel, 6, \amp, 1, \start, Pwhite()))
~a.play
(~a[1] = \filter -> {|in|
	var left, right, chain, sig;
	left = FFT(LocalBuf(1024!8), in[0]);
	right = FFT(LocalBuf(1024!8), in[1]);
	right = PV_MagShift(right, 0.5, -1);
	chain = PV_Add(left, right);
	sig =  SinOsc.ar(LFNoise1.kr(0.1).range(0, 5), (0, pi/7..pi));
	// chain = PV_RandComb(chain, LFNoise1.kr(0.5!8).range(0, 0.99));
	// chain = PV_MagSmooth(chain, LFNoise1.kr(0.5!8).range(0, 0.99));
	// chain = PV_MagSmooth(chain, sig.range(0.5, 0.99));
	// chain = PV_RandComb(chain, sig.range(0.5, 0.8));
	// chain = PV_MagAbove(chain, sig.range(0,15));
	chain = PV_SpectralEnhance(chain, 8, 2);



	FreeVerb.ar(IFFT(chain), room: 1, damp: 1);

})


(~a[10] = \filter -> {|in|
	[in[6], in[1], in[0], Mix(in) * 0.5, in[5], in[2], in[4], in[3]]
})

~a.play

d[\stereo_samples].keys

pi / 8

(0, pi/7..pi)