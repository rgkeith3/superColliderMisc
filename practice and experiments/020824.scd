s.reboot

s.options.numInputBusChannels_(0)
s.options.numOutputBusChannels_(2)
s.options.outDevice_("Macbook Pro Speakers")
s.reboot
s.options.numWireBufs_(1024)
s.options.memSize_(2.pow(16))
s.options.sampleRate_(44100)

s.boot

({var sig, amps, freqs, gate, q;
	sig = Gendy3.ar(freq: 60!8);
	q = MouseX.kr(0.001, 1);
	gate = MouseY.kr();

	freqs = Array.interpolation(40, 20, 18000);
	amps = freqs.collect {|freq|
		InRange.ar(Amplitude.ar(BPF.ar(sig, freq, q, q.reciprocal), releaseTime: 1), gate, gate + 0.1);
	};

	sig = BPF.ar(sig, freqs, q, amps).sum;
	Limiter.ar(sig);
}.play)


(SynthDef(\three03, {|freq=440, glide=1, gate=1, atk=0.01, dec=0.3, sus=0.5, rel=0.1, filt_freq=880, filt_env=0.5, q=0.5, pan=0, out=0, amp=0.8, dist=0, sub=0.5|
	var sig, env, subOsc;
	subOsc = SinOscFB.ar(freq/2, 1) * Env(times: [atk, dec]).ar(gate: gate) * sub;
	sig = LFSaw.ar(Lag.kr(freq, glide));
	env = Env.adsr(atk, dec, sus, rel);
	sig = RLPF.ar(sig, filt_freq * (1 + ((filt_env * EnvGen.ar(env, gate)) - filt_env)), q);
	sig = sig * EnvGen.ar(env, gate, amp, doneAction: 2);
	sig = (sig * (1 + dist)).distort;
	sig = sig + subOsc;
	sig = PanAz.ar(7, sig, pan);
	sig = [sig[6], sig[1], sig[0], Mix(sig), sig[5], sig[2], sig[4], sig[3]];
	Out.ar(out, sig);
}).load)

(SynthDef(\k, {|freq=50, fact=100, gate=1, out=0, fb=2, pan=0|
	var sig = SinOscFB.ar(freq * fact * Env.perc(0, 0.01).ar + Env([1, 0], 1, 4).ar(levelScale: freq), Env.perc(0, 0.5).ar * fb) * Env.perc(0, 1).ar(2);
	sig = Pan2.ar(sig, pan);
	Out.ar(out, sig);
}).load)

(SynthDef(\pad, {|freq=440, gate=1, out=0, pan=0, atk=0.01, dec=0.1, sus=0.5, rel=0.3, filt_freq=500, filt_motion=0.1, q=0.5, amp=0.8|
	var sig, env;
	env = Env.adsr(atk, dec, sus, rel).ar(2, gate);
	sig = RLPF.ar(LFSaw.ar(freq), LFNoise1.kr(0.5, 500 * filt_motion) + filt_freq, q);
	sig = sig * env;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).load)

ProxySpace.push
currentEnvironment.makeTempoClock
currentEnvironment.quant_(4)

~a[0] = PmonoArtic(\three03, \instrument, \three03, \dur, 1/8, \legato, Pseq(Array.fill(16, {[0.5, 1].wchoose([0.7, 0.2])}), inf), \degree, Pseq(Array.fill(16, {[0, 2, 1, 5, \].wchoose([0.5, 0.1, 0.2, 0.1, 0.1])}), inf), \octave, Pseq(Array.fill(8, {[3, 4, 5].wchoose([0.1, 0.8, 0.1])}), inf), \filt_env, Pbrown(), \q, Pbrown(0.01), \dist, Pbrown(0, 50), \amp, Pseq(Array.fill(16, {[0.8, 1].wchoose([0.9, 0.1])}), inf), \scale, Scale.minorPentatonic, \atk, Pbrown(hi: 0.3), \dec, Pbrown(0.1, 0.5), \sus, 0.5, \rel, 0.1, \glide, 0.1, \filt_freq, Pkey(\freq) * 8, \pan, Pbrown(-1))
~a[5] = \filter -> {|in| CombN.ar(in, 1, [1,3]/4, 1)}
~a[10] = \filter -> {|in| FreeVerb2.ar(in[0], in[1], 1)}
~a[20] = \filter -> {|in| Compander.ar(in, ~b.ar, 0.1, 0.5, 1)}
~a[15] = \filter -> {|in| BRF.ar((in * 10).distort, LFNoise1.kr(0.5!2).range(200, 2000), 1)}
~a[25] = \filter -> {|in| in * Env.circle([1, 0, 1, 0, 1, 0, 1, 1, 0], [1, 0, 1, 0, 1, 0, 1, 1], LFNoise1.kr(0.2).range(-4, 0)).ar(timeScale: 1/8)}
~a[100] = \filter -> {|in| in * 0.8}
~a.set(\wet10, 0.5)
~a.set(\wet5, 0.3)
~a[25] = nil
~a[20] = nil
~a.play
~pad[0] = Pbind(\instrument, \pad, \degree, [0, 3, 5, 7] + Pseq([0, 1, 3, 2, 1], inf), \atk, 1, \rel, 1, \dur, Pseq([4, 4, 2, 2, 4], inf), \amp, 0.25, \scale, Scale.chromatic, \sus, 1, \q, 0.1, \filt_freq, 5000, \filt_motion, 5, \pan, [-1, -1/3, 1/3, 1])
~pad[2] = \filter -> {|in| FreeVerb2.ar(in[0], in[1], 1, 1, 1)}
~pad[5] = \filter -> {|in|Compander.ar(in, ~b.ar, 0.1, 0.5, 1)}
~pad[10] = \filter -> {|in| in * Env.circle([1, 0, 1, 0, 1, 0, 1, 1, 0], [1, 0, 1, 0, 1, 0, 1, 1], LFNoise1.kr(0.2).range(-4, 0)).ar(timeScale: 1/8)}
~pad.set(\wet2, 1)
~pad.play
~lfo = {SinOsc.kr(1/24).range(0,1)}
~lfo.clear
~a[25] = nil
~a[20] = nil
~a[15] = nil
~a.set(\sub, 0)
~a.scope
~a.play

Pdef(\three03, PmonoArtic(\three03, \degree, Pseq(Array.fill(16, {[0, 2, 1, 5, \].wchoose([0.5, 0.1, 0.2, 0.1, 0.1])}), inf), \octave, Pseq(Array.fill(16, {[3, 4, 5].wchoose([0.1, 0.8, 0.1])}), inf)))
~a[0] = Pbindf(Pdef(\three03), \instrument, \three03, \dur, 1/8, \legato, Pseq(Array.fill(16, {[0.5, 1].wchoose([0.7, 0.2])}), inf), \filt_env, Pbrown(), \q, Pbrown(0.01), \dist, Pbrown(0, 50), \amp, Pseq(Array.fill(16, {[0.8, 1].wchoose([0.9, 0.1])}), inf), \scale, Scale.minorPentatonic, \atk, Pbrown(hi: 0.3), \dec, Pbrown(0.1, 0.5), \sus, 0.5, \rel, 0.1, \glide, 0.1, \filt_freq, Pkey(\freq) * 8, \pan, Pbrown(-1));
~a.play

Pdef(\three03)
PdefAllGui()



(~ramp = Task({
	4.wait;
	~a.play;
	~b.stop;
	~riser.play;
	~riser = {var line = Line.ar(0, 1, 16, doneAction: 2); BPF.ar(WhiteNoise.ar(line!2), line.linlin(0, 1, 50, 10000), line.linlin(0, 1, 1, 0.1))};
	12.do {|i|
		~a.set(\wet10, i/12);
		1.wait;
	};
	~pad.stop;
	4.wait;
	~riser.stop;
	~a[0] = Pbindf(Pdef(\three03), \instrument, \three03, \dur, 1/8, \legato, Pseq(Array.fill(16, {[0.5, 1].wchoose([0.7, 0.2])}), inf), \filt_env, Pbrown(), \q, Pbrown(0.01), \dist, Pbrown(2, 50), \amp, Pseq(Array.fill(16, {[0.8, 1].wchoose([0.9, 0.1])}), inf), \scale, Scale.minorPentatonic, \atk, Pbrown(hi: 0.3), \dec, Pbrown(0.1, 0.5), \sus, 0.5, \rel, 0.1, \glide, 0.1, \filt_freq, Pkey(\freq) * 8, \pan, Pbrown(-1));
	~a.set(\wet10, 0);
	~b.play;
	~pad.play;
}))

~b = Pbind(\instrument, \k, \octave, 3, \dur, Prand([1/2, Pseq([3/4, 1/4])], inf) /2, \fb, Pwhite(hi: 1), \pan, Pwhite(-1), \amp, 1)
Scale.directory
~b.play
(-8..12).scramble[0..3]

1 +  ((1 * [0, 1, 0.5, 0]) - 1)




r = 4
a = (pi * 16) / 4
b = (pi * 4) /2




s.reboot

////// FFT BUF PLAYBACK

(
var sf;
// path to a sound file here
p = Platform.resourceDir +/+ "sounds/a11wlk01.wav";
// the frame size for the analysis - experiment with other sizes (powers of 2)
f = 2048;
// the hop size
h = 0.5;
// get some info about the file
sf = SoundFile.new( p );
sf.openRead;
sf.close;
// allocate memory to store FFT data to... SimpleNumber.calcPVRecSize(frameSize, hop) will return
// the appropriate number of samples needed for the buffer
y = Buffer.alloc(s, sf.duration.calcPVRecSize(f, h));
// allocate the soundfile you want to analyze
z = Buffer.read(s, p);
)

// this does the analysis and saves it to 'y'... frees itself when done
(
SynthDef("pvrec", { arg recBuf=1, soundBufnum=2;
    var in, chain, bufnum;
    bufnum = LocalBuf.new(2048, 1);
    Line.kr(1, 1, BufDur.kr(soundBufnum), doneAction: 2);
    in = PlayBuf.ar(1, soundBufnum, BufRateScale.kr(soundBufnum), loop: 0);
    // note the window type and overlaps... this is important for resynth parameters
    chain = FFT(bufnum, in, 0.25, 1);
    chain = PV_RecordBuf(chain, recBuf, 0, 1, 0, 0.5, 1);
    // no ouput ... simply save the analysis to recBuf
}).add)

a = Synth("pvrec", [\recBuf, y, \soundBufnum, z]);
y
(
{
	var sig, chain, bufnum;
    bufnum = LocalBuf.new(2048);
	chain = PV_BufRd(bufnum, y.bufnum, MouseX.kr);
    sig = IFFT(chain, 0)!2;
	sig = FreeVerb.ar(sig, 0.1, 1, 0);
}.play
)
a = [1,2,3];
a = a.rotate

(SynthDef(\fftGrain, {|fft_buf, rate=1, start=0, size=0.1, atk=0.5, dec=0.5, out=0, pan=0, randWipe=0.5, seed=56789|
	var sig, chain;
	RandSeed.kr(1, seed);
	chain = PV_BufRd(LocalBuf(2048), fft_buf, Line.ar(0, 1, (rate * 0.5).reciprocal, doneAction: 2) + start);
	chain = PV_RandComb(chain, randWipe);
	sig = IFFT(chain);
	sig = sig * Env(times: [atk, dec] * size).ar(2);
	sig = Pan2.ar(sig, pan);
	Out.ar(out, sig);
}).load)

{BufDur.ir(z).poll}.play
x = Pbindef(\fftGrains, \instrument, \fftGrain, \fft_buf, y, \dur, Pwhite(0.01, 0.1), \start, Pbrown(), \size, Pwhite(), \rate, Pwhite(), \pan, Pwhite(-1), \randWipe, 0.9, \seed, Pwhite(0, 56789), \atk, 0.5, \dec, 0.5)
x.play



/// another idea, like novum vst
// decompose any sample into 6 layers using flucoma (whichever thing just kind of separates a sound into n sounds of spectrally similar stuff
// then play through those buffers with a warp1 or bufgrain per each layer


s.boot
/// single synth glitch drums
{SinOscFB.ar(LFNoise1.kr(1!2, 0.5, 41), 0.5) * SinOscFB.ar(10, MouseY.kr(0, 3), MouseY.kr).bi2uni}.play
s.scope
(SynthDef(\bass, {|freq=40, gate=1, out=0, mod=1, modrt=4, modfb=1, detune=0.5, fb=0.5|
	var sig = SinOscFB.ar(LFNoise1.kr(1!2, detune, Env.perc(0, 0.01).ar(0, gate, levelScale: 500, levelBias: freq)), fb) * SinOscFB.ar(modrt, modfb, mod).bi2uni;
	sig = sig * Env.adsr(0).ar(2, gate);
	Out.ar(out, sig);
}).load)

(SynthDef(\click, {|crackle=1.5, gate=1, rel=0.01, pan=0, out=0|
	var sig = Crackle.ar(crackle) * Env.asr(releaseTime: rel).ar(2, gate);
	sig = HPF.ar(sig, 500);
	Out.ar(out, Pan2.ar(sig, pan));
}).load)

Pbindef(\k, \instrument, \bass, \octave, 2, \dur, Pseq([3, 3, 4, 2, 4], inf) /4, \sustain, Pwrand([1/4, 1/2], [0.8, 0.2], inf), \mod, Pwrand([0, 1], [0.8, 0.2], inf), \detune, Pwrand([0.5, 2], [0.8, 0.2], inf), \modrt, Prand([4, 8, 6, 2], inf), \modfb, Pwhite(hi: 1.5), \fb, Pbrown(hi: 1.5)).quant_(4)
Pbindef(\c, \instrument, \click, \dur, 1/8, \crackle, Pwhite(0.75, 1.5), \legato, Pwrand([0.01, 1], [0.8, 0.2], inf)).quant_(4)
Pbindef(\c).play
Pbindef(\k).play


(
SynthDef(\a, {
	Out.ar(0, SinOsc.ar(50));
}).load;
SynthDef(\b, {
	Out.ar(0, SinOsc.ar(500));
}).load
)


g = Group.new

a = Synth(\a, [], a, 'addReplace').nodeID
().play.nodeID
Server.killAll
s.queryAllNodes
Node.addActions





s.reboot

{LFDNoise3.ar(MouseY.kr(0.0001, 8000))}.play
(
x.free;
x = {
	var env, sig;
	env = Env([1, 0], 5, -4);
	sig = Ringz.ar(Impulse.ar(env.ar(2, levelScale: 50)), Array.exprand(40, 20, 10000), Array.linrand(40, 0.1, 2), 0.5); Splay.ar(sig)}.play;
)

{var sig = Resonz.ar(WhiteNoise.ar, 250 * [1, 5/4, 3/2, 19/10].collect({|i| i * [1,2,3,4,5,6,7,8,9,10]}).flatten.scramble, 0.001, 5); Splay.ar(sig)}.play

{CompanderD.ar(Splay.ar(Resonz.ar(PinkNoise.ar, 250 * [1, 5/4, 3/2, 19/10].collect({|i| i * [1,2,3,4,5,6,7,8,9,10]}).flatten.scramble, Env.perc(releaseTime: 5, curve: -50).ar(2))), slopeBelow: 0.5, slopeAbove: 1)}.play

{var sig = HPF.ar(Gendy3.ar(freq: 50), 500); FreeVerb.ar(sig > Amplitude.ar(sig, 1, 1, add: 0.2), 0.5, 0.1, 1)}.play

{Gendy3.ar(freq:50) + SinOsc.ar(50) * ToggleFF.ar(CoinGate.ar(0.8!2, Impulse.ar(8))) }.play


s.scope
[261.63, 329.63 / 261.63, 392.00 /261.63, 493.88/ 261.63]
[1, 5/4, 3/2, 19/10]

19/10

[261.63, 329.63, 392.00, 493.88].collect({|i| i * [1,2,3,4,5,6,7,8,9,10]}).flatten.sort

{var sig = GrainBuf.ar(2, Dust.ar(5), 0.01, b, WhiteNoise.ar.range(0.5, 2), WhiteNoise.ar.range(0,1), pan: WhiteNoise.ar); AllpassC.ar(sig, delaytime: LFDNoise3.ar(LFNoise2.ar(1!2).range(0.1, 5)).range(0.00001, 0.2), decaytime: 5);}.play




(Event.partialEvents.keys.do {|n|
	n.postln;
	Event.partialEvents[n].keys.postln;
	\.postln;
}
)

Ndef(\a).play

Ndef(\a, {|freq=440, pan=0| Pan2.ar(SinOsc.ar(freq.poll), pan)})
Ndef(\a).mold(2)
Ndef(\a)[10] = \set -> Pbind(\pan, Pwhite(-1), \dur, 1/4)
Ndef(\a)[11] = \set -> Pbind(\degree, Prand((0..8), inf), \dur, 1, \legato, 1)



s.reboot
(
{
	var a, b;
	a = SinOsc.ar(mul: LFNoise1.kr(10).bi2uni);
	b = PinkNoise.ar(LFNoise1.kr(10).bi2uni);
	((Amplitude.ar(a) > Amplitude.ar(b)) * a) + ((Amplitude.ar(b) > Amplitude.ar(a)) * b)
}.play
)
s.scope

{Klang.ar(`[Array.exprand(40, 50, 8000).sort, Array.exprand(40, 0.001, 0.05).sort.reverse, Array.rand(40, 0, 2pi)])!2}.play

{SinOsc.ar(750) * SinOsc.ar(MouseY.kr(50, 5000))}.play

t = Tuning.et(31)
h = Scale([0, 5, 10, 14, 18, 22, 25, 28, 31], 31, t, "Harmonic [8]")
h.size
Pbindef(\test,\scale, h, \degree, \mtranspose, 1, \dur, 1/4, \octave, 5, \stepsPerOctave, 31).play

s.reboot
(
{
	var b, recHead, sig, in, dur, rate;
	b = LocalBuf(SampleRate.ir);
	recHead = Phasor.ar(end: SampleRate.ir);
	in = Mix([In.ar(0), LocalIn.ar()]);
	// in = SelectX.ar(MouseX.kr, [In.ar(0), LocalIn.ar()]);
	BufWr.ar(in, b, recHead);
	dur = LFNoise1.kr(1).range(0.01, 0.1);
	rate = LFNoise1.kr(0.5, 0.1).linexp(-1, 1, 0.5, 2);
	// rate = Select.ar(WhiteNoise.ar.range(0, 5), K2A.ar([0.5, 1, 3/2, 4/3, 2]));
	sig = GrainBuf.ar(2, Impulse.ar(dur.reciprocal), dur * 2, b, rate, recHead / SampleRate.ir - dur, pan: WhiteNoise.ar);
	// sig = AllpassC.ar(sig, 50.reciprocal, 250.reciprocal, 1);
	sig = CompanderD.ar(sig, 0.5, slopeBelow: 0.8, slopeAbove: 0.8);
	sig = Limiter.ar(sig);
	sig = LeakDC.ar(sig);
	LocalOut.ar(sig.sum);
	Out.ar(0, sig);
}.play;
)

s.scope
s.reboot

({
	var sig = Saw.ar([50, 150, 250, 500]).sum;
	40.do {
		sig = BAllPass.ar(sig, MouseY.kr(50, 10000, 1), 1);
	};
	sig;
}.play)
FormantTable.get('altoU')





(
SynthDef(\abass, {|freq=50, modRate=4, gate=1, panRate=2, out=0, atk=0.1, rel=0.1, res=0.5, dist=10|
	var mod, env, sig = Gendy3.ar(freq: freq!2);
	env = Env.asr(atk, releaseTime: rel).ar(2, gate);
	mod = LFTri.kr(modRate);
	sig = RLPFD.ar(sig, mod.range(freq, freq * 8) * (env + 1) , res, dist);
	sig = sig + SinOscFB.ar(freq / 2, 0.5) * env;
	sig = LPF.ar(sig, freq)!2 + Pan2.ar(HPF.ar(sig, freq, dist).distort, LFNoise1.kr(panRate));
	Out.ar(out, sig);
}).load;

SynthDef(\bbass, {|freq=50, mod=10, gate=1, out=0, atk=0.1, rel=0.1, pan=0, dist=1, modRate=4, envModAmt=1|
	var env, sig, envMod;
	env = Env.asr(atk, releaseTime: rel).ar(2, gate);
	envMod = LFTri.kr(modRate, mul: envModAmt, add: 1);
	sig = PMOsc.ar(freq, freq * mod * env, 1) * env * envMod;
	sig = LPF.ar(sig, freq)!2 + Pan2.ar(HPF.ar(sig, freq, dist).distort, pan);
	Out.ar(out, sig);
}).load;
)

({
	// multiband compression
	var sig, lof, hif, lo, mid, hi, comp;
	lof = 250;
	hif = 2000;
	sig = Gendy3.ar(freq: 50) + Crackle.ar(LFNoise1.kr(1).range(1, 2)) + Saw.ar(440 * [1, 1.5, 4/3, 2], 0.1).sum;
	lo = BLowPass.ar(sig, lof);
	mid = BHiPass4.ar(BLowPass4.ar(sig, hif, 0.5), lof);
	hi = BHiPass.ar(sig, hif);
	comp = CompanderD.ar([lo, mid, hi], 0.5, slopeBelow: 0.1, slopeAbove: 0.1).sum;
	sig = Select.ar(MouseY.kr > 0.5, [sig, comp]);
	sig;
}.play
)

s.reboot

(
{
	var sig, comp, bands;
	bands = 10;
	sig = Gendy3.ar(freq: 50) + Crackle.ar(LFNoise1.kr(1).range(1, 2)) + Saw.ar(440 * [1, 1.5, 4/3, 2], 0.1).sum;

	bands = bands.collect {|i|
		switch(i,
		{0}, {BLowPass.ar(sig, i.linexp(0, bands - 1, 40, 11000))},
		{bands - 1}, {BHiPass.ar(sig, i.linexp(0, bands -1, 40, 11000))},
			{BHiPass4.ar(BLowPass4.ar(sig, (i + 1).linexp(0, bands - 1, 40, 11000), 0.5), i.linexp(0, bands - 1, 40, 11000))});
	};
	comp = CompanderD.ar(bands, 0.5, slopeBelow: MouseX.kr(0, 2), slopeAbove: MouseY.kr(0, 2)).sum;
	comp;
}.play)

0.linexp(0, 9, 40, 11000)

{Decimator.ar(SinOsc.ar(60), LFTri.kr(1.1).range(44100, 44100/64), LFTri.kr(1).range(4, 12))}.scope


PmonoArtic(\bbass, \dur, Pseq([2,2, 2, 1/2, 1/2,1], inf), \octave, 2, \modRate, Prand([4, 3, 6, 8, 2, 1], inf), \degree, Pseq([0, 0, 1, 2, 6, 0], inf), \legato, Prand([1, 0.5], inf), \mod, Prand([10, 50, 100], inf)).play

s.boot

({
	SinOsc.ar(Demand.ar(CoinGate.ar(MouseY.kr, Impulse.ar(Env([10000, 0.5.linlin(0, 1, 10000, 8), 8], 8, [1, -1] * 8).ar!2)), 0, Dseq([60, 62, 64, 65, 66, 68, 75, 43].scramble.midicps, inf)))
}.play)

({
	ToggleFF.ar(CoinGate.ar(MouseY.kr, Impulse.ar(16!2))) * Gendy3.ar(freq: 60!2)
}.play)

Env([10000, 0.5.linlin(0, 1, 10000, 8), 8], 16, [1, -1] * 8).plot
(
{
	var sig = SinOscFB.ar(LFNoise0.kr(1).range(40, 80), LFNoise1.kr(4!2).bi2uni);
	sig = Decimator.ar(sig, XLine.ar(1000, 1, 4) * Demand.ar(Impulse.ar(8!2), 0, Drand([60, 62, 64, 65, 66, 68].midicps, inf)));
	sig;
}.play
)

s.scope



s.boot
{SinOscFB.ar([50, 51], 2).sum}.play
{var sig = SinOscFB.ar(50, MouseX.kr(0, 4)); sig = FreeVerb.ar((sig.abs > MouseY.kr * PinkNoise.ar), 0.5) + sig; sig.distort; LPF.ar(sig, LFNoise2.kr(1).range(50, 22000))}.play

({
	var rate, degrees, sig, num, prob;
	num = 1;
	// rate = MouseY.kr(0.25, 10000, 1);
	rate = 1;
	// prob = MouseX.kr;
	prob = 1;
	degrees = Demand.ar(CoinGate.ar(prob, Impulse.ar(rate)!num), 0, Dseq(Scale.major.degreeToFreq((0..50), 50, 0), inf)!num);
	sig = Splay.ar(SinOsc.ar(Lag.ar(degrees, rate.reciprocal / 2), mul: 1/num));
	sig;
}.play)

({var sig, resig, freq, amp, n;
	n = 50;
	sig = Gate.kr(FluidSineFeature.kr(PlayBuf.ar(1, ~drums, loop: 1), n), MouseY.kr(-1, 1));
	freq = sig[0..n];
	amp = sig[n..(n*2)];
	Splay.ar(SinOscFB.ar(Lag.kr(freq, MouseX.kr(0, 5)), 0, mul: Lag.kr(amp, MouseX.kr(0, 5))).scramble)
}.play)

({var sig, resig, freq, amp, n, trig;
	n = 50;
	sig = Gate.kr(FluidSineFeature.kr(PlayBuf.ar(1, ~drums, loop: 1), n), MouseY.kr(-1, 1));
	freq = sig[0..n];
	amp = sig[n..(n*2)];
	trig = Impulse.ar(LFNoise1.kr(0.5).linexp(-1, 1, 1, 1000));
	Splay.ar(Ringz.ar(trig, Lag.kr(freq, MouseX.kr(0, 5)), Lag.kr(amp * 64, MouseX.kr(0, 5)), n.reciprocal).scramble);
}.play)
1.0.rand
s.boot
~fft_size = 2048;
(
d = Buffer.loadCollection(s, FloatArray.fill(~fft_size/2, {1.0.rand}));
f = Buffer.loadCollection(s, FloatArray.fill(~fft_size/2, {0.99.rand}));
)
~vox = Buffer.readChannel(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav", channels: 0);
~vox.play
(
{
	var sig, chain, pointer, buf, ceps;
	buf = ~vox;
	pointer = Select.kr(LFNoise0.kr(1).range(0,1) > 0.1, [LFNoise1.kr(BufDur.kr(buf).reciprocal * 8).range(0,1), Sweep.kr(rate: BufDur.kr(buf).reciprocal).wrap(0, 1)]);
	sig = Warp1.ar(1, buf, pointer, windowSize: LFNoise1.kr(1!2).linexp(-1, 1, 0.001, 1), mul: 0.5);
	chain = FFT(LocalBuf(~fft_size!2), sig);
	chain = PV_BinDelay(chain, 1, d,f);
	IFFT(chain);
}.play)


// this is sick
// had to re-learn what's happening here
// playing a buffer with a roaming play head
// getting sinfeatures-freq and -amp for the dry signal
// playing the freq/amps through sinfbs
// roaming through the stack of sinfbs freezing all above
// then roaming through the dry or wet signal
({var sig, n, freeze, flag, alag, pointer, dry, buf;
	buf = ~vox;
	n = 50;
	pointer = Select.kr(LFNoise0.kr(1).range(0,1) > 0.1, [LFNoise1.kr(BufDur.kr(buf).reciprocal * 8).range(0,1), Sweep.kr(rate: BufDur.kr(buf).reciprocal).wrap(0, 1)]);
	dry = Warp1.ar(1, buf, pointer, windowSize: LFNoise1.kr(1).linexp(-1, 1, 0.001, 1));
	// sig = FluidSineFeature.kr(PlayBuf.ar(1, ~drums, loop: 1), n, order: 0);
	sig = FluidSineFeature.kr(dry, n);
	// freeze = MouseY.kr(1, n+1, 1) - 1;
	freeze = LFNoise2.kr(1).linexp(-1, 1, 1, n +1) - 1;
	// freeze = 1;
	// flag = MouseX.kr(0.001, 5, 1);
	// alag = MouseY.kr(0.001, 5, 1);
	flag = LFNoise1.kr(1).linexp(-1, 1, 0.01, 5);
	alag = LFNoise1.kr(1).linexp(-1, 1, 0.01, 5);
	// flag = 0;
	// alag = 0;
	sig = n.collect {|i|
		var freq = sig[i] / 4, amp = sig[i + n];
		Pan2.ar(SinOscFB.ar(Lag.kr(Gate.kr(freq, freeze < i), flag), LFNoise1.kr(1).linexp(-1, 1, 0.001, 2), mul: Lag.kr(Gate.kr(amp, freeze < i), alag)), LFNoise1.kr(0.5));
	};
	sig = SelectX.ar(LFNoise1.kr(1), [sig.sum, dry]);
	sig = FreeVerb2.ar(sig[0], sig[1], LFNoise1.kr(0.5).range(0,1), LFNoise1.kr(0.5).range(0,1), LFNoise1.kr(0.5).range(0,1));
	sig = CompanderD.ar(sig, slopeBelow: 0.1, slopeAbove: 0.1, clampTime: 0.3, relaxTime: 0.3);
	Limiter.ar(sig);
}.play)

// sineFeatures run on reverb signal
({var sig, n, freeze, flag, alag, pointer, dry, buf;
	buf = ~vox;
	n = 50;
	pointer = Select.kr(LFNoise0.kr(1).range(0,1) > 0.3, [LFNoise1.kr(BufDur.kr(buf).reciprocal * 8).range(0,1), Sweep.kr(rate: BufDur.kr(buf).reciprocal).wrap(0, 1)]);
	dry = Warp1.ar(1, buf, pointer, windowSize: LFNoise1.kr(1).linexp(-1, 1, 0.001, 2));
	// sig = FluidSineFeature.kr(PlayBuf.ar(1, ~drums, loop: 1), n, order: 0);
	dry = FreeVerb.ar(dry, LFNoise1.kr(0.5).range(0,1), LFNoise1.kr(0.5).range(0,1), LFNoise1.kr(0.5).range(0,1));
	sig = FluidSineFeature.kr(dry, n);
	// freeze = MouseY.kr(1, n+1, 1) - 1;
	freeze = LFNoise2.kr(1).linexp(-1, 1, 1, n +1) - 1;
	// freeze = 1;
	flag = MouseY.kr(0.001, 5, 1);
	alag = MouseY.kr(0.001, 5, 1);
	// flag = LFNoise1.kr(1).linexp(-1, 1, 0.0001, 1);
	// alag = LFNoise1.kr(1).linexp(-1, 1, 0.0001, 1);
	// flag = 0;
	// alag = 0;
	sig = n.collect {|i|
		var freq = sig[i] / 4, amp = sig[i + n];
		Pan2.ar(SinOscFB.ar(Lag.kr(Gate.kr(freq, freeze < i), flag), LFNoise1.kr(1).linexp(-1, 1, 0.001, 2), mul: Lag.kr(Gate.kr(amp, freeze < i), alag)), LFNoise1.kr(0.5));
	};
	sig = SelectX.ar(MouseX.kr, [sig.sum, dry]);
	sig = CompanderD.ar(sig, slopeBelow: 0.1, slopeAbove: 0.1, clampTime: 0.3, relaxTime: 0.3);
	Limiter.ar(sig);
}.play)
s.boot

({
	var chain, stream, windowStarts, demand, fft_size = 512, sig = PlayBuf.ar(1, ~vox, loop: 1);

	chain = FFT(LocalBuf(fft_size), sig);
	stream = UnpackFFT(chain, fft_size);
	windowStarts = chain > -1;
	stream.clump(2).collect({|bin, index|
		var magPhase, freq;
		freq = index.linlin(0, fft_size / 2, 0, 22050);
		magPhase = Lag.kr(Gate.kr(Demand.kr(windowStarts, 0, bin), LFNoise1.kr(1)), MouseX.kr);
		DelayN.ar(SinOscFB.ar(freq, LFNoise1.kr(1).range(0, 1.5), magPhase[0] / 128), 0.5, Rand(hi: 0.5) * MouseY.kr)
	}).sum
}.play)
s.boot
({
	var chain, chainL, chainR, stream, windowStarts, demand, fft_size = 512, sig = PlayBuf.ar(1, ~vox, loop: 1);

	chain = FFT(LocalBuf(fft_size), sig, 0.5, 1);
	stream = UnpackFFT(chain, fft_size);
	windowStarts = chain > -1;
	stream = stream.clump(2).collect({|bin, index|
		var magPhase, mag;
		magPhase = Demand.kr(windowStarts, 0, bin);
		mag = DelayN.kr(magPhase[0], 0.5, Rand(hi: 0.5) * MouseY.kr);
		[mag, magPhase[1]];
	}).flatten;
	chain = PackFFT(LocalBuf(fft_size), fft_size, stream);
	IFFT(chain)
}.play)

({
	var chain, delBuf, fbBuf, fft_size = 512, sig = PlayBuf.ar(1, ~vox, loop: 1);
	delBuf = LocalBuf(fft_size / 2).set(Array.fill(fft_size/2, {0.5.rand}));
	fbBuf = LocalBuf(fft_size / 2).set(Array.fill(fft_size/2, {0.5.rand}));
	chain = FFT(LocalBuf(fft_size), sig, 0.5, 1);
	chain = PV_BinDelay(chain, 0.5, delBuf, fbBuf);
	IFFT(chain)
}.play)

s.scope

({
	FluidAudioTransport.ar(SinOscFB.ar(500 * [1, 2/3, 1/2, 3/2], MouseX.kr).sum, PlayBuf.ar(1, ~drums, loop: 1), MouseY.kr)
}.play)


Scale.new((0..30), 31, Tuning.et31).degreeToFreq(32, 50, 0)

s.scope