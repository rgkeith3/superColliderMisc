(x.free; x = {
	var fb, in, freq, symp;
	freq = Lag.kr(LFNoise0.kr(0.1).linexp(-1, 1, 50, 5000), 1);
	// in = PinkNoise.ar * Env.perc(1, 1).ar;
	in = PinkNoise.ar * LFNoise1.ar(10).bi2uni;
	fb = LocalIn.ar(2);
	fb = LeakDC.ar(HPF.ar(LPF.ar(fb, 5000), 100));
	fb = fb + in;
	fb = Splay.ar(fb, 0.1);
	fb = DelayC.ar(fb, delaytime: (freq * LFNoise2.ar(1!2).midiratio).reciprocal);
	LocalOut.ar(fb);
	symp = CombC.ar(fb, delaytime: (150 * [0.5, 1, 1.5, 3/4, 2/3, 2]).reciprocal, decaytime: 5, mul: 0.2);
	Limiter.ar(Resonz.ar(symp.sum + fb.sum, Array.exprand(15, 50, 5000), 0.05).sum!2);
}.play)
(x.free; x = {
	var env = Env.asr(0.1).ar(gate: \gate.kr(1)), air = BrownNoise.ar * env,
	reso = Resonz.ar(air, 250 * Array.rand(15, 0.25, 4), 0.001, 5).sum;
	DetectSilence.ar(reso, doneAction: 2);
	reso;
}.play)


(x.free; x = {
	var air = PanAz.ar(5,BrownNoise.ar, LFNoise2.kr(1), width: 2);
	air = air.collect({|in, idx|
		Resonz.ar(in, Scale.majorPentatonic.degreeToFreq(idx, 250, 1) * Array.fill(15, {|i| LFNoise1.kr(0.1, i+1/8, add: i + 1) }), 0.001, 5).sum;
	});
	Splay.ar(air);
}.play)

(x.free; x = {
	var in, fb, out, del1 = 350, trig = Impulse.ar(2);
	in = WhiteNoise.ar * Env.perc(0, 0.01).ar(gate: trig);
	fb = LocalIn.ar(2);
	out = fb;
	fb = (fb * [K2A.ar([0.5, 0.5]), K2A.ar([0.5, 0.5])]).sum;
	fb = LPF.ar(fb, 10000);
	fb = HPF.ar(fb, 20);
	fb = DelayC.ar(fb, delaytime: (del1 * [0.99, 1.01]).reciprocal);
	10.do({fb = BAllPass.ar(fb, LFNoise1.kr(1, 10, del1), 10);});
	fb = fb + in;
	LocalOut.ar(fb);
	Limiter.ar(out);
}.play)
0.5.linlin(0, 1, 0, 150);

(x = {|atk=0.1, rel=0.1, gate=1, freq=250|
	var air = BrownNoise.ar * Env.asr(atk, releaseTime: rel).ar(gate:gate);

	air = Resonz.ar(air, freq * Array.rand(15, 0.5, 2), 0.001, 10).sum;
	air + CombC.ar(WhiteNoise.ar * Amplitude.ar(air), delaytime: Scale.majorPentatonic.degreeToFreq((0..4), 250, 0).reciprocal, decaytime: 2, mul: 0.01).sum;
}.play)

(x.free;x = {
	var trig = GrainIn.ar(15, Dust.ar(SinOscFB.ar(10, 1).range(0.1, 1000)), 0.0001, K2A.ar(1), WhiteNoise.ar);
	Splay.ar(Ringz.ar(trig, Array.fill(25, {LFNoise2.kr(0.1).linexp(-1, 1, 50, 15000)}), Array.fill(25, {LFNoise2.kr(0.1).linexp(-1, 1, 0.001, 1)}), 0.1));
}.play)

(~b[0] ={
	var sig = Ringz.ar(GaussTrig.ar(8, SinOsc.ar(1).range(0, 1)),Array.fill(15, {LFNoise2.kr(0.01).linexp(-1, 1, 50, 15000)}), Array.fill(15, {LFNoise2.kr(0.01).linexp(-1, 1, 0.01, 1)}), 0.1);

	Splay.ar(sig);
})
~b.play;
~b[1] = \filterIn -> {|in| Splay.ar(Resonz.ar(in, Array.exprand(15, 50, 1500), 0.01, 100))}


~d = Task({
	loop {
		[4, 2, 1, 1].do {|i|
			~b[1] = \filterIn -> {|in| Splay.ar(Resonz.ar(in, Array.exprand(15, 50, 1500), 0.01, 100))};
			i.wait;
		};
	};
})

~b[2] = \filterIn -> {|in| FreeVerb2.ar(in[0], in[1], 1, 1, 1)}
~b[4] = \filter -> {|in| (in * 5).distort}
~b[6] = \filter -> {|in| in * Env([1, 0, 1, 0, 1, 1, 0], [1, 0, 1, 0, 1, 1], -4).circle.ar(timeScale: 1/12)}
~b.play
~b.set(\wet2, 0.5)
~b.set(\wet1, 0.5)

~b[6] = nil


(~c[0] = {
	var sym, sig = DWGBowed.ar(\freq.kr(50, \lag.kr(0.1)) * Gendy1.kr(1, 1, 1, 1, 0.1, 4, mul: 0.03, add: 1), LFNoise1.kr(1).bi2uni, LFNoise1.kr(1).bi2uni);
	sig = DWGSoundBoard.ar(sig);
	// sig = Resonz.ar(sig, Array.exprand(15, 50, 1500), 0.01, 10).sum + sig;
	sym = CombC.ar(PanAz.ar(4, sig, LFNoise1.kr(1), width: LFNoise1.kr(1, add: 1)), delaytime: (Array.series(4, 1).scramble * Array.rand(4, 0.95, 1.05) * 500).reciprocal, decaytime: 1) + sig;
	Limiter.ar(Splay.ar(sym));
})

~c[0] = {SinOscFB.ar(\freq.kr(50, \lag.kr(0.1)), LFNoise0.kr(16).range(1, 3))!2}
~c.play

(~c[1] = \filterIn -> {|in|
	Splay.ar(
		Resonz.ar(
			BrownNoise.ar * Env.perc(0, 0.01).ar(gate: Dust.ar(500)) * Amplitude.ar(in),
			Array.fill(15, {LFNoise1.kr(0.01).linexp(-1, 1, 50, 5000)}),
			0.01,
			10
		)
	)
})
~c.set(\wet1, 0.8)
~c.mold

~c[3] = \set -> Pbind(\freq, Pfunc({Scale.minorPentatonic.degreeToFreq(12.rand, 50, 0)}), \lag, 1, \dur, Pwhite(1, 3))
~c[2] = \filter -> {|in| FreeVerb.ar(in, 1, 1, 1)}
~c.set(\wet2, 0.5)
~c.play
// pluck
// bow
// bonk
// res body w/ spread
~a.clear



// tbh maybe a func that generates a an array of nested arrays that take in keys and vals or generator funcs, then a way we can refer to them in patterns
// like ClipDef(\a, keys, value funcs)
// Pbind(\pan, Pwhite(), ClipDef(\a)[\keys], ClipDef(\a)[\values]
// eh, idk maybe good. but i need to be able to mutate the list together

b = #[dur, degree]
c = Pseq([[1, 1], [1/2, 2], [1/4, 4]], inf)
a = Pbind(\pan, Pwhite(-1), b, c)
a.play
a = Pbind(\dur, Pseq(Array.fill(25, {[1/4, 1/2, 1, 3/2, 3/4].choose}).normalizeSum * 8, inf), \degree, Pseq(Array.fill(25, {if (0.5.coin, {(-6..6).choose}, {\})}), inf), \scale, Scale.minor)

a.play

	Array.fill(15, {if (0.5.coin, {(-6..6).choose}, {\})})

Array.rand(15, 1/4, 1).normalizeSum *4

	0.5.coin
	(-6..6).choose


m.midiEvents.dopostln
m.generatePatternSeqs;
m.format
12.rand