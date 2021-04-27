
(
SynthDef(\808, {
	|freq=250, amp=1, atk=0, dec=0.05, sus=0.8, rel=0.5, panX=0, out=0, gate=1, drive=0, pAmt=1, pDec=0.1|

	var env, sig, pEnv;
	pEnv = Line.ar(freq + (freq * pAmt), freq, pDec);
	env = EnvGen.ar(Env.adsr(atk, dec, sus, rel), gate, doneAction: 2);

	sig = SinOsc.ar(pEnv) * env * amp;
	sig = (sig * (drive + 1)).fold(-1.0, 1.0);

	sig = Pan2.ar(sig, panX);

	Out.ar(out, sig)
}).add
)

(
Pbindef(\eights,
	\instrument, \808,
	\octave, 2,
	\degree, Pwrand([1, 5, 7], [0.8, 0.1, 0.1], inf),
	\drive, Pwhite(0.5, 3),
	\legato, 0.2,
	\pAmt, 10,
	\pDec, 0.01,
	\dec, 0.1,
	\atk, 0.0,
	\sus, 0.5,
	\rel, 0.5,
	\amp, 1,
	\dur, Pseq([1, 1, 2/3, 1/3, 3/4, 1/4], inf)
).play
)

(
{RLPF.ar(SawDPW.ar(50), MouseY.kr(0, 500), MouseX.kr())!2}.play
)
s.scope
StageLimiter.activate
TempoClock.default.tempo_(140/60)

e[\waveTables][\noisey].size
(
{
	var hiFreq = 100;
	var loFreq=50;
	var sig = VOsc.ar(MouseX.kr(100, 147), 50);

	Splay.ar([RLPF.ar(sig, loFreq, 0.1), RHPF.ar(sig, hiFreq, 0.2)], 0.1).fold(-1.0, 1.0);
}.play
)


(
SynthDef(\waveSpreadBass, {
	|freq=440, bufPos=(-1), filtFreq=500, filtSpread = 2, q=0.5, panSpread=0.5, atk=0.01, dec=0.1, sus=0.8, rel=0.5, amp=1, out=0, gate=1, rotate=0.5|
	var env, sig, loFreq, hiFreq;
	loFreq = freq / filtSpread;
	hiFreq = freq * filtSpread;

	env = EnvGen.ar(Env.adsr(atk, dec, sus, rel), gate, amp, doneAction: 2);

	sig = VOsc.ar(bufPos, freq) * env;

	sig = Splay.ar([RLPF.ar(sig, loFreq, q), RHPF.ar(sig, hiFreq, q)], panSpread, center: rotate);
	Out.ar(out, sig);
}).add
)

p = ProxySpace.push(s)
e[\utils][\crudeDensFill].value()
~a = Pbind(\instrument, \waveSpreadBass, \bufPos, ~lfo1, \dur, Pseq(e[\utils][\crudeDensFill].value(8, 1/2, 0.1), inf), \octave, 2, \amp, 1, \filtSpread, 2, \filtFreq, ~lfo2, \q, 0.1, \panSpread, 0, \degree, Prand([1, 5, \], inf), \scale, Scale.minor.degrees, \rel, 0.5)

~kick = Pbindef(\kicks, \instrument, \sterperconeShot, \buf, e[\samples][\Drums][\Kicks][8], \dur, Pseq(e[\utils][\crudeDensFill].value(8, 1/2, 0.3), inf))
Pbindef(\kicks, \rel, 1)

Pbindef(\kicks, \buf, e[\samples][\Drums][\Kicks].choose, \rel, 1)
~snare = Pbindef(\snare, \instrument, \sterperconeShot, \buf, e[\samples][\Drums][\Snares][4], \dur, Pseq(e[\utils][\crudeDensFill].value(16, 1/2, 0.2), inf))
Pbindef(\snare, \amp, 1)

~snare.play
~hats = Pbindef(\hats, \instrument, \sterperconeShot, \buf, e[\samples][\Drums]['Closed Hihat'][7], \dur, Pseq(e[\utils][\crudeDensFill].value(4, 1/4, 0.4), inf))
Pbindef(\hats, \amp, Pwhite(0.5))
~hats.play
~kick.play
StageLimiter.activate

e[\samples][\Drums].keys

p.quant = 4

~lfo1 = {e[\lfos][\sh1].value(TempoClock.default.tempo, 1/16, 24, 123)}
~lfo2 = {e[\lfos][\sin].value(TempoClock.default.tempo, 1, 250, 500)}

~revSend = ~snare * 0.1
~reverb = {NHHall.ar([~revSend.ar[0], ~revSend.ar[1]], ~revTail)}
~revTail.fadeTime_(10)
~revTail = 1
~reverb.play(fadeTime: 10)
e[\waveTables][\noisey].first.bufnum
~bass.clear

~bass.play
~bass = Pbindef(\bas, \instrument, \waveSpreadBass, \octave, 2, \dur, Pseq(e[\utils][\crudeDensFill].value(16, 1, 0.2), inf), \bufPos, 405, \amp, 1)
Pbindef(\bas, \filtSpread, 2)
Pbindef(\bas, \degree, Pseq([1,1,1, 3, 1, 1, 0, 5, 6], inf))
Pbindef(\bas,\instrument, \steradsrrlpfgendy3, \q, 0.1, \filtFreq, 1000, )

~chords = Pbindef(\chords, \instrument, \steradsrrlpfsaw, \dur, 16, \degree, Prout(e[\utils][\shiftReg].value(4, Scale.minor.degrees, 0.5)), \strum, 0.1)
Pbindef(\chords, \atk, 1, \rel, 3);

~chords[1] = {([AllpassN.ar(~chords.ar[0], 0.1, LFNoise1.kr(1, 0.05, 0.05), 5), AllpassN.ar(~chords.ar[0], 0.1, LFNoise1.kr(1, 0.05, 0.05), 5)] * 0.7) + ~chords.ar[0]}
~chords.play

~lfo3 = {e[\utils][\sh1].value(1, 1)}

~revTail.fadeTime = 5
~revSnd = ~snare + ~hats

~reverb.play
~revTail = 1; ~bass.play; ~kick.play;~hats.play
~revTail.fadeTime_(0); ~revTail = 0.5;
(
Pbindef(\kicks, \buf, e[\samples][\Drums][\Kicks].choose,\dur, Pseq(e[\utils][\crudeDensFill].value(8, 1/2, 0.4), inf) );
~bass.play; ~kick.play;~hats.play; ~revTail = 5;
)

Pbindef(\bas, \filtFreq, 500, \q, 0.1, \filtSpread, 0.5, \atk, 0, \dec, 0.1, \sus, 0.5, \rel, 0.1, \amp, 5, \octave, Pwrand([2, 3], [0.8, 0.2], inf))

Pbindef(\bas, \filtFreq, 5000)
Pbindef(\hats, \dur, 1/4, \panX, Pwhite(-1.0)); ~hats.play;
~hats.stop

Pbindef(\snare, \pan, Pwhite(-0.5, 0.5))
p.quant_(4)
~snare
~snare.play
~bass.stop
~bass.play; ~revTail.fadeTime_(0); ~revTail = 0.1

~chords.stop
TempoClock.default.tempo_(145/60)
~del = {[CombN.ar(~delSnd.ar[1], 1, TempoClock.default.tempo.reciprocal / 2, 10), CombN.ar(~delSnd.ar[0], 1, TempoClock.default.tempo.reciprocal / 4, 10)].clip(-1.0, 1.0)}
~delSnd = ~snare
~del.fadeTime = 5
~del.fadeTime = 0;~del.stop; ~chords.stop; ~bass.stop;
~revSnd = ~chords + ~break
~reverb.play
~out.stop
~snare[1] = {(~snare * 5).fold(-1.0, 1.0)}
~kick[1] = {(~kick* 5).fold(-1.0, 1)}
~del.fadeTime = 5

(
f = Buffer.alloc(s, 2048);
)

TempoClock.default.tempo
~freeze = {var beat = TempoClock.default.tempo.reciprocal; Select.ar(~freezeTrig, [[AllpassN.ar(~freezeSnd.ar[0], beat, beat / ~freezeDiv[0], 10), AllpassN.ar(~freezeSnd.ar[1], beat, beat / ~freezeDiv[1], 10)], ~freezeSnd.ar])}

~freezeDiv[0] = 8
~freezeDiv[1] = 16
~freezeTrig.quant = 1;
~freezeTask = Task({
	loop {
		if (0.5.coin, {~freezeTrig = 1}, {~freezeTrig=0});
		1.yield;
	}
});

~freeze.play

~concat = {Concat.ar(~kick.ar, ~break.ar) * 0.2}
~concat.play

~break = Pbindef(\break, \instrument, \steradsrstretch, \dur, Pseq(e[\utils][\crudeDensFill].value(8, 1/2, 0.4), inf), \clock, TempoClock.default.tempo, \beatStretch, 4, \buf, e[\samples][\breaks][7])
Pbindef(\break, \buf, Prand(e[\samples][\breaks][5..9], inf))
Pbindef(\break, \pitchRatio, 2, \windowSize, 0.2)
Pbindef(\break, \amp, 4, \windowSize, 0.01, \beatStretch, Prand([4, 8, 16], inf), \overlaps,8, \envBuf, e[\envBufs][\saw])
~concat.play; ~freeze.play; ~bass.stop


~chords
~freeze.play
~bass.play
~freeze.stop
StageLimiter.deactivate
StageLimiter.activate
~out = ~reverb + ~del + ~snare + ~kick + ~hats
~out.stop
~freezeSnd = {CompanderD.ar(~bass) }
~out.play
~freeze.play
~chords.stop
~out.stop
~del.play
~kick.stop
~delSnd = ~snare * 0.4

~a[0]  = Pbind()

~a[10] = \filterIn -> {|in| FreeVerb.ar(in, 1, 1)}

~a[20] = \filterIn -> {|in| LeakDC.ar(in.fold(0, 0.5)) * 2}

~a[30] = \filterIn -> {|in| Ringz.ar(in)}
~a.set(\wet30, 0.5)

~a.set(\wet10, 1)
~a.set(\wet20, 1)
~a.play

~b[0] = {|freq=440| SinOsc.ar(freq)}
~b.fadeTime = 1
~b[1] = \xset -> Pbind(\dur, Pseq([1, 2, 1/2, 1/4, 1/4], inf), \degree, Pseq([1,2,3], inf))

~b.play