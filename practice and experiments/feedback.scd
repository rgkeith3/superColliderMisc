{Splay.ar(SinOsc.ar(GrainSin.ar(4, Dust.kr(MouseY.kr(1, 50)), WhiteNoise.ar.range(0,1), WhiteNoise.ar.range(50, 5000), WhiteNoise.ar).linexp(-1, 1, 50, 5000)))}.play

{n = 20; SinOsc.ar(Array.exprand(n, 1, 8).sort * 50, Rand(0.dup(n)), Array.exprand(n, 0.1* 1/n, 1/n).sort * Lag.kr((LFDNoise1.kr(1).range(0, 1) > Array.exprand(n, 0.1, 0.9).sort).reverse, 0.01)).sum}.play

// this is good for switching on more and more partials
{(MouseY.kr > Array.exprand(10, 0.01, 0.9).sort).reverse}.scope

Array.exprand(10, 0.01, 0.9)

{SinOsc.ar(Env([2, 1, 0.5], 1, [-1, 1] * 8).kr * Scale.major.degreeToFreq((0..7).scramble[0..4], 50, 2), mul: 1/4).sum}.play


// I hereby dub this pan modulation. has a similar effect to amp modulation (it is essentially the same, just spread across channels)
{LinPan2.ar(SinOsc.ar(400), SinOsc.ar(MouseY.kr(5, 5000, 1)))}.play

{SinOsc.ar(400) * SinOsc.ar(MouseY.kr(5, 5000, 1))}.play


{SinOsc.ar(Env([1, 0, 1], LinPan2.kr(1, LFNoise1.kr(1)) * MouseX.kr(1, 500, 1).reciprocal, LFNoise2.kr(1, 16) * [-1, 1]).circle.ar + 1 * 400)}.play
{Pan2.ar(SinOscFB.ar(feedback: 1), Env([1, 0, 1], LinPan2.kr(1, LFNoise1.kr(1)) * LFNoise2.kr(1).linexp(-1, 1, 0.5, 500).reciprocal, LFNoise2.kr(1, 16) * [-1, 1]).circle.ar)}.play
(
s.options.outDevice_('DENON-AVAMP');
s.options.numOutputBusChannels_(8);
s.options.numInputBusChannels_(0);
s.options.numWireBufs_(512);
s.reboot;
)
(
~unwrap = {|sig|
	LeakDC.ar([sig[6], sig[1], Mix(sig), sig[0], sig[5], sig[2], sig[4], sig[3]]);
}
)
~unwrap = {|sig| Splay.ar(sig)}

{~unwrap.value(PanAz.ar(7, Saw.ar(50), MouseX.kr(-1, 1)))}.play

(
{
	var sig = SinOsc.ar(GrainSin.ar(7, Dust.kr(MouseY.kr(1, 50)), WhiteNoise.ar.range(0,1), WhiteNoise.ar.range(50, 5000), WhiteNoise.ar).linexp(-1, 1, 50, 5000), mul: 0.5);
	~unwrap.value(sig)
}.scope
)


({var panner, times, curve, sig;
	times = LinPan2.kr(1, LFNoise1.kr(1)) * 0.5.reciprocal;
	curve = MouseX.kr(1, 16) * [MouseY.kr(-1, 1), MouseY.kr(1, -1)];
	panner = Env([1, 0, 1], times, curve).circle.ar;
	sig = PanAz.ar(7, SinOscFB.ar(150, feedback: 1), panner);
	~unwrap.value(sig);
}.play)


{~unwrap.value(FreeVerb.ar(Saw.ar(Scale.major.degreeToFreq((0..24).scramble[0..6], 50, 1), mul: LinPanAz.kr(7, 1, SawDPW.ar(1, mul: 2), width: LFNoise2.kr(0.5).linexp(-1, 1, 0.1, 8))), LFNoise1.kr(0.5).bi2uni, LFNoise1.kr(0.5).bi2uni, LFNoise1.kr(0.5).bi2uni))}.play

({var panner, times, curve, sig, mul;
	times = LinPan2.kr(1, LFNoise1.kr(1)) * 0.5.reciprocal;
	curve = LFNoise1.kr(1).range(-16, 16);
	mul = LinPanAz.kr(7, 1, Env([1, 0, -1], times, [curve, curve * -1]).circle.ar, width: LFNoise2.kr(0.5).linexp(-1, 1, 0.1, 8));
	sig = Saw.ar(Scale.major.degreeToFreq((0..24).scramble[0..6], 50, 1), mul);
	sig = FreeVerb.ar(sig, LFNoise1.kr(0.5).bi2uni, LFNoise1.kr(0.5).bi2uni, LFNoise1.kr(0.5).bi2uni);

	~unwrap.value(sig);
}.play)

s.options.outDevice_(nil)
s.options.numOutputBusChannels_(2)
s.options.numInputBusChannels_(0)
s.reboot
{SinOsc.ar}.play


{FreeVerb.ar(Pan2.ar(SinOscFB.ar(LFDNoise3.ar(LFDNoise3.ar(LFNoise2.ar(1).linexp(-1, 1, 0.1, 50)).linexp(-1, 1, 0.1, 50)).linexp(-1,1, 50, 5000), LFNoise1.kr(1).linexp(-1, 1, 0.5, 3)), LFNoise2.kr(2).pow(1/2)), 0.2, 0.1, 1)}.play

({
	var sig = LocalIn.ar(1);
	sig = Saw.ar(sig.linexp(-1, 1, 0.001, 10000) + LFNoise1.kr(1).linexp(-1, 1, 0.001, 10000));
	sig = sig * (sig.linexp(-1, 1, 0.01, 10000) < 50);
	sig = FreeVerb.ar(sig, 0.1, 0.01, 1);
	// sig = CombC.ar(sig, 0.1, LFNoise1.kr(1).linexp(-1, 1, 0.0001, 0.1), 0.1);
	sig = (LeakDC.ar(sig.pow(1/2))).tanh;
	LocalOut.ar(sig);
	sig;
}.play)

b = Buffer.loadCollection(s, Array.rand(32, -1, 1));
({
	var trig, sig, rt;
	rt = 1000;
	trig = Impulse.ar(rt);
	sig = SinOsc.ar(Lag.ar(Demand.ar(trig, 0, Dbufrd(b, Dseries(0))), rt.reciprocal).linexp(-1, 1, 5, 5000));
	Demand.ar(CoinGate.ar(0.01, trig), 0, Dbufwr(sig, b, Dseries(0)));
	sig;
}.play)

{Demand.ar(Impulse.ar(500), 0, DNoiseRing(MouseY.kr, MouseX.kr)).linlin(0, 256, -1, 1)}.scope
Array.fill(8, {1}).convertDigits(2)

7.wrap(0, 7)
[1, 1-1]



/// FB stuff
({
	// benjolin
	// the key thing about the benjolin is it is self modulating in multiple ways
	var a, b, r, bufs, fb, index, clock, rt, weight, sig;
	rt =1;
	bufs = 8.collect{LocalBuf()};
	fb = LocalIn.ar(2);
	a = SinOsc.ar((LFNoise1.kr(rt) + (fb[0] * LFNoise1.kr(rt)) + (fb[1] * LFNoise1.kr(rt))).linexp(-1, 1, 0.01, 10000));
	b = SinOsc.ar((LFNoise1.kr(rt) + (a * LFNoise1.kr(rt)) + (fb[1] * LFNoise1.kr(rt))).linexp(-1, 1, 0.01, 10000));
	clock = b > 0;
	weight = LFNoise1.kr(rt).bi2uni.pow(4);
	r = bufs.collect {|buf, i|
		var write, valToWrite;
		// every clock, we get the value of the buffer beside us
		valToWrite = Demand.ar(clock, 0, Dbufrd(bufs[(i + 1).wrap(0, 7)]));
		valToWrite = BinaryOpUGen('==', valToWrite, 1);

		if (i == 1, {
			// if first buffer, maybe choose the a > 0 value
			valToWrite = TWChoose.ar(clock, [valToWrite, a > 0], [1-weight, weight]);
		});
		// write that to our buffer
		BinaryOpUGen('==', Demand.ar(clock, 0, Dbufwr(valToWrite, buf)), 1);
	};
	r = (r * [1, 2, 4, 8, 16, 32, 64, 128]).sum.linlin(0, 255, -1, 1);
	LocalOut.ar([b, r]);
	sig = a > b;
	sig = BPF.ar(sig, (LFNoise1.kr(rt) + r * 1).linexp(-1, 1, 20, 10000), LFNoise1.kr(rt).bi2uni);
	Limiter.ar(sig);
}.play)


({
	var sig, lpf, bpf, hpf, res, freq, spread, fb;
	fb = LocalIn.ar(3);
	sig = Saw.ar(LFNoise1.kr(1).linexp(-1, 1, 20, 20000));
	res = fb[1];
	freq = fb[0];
	spread = fb[2];
	lpf = RLPF.ar(sig, (freq + spread).linexp(-1, 1, 5, 20000), res.bi2uni);
	bpf = BPF.ar(sig, (freq).linexp(-1, 1, 5, 20000), res.bi2uni);
	hpf = RHPF.ar(sig, (freq - spread).linexp(-1, 1, 5, 20000), res.bi2uni);
	LocalOut.ar([lpf, bpf, hpf]);
	Splay.ar(Limiter.ar([lpf, bpf, hpf]));
}.play)

(SynthDef(\fb, {|lo=50, hi=10000, short=0.0001, long=0.001, rt=1, out=0, listen_bpf=1, listen_ringz=1, listen_fb=1, mix=0.5, rm=0.1, damp=0.1|
	var sig, clipped, fb, n = 20, clip = LinPanAz.kr(n, 1, SawDPW.ar(rt, mul: 2));
	sig = SawDPW.ar(LocalIn.ar(n).linexp(-1, 1, lo, hi) * LFNoise2.kr(rt / 2), mul: 2);

	// clipped = Select.ar(LFNoise0.kr(rt) > 0, [sig < (-1 * clip) + sig > clip, sig > (-1 * clip) * sig < clip]);
	clipped = sig < (-1 * clip) + sig > clip;
	sig = clipped * SinOsc.ar(sig.linexp(-1, 1, lo, hi), sig.scramble, 1);
	sig = SelectX.ar(listen_bpf, [sig, BPF.ar(sig, Array.exprand(n, 5, 10000), 0.01)]);
	sig = SelectX.ar(listen_ringz, [sig, Ringz.ar(sig, Array.exprand(n, 5, 10000), Array.exprand(n, 0.0001, 0.01))]);
	fb = sig + CombC.ar(sig, long, Array.exprand(n, short, long), Array.exprand(n, 1, 5), Array.exprand(n, 0.01, 1));
	LocalOut.ar(fb);
	sig = SplayAz.ar(7, Select.ar(listen_fb, [sig, fb]).tanh);
	sig = FreeVerb.ar(sig, mix, rm, damp);
	sig = CompanderD.ar(sig, 0.3, 0.8, 0.8, 0.3, 0.3);
	sig = ~unwrap.value(sig);
	Out.ar(out, sig);
}).load)

(Routine({
	var x;
	loop {
		x.free;
		x = Synth(\fb, [
			\lo, exprand(0.01, 50),
			\hi, exprand(5, 1000),
			\short, exprand(0.0001, 0.001),
			\long, exprand(0.001, 1),
			\rt, exprand(0.01, 10),
			\listen_fb, 2.rand,
			\listen_bpf, 2.rand,
			\listen_ringz, 2.rand,
			\mix, 1.0.rand,
			\rm, 1.0.rand,
			\damp, 1.0.rand
		].postln);
		exprand(1, 15).wait;
	}
}).play)
x.free
(
x.free;
x = Synth(\fb, [
			\lo, exprand(0.1, 50),
			\hi, exprand(5, 10000),
			\short, exprand(0.00001, 0.01),
			\long, exprand(0.01, 0.1),
			\rt, exprand(0.1, 10),
			\listen_fb, 2.rand,
			\listen_bpf, 2.rand,
			\listen_ringz, 2.rand,
			\mix, 0.5.rand,
			\rm, 0.5.rand,
			\damp, 1.0.rand
].postln);
)

s.record(numChannels: 8)

s.scope


({
	var sig = Saw.ar
}.play)

({
	var in, sig;
	in = LocalIn.ar(5);
	sig = SinOsc.ar((in * LinPanAz.kr(5, 1, 0.5)).linexp(-1, 1, 5, 10000));
	LocalOut.ar(sig);
	Splay.ar(sig);
}.play)

// SInVocode
(
b.free;
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav"); // remember to free the buffer later.

{
	var n = 20, atk = 0.01, rel = 0.1, q = 1, freqs, voc, sig, amps;
	sig = PlayBuf.ar(1, b, loop: 1);
	sig = CompanderD.ar(sig, 0.1, 10, 1, 0, 0.1);
	freqs = Array.interpolation(n).linexp(0, 1, 40, 5000);
	amps = Amplitude.ar(BPF.ar(sig, freqs, q), atk, rel);
	// voc = SinOscFB.ar(freqs, MouseY.kr, mul: amps).sum;
	voc = BPF.ar(SinOscFB.ar(250 * [1, 1.5, 2/3, 3/4], 2, 1/4).sum, freqs, q, amps).sum;
	SelectX.ar(MouseX.kr, [voc, sig]);

}.play)
s.boot

{8.collect{SinOsc.ar(Rand(1, 2.0)) > 0}.convertDigits(2)}.play

([0, 0, 0, 1, 0, 1, 0, 0] * [128, 64, 32, 16, 8, 4, 2, 1]).sum

s.scope