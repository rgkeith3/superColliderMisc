s.boot


~b = Pbind(\instrument, \flutterSaw, \scale, Scale.harmonicMinor, \degree, Pseq([1,2,3,4], inf), \dur, 1/2, \amt, 0.01, \octave, Prand([3,5,7], inf), \q, 0.1, \filter_freq, 1000)
~b.play
~b.stop

(~a = {
	|freq=440, chord_degree_1=2, chord_degree_2=4, chord_degree_3=6|
	var sig, local, fb, splayed, scale;

	fb = MouseY.kr(0, 1);
	// sig = SoundIn.ar();
	sig = ~b.ar;
	scale = Scale.harmonicMinor.ratios;
	splayed = CombN.ar(sig, 0.1, [freq, freq * Select.kr(chord_degree_1, scale), freq * Select.kr(chord_degree_2, scale), freq * Select.kr(chord_degree_3, scale)].reciprocal, 0.5);

	local = LocalIn.ar(2) + Splay.ar(splayed);

	15.do {
		local = [
			AllpassL.ar(local[0], 0.1, Rand(0.0001, 0.05), 1),
			AllpassL.ar(local[1], 0.1, Rand(0.05, 0.1), 1)
		];
	};

	LocalOut.ar(local * fb);
	Splay.ar(sig + local, LFNoise1.kr(0.2));
})

~a[10] = \set -> Pbind(\dur, 5, \chord_degree_1, Prand([1,2,3,4,5,6], inf), \chord_degree_2, Prand([1,2,3,4,5,6], inf), \chord_degree_3, Prand([1,2,3,4,5,6], inf))
~a.play

440 * Scale.harmonicMinor.degreeToRatio(6)
Scale.harmonicMinor.ratios.size

440 * 1.3333


s.scope

Splay

{Splay.ar([SinOsc.ar(), Saw.ar()], MouseY.kr(-1))}.play