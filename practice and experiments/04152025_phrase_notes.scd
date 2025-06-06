s.reboot

(x.free; x = {
	var freqs = Scale.major.tuning_(\just).degreeToFreq((0..8).scramble[0..3], 440, -1);
	// var fb = FbNode.new(2, 1, 2);
	var sig = Pluck.ar(
		SinOsc.ar(LFNoise2.ar(1!4).exprange(1000, 2000)),
		Impulse.ar(DelayN.ar(SinOsc.ar(0.25).exprange(1, 8), 1, Array.interpolation(4, end: 1) * SinOsc.ar(0.1).bi2uni)),
		0.2,
		Lag.ar(
			Select.ar(
				PanAz.ar(
					4,
					DC.ar(1),
					LFNoise2.ar(0.1),
					width: LFNoise2.ar(0.1).range(1, 4)
				),
				DC.ar(freqs)
			),
			2,
		).reciprocal,
		LFNoise2.ar(0.25!4).exprange(0.01, 1),
		PanAz.ar(4, DC.ar(1), LFNoise2.ar(1).bi2uni, width: LFNoise2.ar(0.1).range(1, 4))
	);
	sig = Splay.ar(sig) + Splay.ar(Resonz.ar(BrownNoise.ar, freqs, 0.001, 10), center: LFNoise2.ar(1));
	// fb.write(sig);

	// sig = Mix([sig, fb.delay(LFNoise2.ar(1).pow(LFNoise2.ar(0.1).exprange(1, 32)).bi2uni)]);
	FreeVerb.ar(sig, room: LFNoise2.ar(1).bi2uni, damp: LFNoise2.ar(1).bi2uni, mul: LFNoise2.ar(1).exprange(1, 10)).tanh;
}.play)


(
SynthDef(\p, {
	var freq = Env([\freq.kr(440) * \bend.kr(0).linexp(-1, 1, 0.5, 2), \freq.kr(440)], [\pDec.kr(0.01)], -4,).ar(0, 1);
	var sig = Pluck.ar(
		SinOsc.ar(\exc_freq.kr(500)),
		1,
		(\freq.kr(440) * 0.5).reciprocal,
		freq.reciprocal,
		\dec.kr(1),
		\timbre.kr(0.5);
	);
	DetectSilence.ar(sig, doneAction: 2);
	sig = Pan2.ar(sig, \pan.kr(0), \amp.kr(0.8));
	Out.ar(\out.kr(0), sig);
}).add;

SynthDef(\s, {
	var freq = \freq.kr(440, \glide.kr(0.1));
	var sig = SinOscFB.ar(freq, \fb.kr(0.1)) * Env.adsr(\atk.kr(0.01), \dec.kr(0.3), 0.5, \rel.kr(1)).ar(2, \gate.kr(1));
	sig = Pan2.ar(sig, \pan.kr(0), \amp.kr(0.8));
	Out.ar(\out.kr(0), sig);
}).add;
)
(
p = ProxySpace.push(s);
p.makeTempoClock;
)
(
p.clock.tempo_(165/60);
p.quant_(4);
)

Env([2, 1], [1], -4).plot


~a[0] = Pbind(\instrument, \p, \degree, Pdefn(\deg), \dur, 1/2, \strum, 0.01, \dec, Pwrand([1, 5, 10], [9, 2, 1].normalizeSum, inf), \octave, 5, \pDec, 0.05, \bend, Pwhite(-0.5, 0.5), \timbre, Pbrown(0, 0.5), \pan, Pwhite(-1), \scale, Pdefn(\scale))

~a.play

~a[0] = PmonoArtic(\s, \degree, Pdefn(\deg), \dur, 1/2, \strum, 0.1, \octave, 6, \pan, Pwhite(-1), \scale, Pdefn(\scale), \fb, Pbrown(), \legato, Pbrown(hi: 1.5), \atk, Pbrown(hi: 0.1), \ctranspose, Pwrand([0, 1], [20, 1].normalizeSum, inf))
~a[0] = Pbind(\instrument, \s, \degree, [0, 2, 4], \dur, 2, \octave, 5, \fb, 1, \mtranspose, Pdefn(\mt), \strum, 0.1)
// playing differen chords by adding a vector
Pdefn(\mt, Pdup(4, Pfunc({Array.rand(3, 0, 1)})))
Pdefn(\mt, 0)

~a[10] = nil
~a[10] = \filterIn -> {|in| NHHall.ar(in, LFNoise2.ar(0.1).exprange(1/4, 4))}; ~a.set(\wet10, 0.5)

~a.play
~b.play
~a.stop

~b[0] = PmonoArtic(\s, \degree, Pstep((0..8).scramble[0..3], 8, inf), \octave, 3, \fb, 2, \scale, Pdefn(\scale), \dur, Prand([1, 1/2, 3/2], inf), \legato, Pwrand([0.8, 1], [3, 1].normalizeSum, inf))

~b.play
~rev[0] = nil
~rev[1] = \mix -> {~a.ar};
~rev[2] = \mix -> {~b.ar};
~rev[3] = \mix -> {~del.ar};
~rev.set(\mix3, 0.1)
~rev[100] = \filterIn -> {|in| NHHall.ar(in, 2).distort}
~rev.play
~rev.set(\mix1, 1)
~rev.set(\mix2, 1)
~rev.set(\mix3, 0.1)
~del[1] = \mix -> {~a.ar}
~del[2] = {~b.ar}
~del[3] = \mix -> {~rev.ar}
~del[100] = \filterIn -> {|in| var sig, fb = FbNode(2, 4); sig = fb.delay(~tempo.kr.reciprocal * \div.kr(1))* \fb.kr(0.8); fb.write((sig + in).tanh); sig;}

~del[105] = \filter -> {|in| RLPF.ar(in, LFNoise2.ar(0.1!2).exprange(100, 20000), 0.1)}

~del[110] = \filterIn -> {|in| CombN.ar(HPF.ar(in, 1000), delaytime: ~tempo.kr.reciprocal * 1/16)}

~del.set(\wet110, 0.5)
~tempo
~del.play
~del.set(\div, 1/64)
~a.stop
~a.stop
~del.set(\fb, 0.999)
~del.set(\wet100, 1)
~del.set(\mix1, 1)
~del.set(\mix2, 0)
~del.set(\mix3, 0.1)
~a.stop; ~b.stop; ~rev.stop
~del.gui
~del.play

~lfn = {LFDNoise3.ar(LFDNoise3.ar(LFDNoise3.ar(0.1).exprange(0.1, 10)).exprange(0.1, 10)).exprange(1/4, 4)}
~lfn = {1/64}
~lfn.mold(2, \audio)

Tuning.directory

Pdefn(\scale, Scale((0..30).scramble[0..8].sort, 31, \et31))
Pdefn(\scale, Scale.hexPhrygian.tuning_(\just))
Pdefn(\scale, Scale.augmented)

Pdefn(\deg, (0..8).scramble[0..3].postln)
Pdefn(\deg, Pseq(Array.fill(16, {(-6..8).choose}), inf))

Scale.directory
Scale.chromatic.degreeToFreq([0,1,2], 440, 0)
Scale.major.degreeToFreq([0, 1], 440, 0)
s.scope


~b.clear
Pdefn(\deg, Pseq((0..8), inf))

(~b = Routine({
	loop {
		var deg = (0..8).scramble[0..3];
		Pdefn(\deg, Prand(deg, inf));
		16.wait;
	}
}))



(SynthDef(\saw, {
	var freq = \freq.kr(50, \glide.kr(0.1));
	var sig = Saw.ar(LFNoise2.ar(\detuneSpeed.kr(1)!3, \detune.kr(1), freq), \distort.kr(1)).sum.distort;
	sig = sig * Env.adsr(\atk.kr(0.01), \dec.kr(0.3), 0.5, \rel.kr(1)).ar(2, \gate.kr(1)) * \amp.kr(0.8);
	sig = Pan2.ar(sig, \pan.kr(0));
	Out.ar(\out.kr(0), sig);
}).add)

~a.play
~s[0] = PmonoArtic(\saw, \degree, Pstep((0..8).scramble[0..3], 8, inf), \dur, Prand([1,2,3,4], inf), \octave, 2, \distort, 100, \detune, 1, \legato, Prand([0.8, 1], inf), \glide, 0.3, \scale, Pdefn(\scale), \amp, 0.8)
~s[10] = \filter -> {|in| RLPF.ar(in, LFDNoise3.ar(LFDNoise3.ar(1!2).exprange(1/4, 4)).exprange(50, 10000), LFNoise2.ar(1!2).range(0.2, 1))}
~s[15] = \filter -> {|in| Notch.ar(in, LFNoise2.ar(1!2).exprange(500, 5000), 1)}

~s[50] = \filterIn -> {|in| NHHall.ar(HPF.ar(in, 200), 2) + in}
~s.set(\wet50, 1)
~s.play

~s = Pbindf(Prout({loop { (dur: 3.rrand(1), degree: 8.rand).yield }}), \instrument, \saw, \octave, 2)

// a performance data structure
// a song -> sections -> phrases

// a phrase is a single routine
// you can build up a phrase note by note, or with segments across notes
// we can duplicate a lot of the ableton phrase generation functionality on a per phrase basis

// sections have phrases per track
// index into a section to get a phrse for a track

// tracks don't necessarily have to be the same instrument, but it's one similar sequence of phrases
// if a song is an xy table
// tracks are the rows
// sections are the columns
// and at each xy coordinate is maybe a phrase (or nothing)
// the goal is you can index through the song by scheduleing sections, like a chorus, verse, bridge, etc

// phrases in a section don't necessarily have to be the same length, you could havee a 2 bar loop playing alongside a 4 bar loop of a different track

// you can do operations at the song, track, section, or phrase level and it will filter down the heirarchy
// you could say section.length_(4) and it would trim all the phrases to be that length

// a phrase is essentially a list of events that get's sequenced by a routine
// you can apply changes to the events in different ways
// 1 you can apply per event: phrase.note[3].degree_(4) // also, this doesn't necessarily have to be the api
// 2 or you could have the routine use a pattern for the event value phrase.degree_(Prand([1,2,3,4], inf))
// 3 or you could have the routine use a pattern to select the values that will stay with each event // not sure how to express this
// basically with #2 Prand([1,2,3,4], inf) would result in a new random value each time
// with #3 Prand([1,2,3,4], inf) would use that pattern to select the values randomly for each event,
// and then when all the events are filled, they would play the same random notes each loop
// 4 or you could use an env to have the values chosen from the env phrase.amp_(Env([0, 1, 0.5, 0], [1, 2, 1].normalizeSum)

// and all this should be indexable so that you can play tracks on different nodeproxies
// like ~a = Song.track(\bassline)
// and then we can update the song on teh fly and have those node proxies update
// like Song.playSection(\chorus)



3.rrand(1)



(x.free; x = .play)


(
~x.play;
~x[0] = {
	var ramp = Env([0, 1, 1], [15, 1]).ar(2, 1);
	var sig = SinOscFB.ar(ramp.linexp(0, 1, 50, [500, 505]), ramp.linexp(0, 1, 0.1, 10));
	sig = sig * SinOsc.ar(ramp.linexp(0, 1, 1/4, 8), [0, ramp]).bi2uni;
	Out.ar(\out.kr(0), sig)
};
~x[1] = \filterIn -> {|in| CombN.ar(in, 1/4, 1/4, 3)};
)


(x.free; x = {
	var n = 10;
	var sig = WhiteNoise.ar;
	var mod = SinOsc.ar(1/4, Array.interpolation(n, 0, pi));

	// mod = LFNoise0.ar(8!n);
	// mod = LFDNoise0.ar((Env.perc.ar(0, Impulse.ar(1/4))!n) * 100);
	(BPeakEQ.ar(sig, mod.linexp(-1, 1, 150, 15000), 0.1, 6) - sig).sum;
}.play)



