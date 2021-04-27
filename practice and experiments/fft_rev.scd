

~a =Pbind(\amp, Pwhite(0.5), \dur, Prand([1/4, 2], inf), \legato, 0.5, \pan, Pwhite(-1))
~a
~a.play

~a.stop

~revSnd = ~b;
(
~rev = {
	|fb=0.8, comb_reset_spd = 5, comb_depth = 1, comb_mod_spd  = 0.1, smooth_depth = 0.5, smooth_mod_spd = 0.1, st_mix = 0.2|
	var in, chainL, chainR, bufL, bufR, sig;

	in = LocalIn.ar(2) + ~revSnd.ar;

	4.do {
		in = AllpassN.ar(in, 0.1, Rand(hi: 0.1), Rand());
	};

	bufL = LocalBuf(1024);
	bufR = LocalBuf(1024);

	chainL = FFT(bufL, in[0]);
	chainR = FFT(bufR, in[1]);

	chainL = PV_RandComb(chainL, LFNoise1.kr(comb_mod_spd, comb_depth).range(0.1, 0.9), Dust.kr(comb_reset_spd));
	chainR = PV_RandComb(chainR, LFNoise1.kr(comb_mod_spd, comb_depth).range(0.1, 0.9), Dust.kr(comb_reset_spd));

	chainL = PV_MagSmooth(chainL, LFNoise1.kr(smooth_mod_spd, smooth_depth).range(0.1, 0.9));
	chainR = PV_MagSmooth(chainR, LFNoise1.kr(smooth_mod_spd, smooth_depth).range(0.1, 0.9));

	chainL = PV_Morph(chainL, chainR, st_mix);
	chainR = PV_Morph(chainR, chainL, st_mix);

	sig = [IFFT(chainL), IFFT(chainR)];

	LocalOut.ar(sig * fb);

	sig;
}
)

~rev.play
~rev.set(\fb, 1);

~rev.set(\st_mix, 0.5);

~rev.set(\comb_mod_spd, 1);
~rev.set(\comb_depth, 1);
~rev.set(\smooth_mod_spd, 1);
~rev.set(\smooth_depth, 1);
~rev.set(\comb_reset_spd, 1)

~a.stop
~a.play
~a = {Pan2.ar(Saw.ar(LFNoise1.kr(5, 1000, 1001)), LFNoise1.kr(1), LFNoise0.kr(3))}

~a = Pbind(\instrument, \oneShot, \buf, d[\samples][\Drums][\Snares].choose, \dur, 1)
~setupFuncs = nil
~a.stop