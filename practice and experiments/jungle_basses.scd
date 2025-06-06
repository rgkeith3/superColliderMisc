s.boot

// crunchy reese
(x.free; x = {
	var sig = LFSaw.ar(50 * LFNoise1.ar(1!5, 0.05).exprange(0.5, 2)).sum;

	sig = RLPF.ar(sig.distort, 500, 0.5) + RHPF.ar(sig.distort, 5000, 0.5);
	sig = Notch.ar(sig.distort, LFNoise1.ar(0.1!2).exprange(500, 5000), 1);
	sig = BLowCut.ar(sig.distort, 100) + LFTri.ar(50)!2;
	sig.distort;
}.play)

// smoother reese
(x.free; x = {
	var sig = LFTri.ar(50 * LFNoise1.ar(1!5, 0.05).exprange(0.5, 2), mul: 1/5);
	sig = Splay.ar(sig);

	sig = LPF.ar(sig, 500);
	sig = BLowCut.ar(sig, 100, 2) + SinOsc.ar(50, mul: 1/4);
	sig.distort;
}.play)

// wobble
(x.free; x = {
	// var sig = LFTri.ar(50);
	var sig = LFPulse.ar(50);
	var mod = SinOsc.ar(6);

	sig = RLPF.ar(sig, mod.exprange(50, 5000), 0.5) * mod.bi2uni;
	sig.distort;
}.play)

// drop
(x.free; x = {
	var rel = 4;
	var freq = 50 * Env([10, 1], 0.01).ar(0, 1) * Env([1, 0.5], rel, 2).ar(0, 1);
	var sig = SinOsc.ar(freq);
	// var sig = LFTri.ar(freq);
	sig = sig * Env.perc(releaseTime: rel).ar(2, 1);
	sig!2
}.play)

(
SynthDef(\drop, {
	var rel = \rel.kr(4);
	var gate = \gate.kr(1);
	var freq = \freq.kr(50) * Env([10, 1], 0.001).ar(0, gate) * Env([1, 0.5], rel, 2).ar(0, gate);
	// var sig = LFTri.ar(freq);
	var sig = SinOsc.ar(freq);
	sig = sig * Env.perc(releaseTime: rel).ar(2, gate) * Env.asr(0.01, releaseTime: 0.01).ar(2, gate);
	Out.ar(\out.kr(0), Pan2.ar(sig, \pan.kr(0)));
}).add
)

PmonoArtic(\drop, \dur, Pseq(Bjorklund2(3, 4).scramble ++ [12], inf) / 2, \rel, 4, \octave, 3, \legato, 0.99, \degree, Pseq(Array.rand(4, -6, 6), inf)).play