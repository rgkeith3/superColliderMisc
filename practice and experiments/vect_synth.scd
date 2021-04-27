// would be cool to encorporate dopler effect in this. maybe make this ambisonic
s.boot
(
SynthDef(\vect_synth, {
	|freq=250, pitch_env=0.5, start_filt=20000, end_filt=10, filt_q=0.5, atk=1, hold=0, rel=1, clock=1, pan_start=0, pan_end=2, amp=1, out=0|
	var sig, env, filter_vect, pan_vect, pitch_vect, atk_time, hold_time, rel_time, total_time;

	atk_time = atk * clock.reciprocal;
	hold_time = hold * clock.reciprocal;
	rel_time = rel * clock.reciprocal;
	total_time = atk_time + hold_time + rel_time;

	env = EnvGen.ar(Env([0, amp, amp, 0], [atk_time, hold_time, rel_time]), doneAction: 2);
	pitch_vect = Line.ar(freq + (freq * pitch_env), freq - (freq * pitch_env), total_time);

	sig = SawDPW.ar(pitch_vect) * env;

	filter_vect = Line.ar(start_filt, end_filt, total_time);
	sig = RLPF.ar(sig, filter_vect, filt_q);

	pan_vect = Line.ar(pan_start, pan_end, total_time);
	// change this to use pan4
	sig = PanAz.ar(2, sig, pan_vect);

	Out.ar(out, sig);
}).add
)
t = TempoClock.new(140/60)
(
Pdef(\vectors,
	Pbind(
		\instrument, \vect_synth,
		\delta, 1,
		\clock, t.tempo,
		\degree, Pdefn(\degree, 1),
		\octave, 5,
		\start_filt, Pwhite(50, 5000),
		\end_filt, Pwhite(50, 5000),
		\filt_q, 0.1,
		\pitch_env, 1,
		\atk, 1,
		\hold, 1,
		\rel,1,
		\pan_start, 0,
		\pan_end, Pseq([1, -1], inf),
		\amp, 0.5
	)
).play(t)
)

Pdefn(\degree, Pseq([1,3,5,6,5], inf))

~chord = [1,5,7,11];
~chord = [2,4,6, 9];
