ProxySpace.push(s.boot)


(~a[0] = {|freq = 440, dec=0.5, spd=0.2, lag=0.05|
	var in, sig;

	in = SoundIn.ar();
	sig = CombN.ar(in, 0.2, (Lag.kr(Select.kr(LFNoise1.kr(spd!5).range(0,6), Scale.major.ratios.scramble), lag) * freq).reciprocal, dec);

	Splay.ar(sig);
})

~a.play
~a[15] = nil
~a.mold(2)
~a.set(\freq, 250)
~a.set(\dec, 1)

~a.set(\spd, 0.1)
~a.set(\lag, 1)
~a[5] = nil
~a[5] = \filter -> {|in| LPF.ar((in * MouseX.kr(1, 5)).softclip, MouseY.kr(1, 22000))}

~a[10] = \filter -> {|in| JPverb.ar(in) + in}


50.reciprocal
~a.scope

Scale.major.ratios.size
9/8