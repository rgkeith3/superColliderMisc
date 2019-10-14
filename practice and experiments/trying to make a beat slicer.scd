s.boot;

~break1 = Buffer.read(s, "/Users/greykeith/superCollider/sounds/breaks/eric_moore_breaks_cuts_3.wav");

~break1.play;
~break1Samples = ~break1.numFrames / 2;

~break1Samples / 4;

~sliceSize = ~break1Samples / 16;

~break1Samples.rand().round(~sliceSize);

~break1.bufnum

s.sampleRate

// length of the break in seconds
~break1Samples / s.sampleRate
//freq of break length
s.sampleRate / ~break1Samples
(
{
	[
		BufRd.ar(1, bufnum: ~break1, phase: Phasor.ar(1, rate: 1, start: 0, end: ~break1Samples)),
		Impulse.ar(s.sampleRate / ~break1Samples)
	]
}.play

)



(
var start = ~break1Samples.rand().round(~sliceSize).postln;
var end = ~break1Samples.rand().round(~sliceSize).postln;

{
	BufRd.ar(2, bufnum: ~break1, phase: Phasor.ar(1, rate: 1.2, start: start, end: end ))
}.play
)

b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

{ BufRd.ar(1, b,  Sweep.ar(Impulse.ar(BufDur.kr(b).reciprocal), BufSampleRate.kr(b))) }.play;

b.free

(
SynthDef.new(\breaker, {
	arg bufnum, t_trig=0, out=0;
	var reader;
	reader = BufRd.ar(
		2,
		bufnum,
		phase: Phasor.ar(t_trig, end: BufSamples.kr(bufnum), resetPos: 5000)
	);
	Out.ar(out, reader);
}).add;
)

x = Synth(\breaker, [\bufnum, ~break1.bufnum]);

x.set(\t_trig, 1);

// lets try it with a grain buf

(
SynthDef.new(\breaker_2, {
	arg t_trig, bufnum, maxDiv;
	var sliceSize = BufSamples.kr(bufnum) / maxDiv;
	var trigFreq = s.sampleRate / sliceSize;
	var grainTrig = Impulse.ar(trigFreq);
	var granulator = BufGrain.ar(grainTrig, trigFreq.reciprocal, bufnum, rate: 1, pos: MouseX.kr());
	Out.ar(0, granulator);
}).add;
)
~sliceSize
t = s.sampleRate / ~sliceSize

(
{
	GrainBuf.ar(2, Impulse.ar(t), sndbuf: ~break1)
}.play
)


