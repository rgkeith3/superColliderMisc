(~a[0] = {
	var chord1, chord2;
	chord1 = [Scale.minor.ratios[1], Scale.minor.ratios[2], Scale.minor.ratios[4]];
	chord2 = [Scale.minor.ratios[4], Scale.minor.ratios[5], Scale.minor.ratios[6]];
	Splay.ar(Saw.ar(
		SinOsc.kr(0.01, Rand(0, 0.25!3)).range(220 * chord1, 220 * chord2)
	));
})

(~a[0] = {
	var chord1, chord2;
	chord1 = [Scale.minor.ratios[1], Scale.minor.ratios[2], Scale.minor.ratios[4]] * 220;
	chord2 = [Scale.minor.ratios[4], Scale.minor.ratios[5], Scale.minor.ratios[6]] * 220;
	Splay.ar(Saw.ar(
		EnvGen.kr(Env.adsr(Rand(5, 7!3), sustainLevel: 1, releaseTime: Rand(5, 7!3), curve: \sin), ToggleFF.kr(Impulse.kr(1/20))).linlin(0, 1, chord1, chord2) + LFNoise1.kr(1!3, 5)
	));
})

~a[10] = \filter -> {|in| GVerb.ar(in, 50)}

~a[20] = nil
~a.set(\wet20, 0.5)
~a.set(\wet10, 0.5)

~a.play

(SynthDef(\curveSaw, {|freq=440, gate=1, lag=0.2, out=0|
	var sig, laggedFreq;
	laggedFreq = VarLag.kr(freq, lag, 8, \sin);
	sig = Saw.ar(laggedFreq);
	Out.ar(out, Pan2.ar(sig, LFNoise1.kr(1)));
}).load)

~a[0] = Pmono(\curveSaw, \scale, Scale.minor, \degree, Pseq([[1,2,4],[4,5,6]], inf), \dur, 20, \lag, 5, \octave, 4)
~a.play

(
// used to lag pitch
{                            // sine wave
	VarLag.kr(in: LFPulse.kr(1), time: 0.2, curvature: Line.kr(-8, 8, 15, doneAction: Done.freeSelf))
}.scope
)