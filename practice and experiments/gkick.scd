s.reboot
// gabber blowout
(x.free; x = {
	var freq = 50;
	var sig = SinOscFB.ar(Env([2000, 2000, [freq, freq + 1], 0], [0.01, 0.05, 1], [0 ,-8, 8]).ar(2), 100);
	sig = sig + (sig.bi2uni * HPF.ar(ClipNoise.ar, 5000));
}.play)


(SynthDef(\gab, {
	var sig = SinOscFB.ar(Env([\beep.kr(2000), \beep.kr(2000), \freq.kr(50, 0.3),0], [\btime.kr(0.05), \ktime.kr(0.05), \rel.kr(1)], [0, -8, 8]).ar(gate: \gate.kr(1)), \fb.kr(100));
	sig = sig + (sig.bi2uni * HPF.ar(ClipNoise.ar, \nco.kr(5000), \nvol.kr(1)));
	sig = sig * Env.adsr(0, \btime.kr(0.05) + \ktime.kr(0.05), 0.5, 0.01).ar(2, \gate.kr(1));
	Out.ar(0, Pan2.ar(sig, \pan.kr(0)))
}).load)

Pbindef(\g, \instrument, \gab, \dur, Pseq([1, 1, 1, 2/3, 1/3], inf) / 4, \octave, 2, \degree, Prand((0..3), inf), \legato, 1, \beep, 2000, \btime, 0.01, \nvol, 0.3, \fb, 0).play

s.scope

50 * 2.pow(7)