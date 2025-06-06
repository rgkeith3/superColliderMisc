// 7.1 ambisonic set
(
// s.options.outDevice_('DENON-AVAMP');
s.options.numOutputBusChannels_(8);
s.options.numWireBufs_(1024);
s.options.memSize_(8192 * 2);
)

(
// closest panto decoder to 7.1
~numChans = 7;
~pantoDecoder = FoaDecoderMatrix.newPanto(numChans, 'point');
~pantoTo71 = {|sig|
	var left, right, sub, center, leftSurround, rightSurround, leftRear, rightRear;
	# center, right, rightSurround, rightRear, leftRear, leftSurround, left;
	[left, right, Mix(sig * (1/numChans)), center, leftSurround, rightSurround, leftRear, rightRear];
};
)

// load a synthdef file that compiles defs with different panning funcs based on numChans

s.options.sampleRate_(192000);
s.reboot


// whoa, kinda interesting
(
x.free; x = {
	var noiseRate = LFDNoise3.ar(LFNoise2.ar(1).exprange(0.1, 10)).exprange(0.01, 1000);
	var sig = GrainFM.ar(
		2,
		Impulse.ar(LFDNoise3.ar(noiseRate).exprange(1, 100)),
		LFDNoise3.ar(noiseRate).exprange(0.001, 1),
		LFDNoise3.ar(noiseRate).exprange(20, 1000),
		LFDNoise3.ar(noiseRate).exprange(20, 20000),
		LFDNoise3.ar(noiseRate).exprange(0.01, 10),
		LFDNoise3.ar(noiseRate));
	var trig = Trig.ar(noiseRate > 1, 0.1);
	var chain = LocalBuf(1024!2);
	trig = Ringz.ar(trig, TExpRand.ar(20, 5000!10, trig), TExpRand.ar(hi: 5!10, trig: trig), 1/40).sum;
	sig = Mix([LocalIn.ar(2), sig]);
	sig = 10.collect({|i|
		var top, bottom, band;
		band = sig;
		if(i == 0, {
			band = band
		}, {
			band = HPF.ar(band, (i - 1).linexp(0, 9, 40, 22000));
		});
		if(i == 9, {
			band = band
		}, {
			band = LPF.ar(band, i.linexp(0, 9, 40, 22000));
		});
		CompanderD.ar(band, LFDNoise3.ar(noiseRate).bi2uni, LFDNoise3.ar(noiseRate).linexp(-1, 1, 0.5, 2), LFDNoise3.ar(noiseRate).linexp(-1, 1, 0.5, 2), LFDNoise3.ar(noiseRate).bi2uni, LFDNoise3.ar(noiseRate).bi2uni);
	});
	sig = (sig * LFDNoise3.ar(noiseRate).exprange(0.1, 10)).tanh;
	sig = PitchShift.ar(sig, pitchRatio: LFDNoise3.ar(noiseRate).exprange(0.25, 4));
	sig = sig * SelectX.ar(LFDNoise3.ar(noiseRate).range(0,1), [DC.ar(1), SinOsc.ar(LFDNoise3.ar(noiseRate).range(1, 16)).bi2uni]);
	sig = FreqShift.ar(sig, LFDNoise3.ar(noiseRate, 1000));
	sig = sig.sum;
	sig = Compander.ar(sig, trig, slopeBelow: 1, slopeAbove: 0.5) + trig;
	sig = FreeVerb.ar(sig, LFDNoise3.ar(noiseRate).bi2uni, LFDNoise3.ar(noiseRate).bi2uni, LFDNoise3.ar(noiseRate).bi2uni);
	chain = FFT(chain, sig);
	chain = PV_RandComb(chain, LFDNoise3.ar(noiseRate).bi2uni);
	chain = PV_BinScramble(chain, LFDNoise3.ar(noiseRate).bi2uni);
	sig = IFFT(chain);
	LocalOut.ar(DelayC.ar(sig, delaytime: LFDNoise3.ar(noiseRate).linexp(-1, 1, 0.001, 0.2)));
	sig;
}.play
)

s.record


s.options.sampleRate_(48000)
s.reboot


b = Buffer.readChannel(s, '/Users/greykeith/Music/SuperCollider Recordings/SC_250109_180346.wav', channels: [0]);
(
{
	var noiseRate = [MouseY.kr(0.001, 1000, 1), MouseX.kr(0.001, 1000, 1)];
	var trigRate = LFDNoise3.ar(noiseRate[0]).range(1, 100);
	var trig = Impulse.ar(trigRate);
	var sig = GrainBuf.ar(
		6,
		trig,
		LFDNoise3.ar(noiseRate[1]).range(0.001, 0.1),
		b,
		LFDNoise3.ar(noiseRate[0], 2),
		LFDNoise3.ar(noiseRate[1]).range(0,1),
		2,
		LFDNoise3.ar(noiseRate[0])
	);
	sig = LPF.ar(sig, 5000);
	Splay.ar(CombC.ar(sig, delaytime: ExpRand(0.001!6, 0.2), decaytime: Rand(0.0, 3.0!6)) + sig);
}.play)




~post = Bus.audio(s, 2);
(

SynthDef(\piano, {
	var sig = Ringz.ar(Impulse.ar(0), \freq.kr(220) * [1, 2, 3, 4, 5, 6, 7, 8], 1/[1,2,3,4,5,6,7,8] * 5, (1/[1,2,3,4,5,6,7,8] * 0.linlin(0, 1, 1, 8)).clip(0, 1) * 1/8).sum;
	sig = sig * Env.asr(releaseTime: 0.1).ar(2, \gate.kr(1));
	sig = Resonz.ar(sig, Array.exprand(10, 100, 1000), 0.01).sum + (sig * 1/8);
	Out.ar(\out.kr(0), Pan2.ar(sig, \pan.kr(0)));
}).load;

Routine({
	var numNotes = 3.rrand(8);
	var notes = Scale.major.tuning_(\just).degreeToFreq(Array.rand(numNotes, -3, 8), 440, -1);
	var durs = Array.exprand(numNotes, 1, 8).floor.normalizeSum * 8;
	var delays = Array.rand(numNotes / 2, -1.0, 1.0).normalizeSum;
	delays = [delays, delays * -1].flatten.scramble;
	loop {
		[notes, durs, Array.rand(numNotes, -1.0, 1.0)].flop.do {|event|
			var freq, dur, pan, synth;
			#freq, dur, pan = event;
			freq.postln;
			dur.postln;
			pan.postln;
			synth = Synth(\piano, [\freq, freq, \pan, pan, \out, ~post]);
			dur.wait;
			synth.set(\gate, 0);
		};
	};
}).play;

{
	var sig = In.ar(~post, 2);
	sig = FreeVerb.ar(sig, 1, 0.8, 1) + sig;
	sig = sig + Crackle.ar(1, 0.01 * LFNoise1.ar(5).range(0.5, 1));
	sig = DelayC.ar(sig, 0.1, LFNoise2.ar(0.5).range(0, 0.1));
	sig = CompanderD.ar(sig, slopeBelow: 0.5, slopeAbove: 0.5);
	sig = sig * LFNoise1.ar(5).range(0.5, 1);
	Out.ar(0, sig);
}.play
)


({
	var notes = Scale.major.tuning_(\just).degreeToFreq((-12..12).scramble[0..6], 440, -1);
	notes = notes.collect {|note|
		var partials = 12.collect {|i|
			SinOscFB.ar(i + 1 * note, LFNoise2.ar(0.5).exprange(0.01, 100), LFNoise2.ar(0.5).bi2uni * 1/(i + 1))
		};
		Splay.ar(partials.scramble, level: LFNoise2.ar(0.5).bi2uni);
	}.sum;
	notes = notes * 1/12;
	notes = Notch.ar(notes, 4000, 1);
	notes = Resonz.ar(notes, Array.exprand(4, 50, 1000), Array.exprand(4, 0.01, 0.1), 10).sum + notes;
	notes = FreeVerb.ar(notes * LFNoise1.ar(5).bi2uni, 1, 1, 1) + Crackle.ar(LFNoise1.ar(1).range(0.5, 1.5), LFNoise2.ar(1!2).range(0, 0.05));
	notes;
}.play)

({
	var trig = Env.perc(0.0001, 0.0001, curve: 0).ar(0, Impulse.ar(MouseY.kr(0.1, 16, 1)));
	Ringz.ar(trig, Array.exprand(5, 50, 500).sort, Array.exprand(5, 0.1, 1).sort.reverse, 1/5).sum;
}.play)


({
	var dropLength = MouseY.kr(0.01, 1, 1);
	GrainFM.ar(1, Dust.ar(50), dropLength, 50, dropLength.reciprocal / 4, 100)
}.play)

(
SynthDef(\drop, {
	var sig = SinOsc.ar(Env([\freq.kr(250) * 4, \freq.kr(250), \freq.kr(250) * 4], [0.01, 0.1], [-4, 2]).ar(0, 1)) * Env.perc.ar(2, 1, 0.1);
	Out.ar(\out.kr(0), Pan2.ar(sig, \pan.kr(0)));
}).load;

Routine({
	loop {
		Synth(\drop, [\freq, 150.rrand(1000), \pan, 1.0.rand2]);
		0.1.rand.wait;
	}
}).play)

~env = Buffer.loadCollection(s, Env.perc.discretize)
~env.plot

(x.free; x = {
	var ramp, dong, time, shimmer, trig;
	time = 2;
	trig = DelayN.ar(Impulse.ar(0), time, time);
	ramp = WhiteNoise.ar * Env(times: [time, 0], curve: 4).ar(0, 1);
	ramp = Resonz.ar(ramp, 50 * Array.exprand(10, 1, 10), 0.1, 10);
	ramp = Splay.ar(ramp);
	dong = Ringz.ar(trig, 50 * Array.exprand(10, 1, 10), Array.exprand(10, 0.1, 2));
	dong = Splay.ar(dong);
	dong = dong + SinOscFB.ar(Env.perc(0, 0.01).ar(0, trig, levelScale: 10000, levelBias: [50, 51]), 2, Env.perc(0, 3).ar(2, trig));
	shimmer = Dust.ar(Env([0, 15, 0], [1, 3]).ar(0, trig));
	shimmer =
	ramp + FreeVerb.ar(dong + shimmer, 1) + dong + shimmer;
}.play)

s.scope
(-12..12).scramble[0..6]

	[[1,2,3], [9,8,7], [-1, 1, -1]].flop