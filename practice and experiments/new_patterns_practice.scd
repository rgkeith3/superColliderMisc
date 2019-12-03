a = Pmatrix2D(matrix: [[1,2,3], [11,22,33]], x: Pseq([0, 1, 2], inf), y: Prand([0, 1], inf), length: 10).asStream
4 % 4

a = (a+1) % 8
a = PbeatRepeat([1,2,3,4,5,6,7,8], Prand([1,0], inf)).asStream
a.next

s.boot

Pbind(\degree, PbeatRepeat([1,2,3,4,5,6,7,8], Pwrand([1, 0], [0.2, 0.8], inf)).trace, \dur, 1/4).play
s.boot

(
SynthDef(\slice, {
	|buf, beats, clock, start, gate=1, pan=0, amp=1, out=0|
	var beatDur, sig, pointer, env;
	beatDur = clock.reciprocal * beats;
	env = EnvGen.ar(Env.adsr(releaseTime: 0.01), gate, doneAction: 2);
	pointer = Line.ar(dur: beatDur, add: start, doneAction: 2);

	sig = BufRd.ar(1, buf, pointer * BufSamples.kr(buf)) * amp;
	sig = Compander.ar(sig, sig).clip(-1, 1);
	Out.ar(out, Pan2.ar(sig, pan));
}).add
)

p.clock.tempo = 160/60
~a.play
(
~a[0] = Pbind(
	\instrument, \slice,
	\buf, d[\samples][\breaks][7],
	\beats, 8,
	\clock, p.clock.tempo,
	\start, PbeatRepeat(Array.fill(16, {|i| i * 1/16}).scramble, Pwrand([1, 0], [0.2, 0.8], inf)),
	\legato, 1,
	\dur, Pseq(f[\durFillSize].value(16, 1/2, 0.3, 16), inf),
	\rel, 0.1,
	\atk, 0.01,
	\amp, 1,
	\pan, Pwhite(-0.5, 0.5)
)
)
~a[1] = \filter -> {|in| Mix.ar([RLPF.ar(in, 250, 0.8), RHPF.ar(in, 50, 0.2)])}
~a[2] = \filter -> {|in| Compander.ar(in *5, in *5)}
~a[3] =
~a[4] = nil
~a[5] = \filterIn -> {|in| RLPF.ar(in, LFNoise1.kr(0.1, mul: 1500, add: 2000), rq: 0.5)}
~a[7] = nil
~a.set(\wet5, 0)
~a.set(\wet3, 0.5)

~a.set(\div, 1/2)

~a.stop


(
SynthDef(\saw, {|freq=440, atk=0.01, dec=0.1, sus=0.8, rel=0.1, pan=0, gate=1, out=0|
	var sig, env;
	env = EnvGen.ar(Env.adsr(atk, dec, sus, rel), gate, doneAction: 2);
	sig = SawDPW.ar(freq) * env;
	Out.ar(out, Pan2.ar(sig, pan))
}).add
)

~a.stop;
~a.play;

~b.play
~b[0] = Pbind(\instrument, \saw, \degree, Ptm(6, Scale.minor.degrees, 0.2), \dur, Pseq(f[\durFillSize].value(16, 1, 0.1, 6), inf), \octave, 2)

~b[5] = \filterIn -> {|in| DFM1.ar(in, 750, 0.5) }
~b[10] = \filterIn -> {|in| [AllpassL.ar(in[0], 0.05, LFNoise1.kr(0.01, mul: 0.025, add: 0.03), 0.5), AllpassL.ar(in[1], 0.1, LFNoise1.kr(0.07, mul: 0.025, add: 0.03), 0.55)] + in}

~b[20] = \filterIn -> {|in| FreeVerb.ar(in, 0.5, 0.1)}
~b[30] = \filterIn -> {|in| Compander.ar(~b* 5, ~a * 5).fold(-1.0, 1.0)}
~b.set(\wet10, 1)
~b.stop

Scale.minor.degrees

~c[0] = Pbind(\instrument, \saw, \degree, Ptm(6, Scale.minor.degrees, Pwrand([1, 0], [0.1, 0.9], inf)), \octave, Prand([6,5,7], inf), \dur, 1/3, \pan, Pwhite(-1.0, 1), \rel, 0.5, \atk, 0)
~c[5] = \filterIn ->  {|in| RHPF.ar(in, SinOsc.kr(0.1, mul: 1000, add: 1500), 1)}
~c.play
~revSnd = ~c * 0.5
~rev = {NHHall.ar([~revSnd.ar[0], ~revSnd.ar[1]], 10)}

~rev[10] = \filterIn -> {|in| RLPF.ar(in, 2000, 1)}

~rev.fadeTime = 5
~rev.play

~c.stop


~t[0] = {Pan2.ar(Impulse.ar(8), LFNoise1.ar(0.5))}

~t.play(fadeTime: 10)
~t.fadeTime = 5
~t[10] = \filterIn -> {|in| [CombL.ar(in[0], 0.1, LFNoise1.kr(0.1, 0.05, 0.05), LFNoise1.kr(0.2, 0.5, 0.5)), CombL.ar(in[1], 0.1, LFNoise1.kr(0.1, 0.05, 0.05), LFNoise1.kr(0.2, 0.5, 0.5))]}
~t.set(\wet10, 1)


~w[0] = {Pan2.ar(HPF.ar(Crackle.ar(SinOsc.ar(1/8, mul: 0.5, add: 1)), 10000), LFNoise0.kr(1))}
~w[1]  = \filterIn -> {|in| CombL.ar(in, 0.5, LFNoise0.kr(p.clock.tempo, 0.25, 0.25), 5)}
~w.set(\wet1, 0.5)

~w.play

(
SynthDef(\swell, {|length=8, clock=1, out=0|
	var env, sig;
	env = Line.ar(dur: clock.reciprocal * length, doneAction: 2);
	sig = WhiteNoise.ar(env);
	Out.ar(out, Pan2.ar(sig, SinOsc.ar(Line.kr(1, 25, clock.reciprocal * length))));
}).add
)



~task = Task({
	loop {
		var track = [~a, ~b, ~c, ~t, ~w, ~rev].choose;
		track.isPlaying.postln;
		if (track.isMonitoring, {track.stop;}, {track.play;});
		(instrument: \swell, length: 32, clock: p.clock.tempo).play;
		32.yield;
	};
})


~a.play

~a[1] = \filterIn -> {|in, wipeL=0, wipeR=0| var sig = [FFT(b, in[0]), FFT(c, in[1])]; sig = [PV_BinScramble(sig[0], wipeL), PV_BinScramble(sig[1], wipeR)]; [IFFT(sig[0]), IFFT(sig[1])] * 2}

~a[2] = \set -> Pbind(\wipeL, Pwhite(), \wipeR, Pwhite(), \dur, 1/4)

~a.set(\wet1, 1)

b = Buffer.alloc(s, 1024, 1)
c = Buffer.alloc(s, 1024)
