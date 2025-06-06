s.boot

Pbindef(\a, \degree, Pwalk((0..8), Prand([-1,1], inf), 1), \mtranspose, Pdup(4, Pwalk((0..8), Prand([-1,1], inf), 1)), \octave, Pdup(Prand([2,4,6], inf), Pwalk([4,5,6], Prand([-1,1], inf), 1)), \dur, Prand([1/2, Pseq([1/4], 2), Pseq([1/8], 2), Pseq([1/16], 4)], inf), \scale, Scale.pelog, \instrument, \gam)

Pbindef(\a, \rel, Prand([1, 2, 4], inf))
Pbindef(\a, \pan, Pbrown(-1))
Pbindef(\a, \amp, Prand([0.5, 0.8, 0.3], inf))


(SynthDef(\gam, {
	var sig = Ringz.ar(Env.sine(0.001, 0.1).ar(0,1), \freq.kr(440) * [1, Array.exprand(5, 1.5, 4)].flatten, \rel.kr(1) * [1, Array.exprand(5, 0.01, 1).sort.reverse].flatten, 1/6).sum * 0.5;
	DetectSilence.ar(sig, doneAction: 2);
	Out.ar(\out.kr(0), Pan2.ar(sig, \pan.kr(0), \amp.kr(0.8)));
}).add)
Pbindef(\a).play

(x.free; x = {
	Out.ar(0, FreeVerb.ar(In.ar(0, 2), room: 0.1, damp: 0))
}.play)
	