b = Buffer.readChannel(s, "/Users/greykeith/Downloads/202537__gowers__140-bpm-amen-break-original-processed.wav", channels: [0])
b.play

c = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");
p = ProxySpace.push(s.reboot)

d = Buffer.loadCollection(s, Env.perc.discretize)

(
SynthDef(\slice, {
	var bufFrames = BufFrames.ir(\buf.kr(-1));
	var phase = Line.ar(\start.kr(0), (\start.kr(0) + \slice.kr(1/8)), \dur.kr(16) * ~tempo.kr.reciprocal, doneAction: 2);
	var trate = 100;
	var sig = GrainBuf.ar(2, Impulse.ar(trate), trate.reciprocal * 2, \buf.kr(-1), \rate.kr(1), phase);
	sig = sig * (Amplitude.ar(sig, releaseTime: 0.05) > 0);
	sig = sig * Env.asr(0.01, 1, 0.01).ar(2, \gate.kr(1));
	Out.ar(\out.kr(1), sig!2);
}).load
)


p = ProxySpace.push(s)

p.makeTempoClock
p.clock.tempo = 165/60
b.plot
p.quant_(4)

Synth(\slice, [\start, 0, \buf, b, \slice, 1/8, \dur, 4])
// sample is 4 bars, 16 beats. dur and slice are almost always tied in that dur = beats * slice
// should have an event type tied to the synthdef
// should have some nice tricks for generating standard break kind of effects where it stretches it out (in this case, we wanna stretch the dur)
(
~a[0] = Pbind(
	\instrument, \slice,
	\buf, b,
	\start, Pstep(Array.rand(16, 0, 8)/32, 1/2, inf),
	\dur, 1/2,
	\slice, Pstep(Pwrand([1/32, 1/64, 1/128], [0.5, 0.2, 0.2], 1), 2, inf),
	\legato, Pstep(Pwrand([1, 1/2], [0.9, 0.1], 1), 2, inf),
	\rate, Pstep(Pwrand([1, 2, 4], [0.8, 0.1, 0.1], 1), 2, inf)
)
)

~a.play
(
SynthDef(\reese, {
	var sig;
	sig = (Saw.ar(\freq.kr(40, 0.1) + LFNoise2.ar(1!4)).sum).tanh;
	sig = Notch.ar(sig, LFNoise2.ar(0.5!2).exprange(1000, 5000), 1);
	sig = HPF.ar(sig, 20, 10).tanh;
	sig = sig * Env.adsr(releaseTime: 0.1).ar(2, \gate.kr(1));
	Out.ar(\out.kr(0), sig);
}).load;

SynthDef(\bass, {
	var sig;
	sig = LFTri.ar(\freq.kr(40) * Env([10, 1, 0], [0.01, 2], [-4, 6]).ar(0, \gate.kr(1))) * Env.perc(releaseTime: 2).ar(2, \gate.kr(1));
	Out.ar(\out.kr(0), sig!2);
}).load
)

~b[0] = PmonoArtic(\reese, \instrument, \reese, \octave, 2, \dur, Pseq([8, 4, 4] * 2, inf), \degree, Pseq([0, Prand([2, 6]), Prand([5,1])], inf), \legato, Pseq([0.8, 1, 0.5], inf), \scale, Scale.minorPentatonic)
~b.play
~b[10] = \filterIn -> {|in| FreeVerb.ar(HPF.ar(in, 1000, 0.5), 1, 0.1, 1)}
~b.set(\wet10, 0.5)

~c[0] = PmonoArtic(\bass, \instrument, \bass, \octave, 3, \dur, Pseq([1,1,1,1,2,2,3,2,3].scramble, inf), \degree, Pseq([0, 0, 2, \, 6, 0, -2, \, 3].scramble, inf), \scale, Scale.minor)

~c.play

Env([10, 1, 0], [0.01, 1], [-4, 4]).plot

~b.set(\wet10, 0.5)
~a.play; ~b.play

	[1,1,1,1,2,2,3,2,3].sum


~b.clear
~b.play

~a[10] = \filter -> {|in, divL=1, divR=1| CombN.ar(in, 2 * ~tempo.kr.reciprocal, [divL, divR] * ~tempo.kr.reciprocal, 2)}
~a[15] = \set -> Pbind(\wet10, Pwrand([0.5, 0], [0.3, 0.7], inf), \dur, 1/2, \divL, Prand([1/2, 1/4, 3/4, 3/2, 1/8, 1/16], inf), \divR, Prand([1/2, 1/4, 3/4, 3/2, 1/8, 1/16], inf), \wet7, Pwrand([0, 1], [0.8, 0.2], inf), \wet5, Pstep(Prand([0, 1]), 8, inf), \chop, Prand([1,2,4], inf))


~a[5] = \filter -> {|in| in * (Amplitude.ar(in) > 0.25)}
~a[5] = nil
~a[7] = \filter -> {|in| BPF.ar(in, LFNoise1.ar(~tempo.kr.reciprocal / 2).exprange(500, 1000), 0.5)}
	~a[7] = \filter -> {|in| in * LFPulse.ar(~tempo.kr * \chop.kr(4))}
~a[7] = nil

~a[2] = \filter -> {|in| (in * 2).tanh}
~a[2] = nil

~a.play




~tempo.asBus.getSynchronous
16 * ~tempo.asBus.getSynchronous.reciprocal

s.options.memSize_(2.pow(15));
s.reboot

// got a lil crazy here
(x.free; x = {
	var n = 4;
	var mod = MouseX.kr(0,1);
	var grate = LFNoise2.ar(1/4).exprange(2, 2.pow(8));
	var bandDelayMod = LFNoise0.ar(1/8).range((0..9)/9, (0..9).reverse/9) * mod;
	// grate = 100;
	// with lfsaw taking 8 seconds to loop, that will fit this loop into 8 seconds
	// var sig = GrainBuf.ar(
	// 	numChannels: 2,
	// 	trigger: Impulse.ar(grate),
	// 	dur: 1/(grate/2),
	// 	sndbuf: b,
	// 	rate: LFNoise2.ar(1/4).exprange(1/4, 4),
	// 	pos: LFSaw.ar(1/8).bi2uni,
	// 	pan: LFDNoise3.ar(LFNoise2.ar(1/4).exprange(1/32,32))
	// );

	// pos
	// the stepped noise will choose a new number, 0 - 15 2 times a second,
	// that will translate to 1/16th slice somewhere, and the lfsaw is adding a ramp of that slice, 2 times a second
	var sig = GrainBuf.ar(
		numChannels: n,
		trigger: Impulse.ar(grate),
		dur: 1/(grate/2),
		sndbuf: b,
		rate: SelectX.ar(mod.linlin(0,1,0,2), [DC.ar(1), LFNoise0.ar(4, 4)]),
		pos: Select.ar(1, [LFSaw.ar(1/8).bi2uni, LFNoise0.ar(2).range(0, 15).floor/16 + (LFSaw.ar(2, 1).bi2uni * 1/16)]),
		pan: LFDNoise3.ar(LFNoise2.ar(1/4).exprange(1/32,32))
	);

	// sig = CombC.ar(sig, 1,
	// 	delaytime: 2.pow(LFNoise0.ar(2!n).range(1, -8).floor),
	// decaytime: LFNoise0.ar(2!n).exprange(0.001, 10)) + sig;

	sig = (0..9).collect({|ex| 20 * 2.pow([ex, ex+1])}).collect({|freqs, i|
		var band = BHiCut.ar(BLowCut.ar(sig, freqs[0], 4), freqs[1], 4);
		band = CompanderD.ar(band, 0.2, slopeBelow: 2, slopeAbove: 0.1, clampTime: 0.001, relaxTime: 0.01);
		band;
	}).collect({|b, i|
		DelayN.ar(b, 1, bandDelayMod[i] * 1/4);
	}).sum;
	sig = sig * Env.perc(0, 1).ar(0, Impulse.ar(8));

	sig = sig.collect({|ch, i|
		DelayC.ar(ch, 1/2, (i/n * 1/2).postln);
	});

	Splay.ar(sig);
}.play)
FormantTable.rand
// the relationship between steps, slices, powers of 2 etc
// I feel like this could be infinitely expandable

// turn this into a synthdef
// play in a pattern, change the rand seed deterministically
(x.free; x = {
	var loopDur,
	formant1,formant2, formants,
	grate,
	steps, stepHz,
	repeatsPerStep, posBase, sliceHz,
	sliceDir,
	sliceRamp,
	pos,
	coords,
	sig;

	// RandSeed.ir(1, [78381, 69530].choose);

	// loopDur = SinOsc.ar(0.1).exprange(5, 8);
	// loopDur = 6;
	loopDur = (165/60).reciprocal * 16;

	formant1 = FormantTable.rand;
	formant2 = FormantTable.rand;
	formants;

	// grate = 2.pow(10.rand).postln;
	// steps = 2.pow(10.rand).postln;
	// repeatsPerStep = 2.pow(10.rand).postln;
	grate = 1024;
	steps = 2.pow(TRand.ar(0, 6, Impulse.ar(loopDur.reciprocal)).floor);
	stepHz = steps / loopDur;
	repeatsPerStep = 2.pow(TRand.ar(0, 4, Impulse.ar(stepHz)).floor);
	posBase = TRand.ar(0, steps, Impulse.ar(stepHz)).floor/steps;
	sliceHz = repeatsPerStep * stepHz;
	// modulating grate lower than say 128 gets really cool, but pretty noisey
	// grate = loopDur.reciprocal * 2.pow(LFDNoise3.ar(sliceHz).range(4, 11));
	sliceDir = LFClipNoise.ar(sliceHz);
	// sliceDir = 1;
	// posBase = Stepper.ar(Impulse.ar(steps/loopDur), max: steps - 1)/steps;
	sliceRamp = LFSaw.ar(sliceHz * sliceDir, 1).bi2uni * (1/(steps)/repeatsPerStep);
	pos = (posBase + sliceRamp);
	// sig = GrainBuf.ar(
	// 	numChannels: 2,
	// 	trigger: Impulse.ar(grate),
	// 	dur: 1/(grate/2),
	// 	// dur: WhiteNoise.ar.exprange(1/(grate/2), 1/(grate/128)),
	// 	sndbuf: b,
	// 	rate: LFDNoise3.ar(stepHz).exprange(1/4, 4) * sliceDir,
	// 	pos: pos,
	// 	// pan: LFDNoise0.ar(sliceHz)
	// 	pan: LFDNoise3.ar(sliceHz)
	// );

	// sig = sig * (Amplitude.ar(sig) > 0.1);

	coords = Cartesian(LFDNoise3.ar(stepHz, 5), LFDNoise3.ar(stepHz, 5), LFDNoise3.ar(stepHz, 5));
	sig = BufGrainBF.ar(
		trigger: Impulse.ar(grate),
		dur: 1/(grate/2) * LFDNoise3.ar(stepHz).exprange(1, 4),
		// dur: 1/(grate/2),
		sndbuf: b,
		rate: LFDNoise3.ar(stepHz).exprange(1, 4) * sliceDir,
		pos: pos,
		// envbuf: d,
		azimuth: coords.theta,
		elevation: coords.phi,
		rho: coords.rho.pow(MouseY.kr(0, 1))
		// rho: 1
	);

	sig = FoaDecode.ar(sig, FoaDecoderMatrix.newBtoA);

	sig = CombC.ar(BPF.ar(sig, LFDNoise3.ar(sliceHz!sig.size).exprange(100, 10000), 0.5), loopDur/4, loopDur/2.pow(LFDNoise0.ar(sliceHz).range(5,10).floor), LFDNoise1.ar(sliceHz).range(0, 5)) + sig;

	// sig = FreeVerb.ar(sig, 0.5, 0.01, 1);

	sig = FoaEncode.ar(sig, FoaEncoderMatrix.newAtoB);

	// formants = SelectX.ar(LFDNoise3.ar(stepHz).bi2uni, DC.ar([formant1, formant2]));
	// sig = sig.collect({|ch|
	// 	Resonz.ar(ch, formants[0], formants[1], formants[2]).sum;
	// });
	//

	sig = FoaDecode.ar(sig, FoaDecoderMatrix.newStereo);

	sig;
}.play)

(x.free; x = {
	var chain;
	var coords = Cartesian(LFNoise2.ar(1, 5), LFNoise2.ar(1, 5), LFNoise2.ar(1, 5));
	var sig = BufGrainBF.ar(Impulse.ar(200), 1/100, b, 1, LFSaw.ar(8.reciprocal).bi2uni, coords.theta, coords.phi, coords.rho);

	sig = FoaDecode.ar(sig, FoaDecoderMatrix.newBtoA);

	sig = CombN.ar(sig, 0.2, coords.rho.linlin(0, 5, 0.00001, 0.1), 1);

	sig = FoaEncode.ar(sig, FoaEncoderMatrix.newAtoB);

	FoaDecode.ar(sig, FoaDecoderMatrix.newStereo);
}.play)


(x.free; x = {
	var freq = 1000;
	BufGrainB.ar(Impulse.ar(freq), 1/freq * 2, b, 1, 0, d) * Env.perc.ar(2, 1);
}.play)

7.midiratio
10.rand


{var steps = 8;Stepper.ar(Impulse.ar(120), max: steps - 1)/steps}.scope
{var steps = 8;Stepper.ar(Impulse.ar(120), max: steps - 1)/steps + (LFSaw.ar(240, 1).bi2uni * 1/steps)}.scope
(0).linlin(-1, 1, (0..4)/4, (4..0)/4)

// 10 band eq
(0..9).collect({|ex| 20 * 2.pow([ex, ex+1])})

20.pow(0)