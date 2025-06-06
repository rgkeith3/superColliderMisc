ProxySpace.push(s.boot)
p = currentEnvironment
p.makeTempoClock
p.clock.tempo_(165/60)
p.quant_(4)
p.pop

(
SynthDef(\bowed, {
	var gate = \gate.kr(1), atk = \atk.kr(0.01), rel = \rel.kr(0.1), vel = \vel.kr(0.5), force = \force.kr(0.5);
	var freq = SinOsc.ar(\vibFreq.kr(5), mul: Env.asr(atk, \vibAmt.kr(1), rel).ar(0, gate), add: \freq.kr(440, \gliss.ar(0.1)));
	var sig = DWGBowed.ar(freq, Env.asr(atk, vel, rel).ar(0, gate), Env.asr(atk, force, rel).ar(0, gate), gate, \pos.kr(0.5));
	sig = DWGSoundBoard.ar(sig);

	// sig = Resonz.ar(sig, [ 409.29969684988, 1314.7776800847, 396.56779269548, 136.73145114554 ], 0.1, 10).sum;

	sig = Pan2.ar(sig, \pan.kr(0), \amp.kr(0.8));

	Out.ar(\out.kr(0), sig);
}).add
)

~s[0] = Pbind(\instrument, \bowed, \octave, 4, \dur, 4, \degree, Pseq(Array.series(10, 0, 2), inf), \pan, Array.interpolation(5, -1.0), \vibFreq, Array.rand(5, 4.0, 5), \legato, 0.5, \amp, 0.01, \atk, 0.1, \scale, Pdefn(\scale), \vel, Pbrown(), \force, Pbrown())
~s[1] = Pbind(\instrument, \bowed, \octave, 5, \dur, 1, \degree, Pseq(Array.series(4, 0, 2), inf), \mtranspose, Pdup(3, Pseq((0..4), inf)), \pan, Array.interpolation(5, -1.0), \vibFreq, Array.rand(5, 4.0, 5), \legato,1, \amp, 0.01, \atk, 0.1, \scale, Pdefn(\scale), \vel, Pbrown(), \force, Pbrown())

~s[3] = Pbind(\instrument, \bowed, \octave, 3, \dur, 2, \degree, Pseq([0, 3], inf), \pan, Array.interpolation(5, -1.0), \vibFreq, Array.rand(5, 4.0, 5), \legato, 1, \amp, 0.01, \mtranspose, Pdup(3, Pseq((0..3), inf)), \atk, 0.1, \scale, Pdefn(\scale), \vel, Pbrown(), \force, Pbrown())

Pdefn(\scale, Scale.phrygian.tuning_(\just))


~s = Pbind(\instrument, \bowed)
(x.free; x = {
	var sig = DWGBowedTor.ar(50 * LFClipNoise.ar(4!4).range(1,2) * [1,2,3,4], LFNoise2.ar(1!4).bi2uni, LFNoise2.ar(1!4).bi2uni, 1, LFNoise2.ar(1!4).bi2uni).sum * 1/4;
	sig = DWGSoundBoard.ar(sig);
	sig;
}.play)

~s[100] = \filterIn -> {|in| NHHall.ar(in)}
~s.set(\wet100, 0.5)
~s.play