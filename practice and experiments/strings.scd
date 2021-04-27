// do some bowed string clouds
s.boot

(
SynthDef(\reverb, {
	arg in=0, mix=0.5, room=1, damp=1;
	var sig;
	sig =In.ar(in, 2);
	sig = FreeVerb2.ar(sig[0], sig[1], mix, room, damp);
	ReplaceOut.ar(in, sig);
}).add
)

~reverb = Synth.new(\reverb, addAction: \addToTail)

(
SynthDef(\bow, {
	arg out=0, freq=440, vibStrength=1, vibFreq=5, gate=1, pos=0.5, pan=0, atk=1, dec=1, sus=0.5, rel=1, forceOffset=0.5, forceEnv=0, velbOffset=0.5, velbEnv=0;
	var sig, env;
	env = EnvGen.ar(Env.adsr(atk, dec, sus, rel), gate, doneAction: 2);
	sig = DWGBowed.ar(freq + SinOsc.kr(vibFreq, mul: vibStrength), velbOffset + (env * velbEnv), forceOffset + (env* forceEnv), 1, pos) * env;
	sig = DWGSoundBoard.ar(sig);
	sig = LPF.ar(sig, 5000);
	sig = Pan2.ar(sig, pan);
	Out.ar(out, sig);
}).add
)

p.pop
(
Pbindef(\bowCloud,
	\instrument, \bow,
	\delta, 1/3,
	\dur, 0.2,
	\atk, 0.1,
	\dec, 0.01,
	\sus, 1,
	\rel, 0.5,
	\velbOffset, 0,
	\velbEnv, 1,
	\forceOffset,0,
	\forceEnv, 1,
	\pan, Pwhite(),
	\pos, Pbrown(step: 0.01),
	\vibStrength, 1,
	\vibFreq, Prand([5, 3, 10], inf),
	\degree, Pseq([1,4,5,7], inf),
	\scale, Scale.major,
	\octave, 4
).play
)

Scale.all

~reverb.set(\mix, 0.3)
~reverb.set(\room, 0.7)
~reverb.set(\damp, 1)


TempoClock.default.tempo_(2)
(
Pbindef(\bows,
	\instrument, \bow,
	\dur, 1/8,
	\atk, Pwhite(),
	\dec, 0.1,
	\sus, 0.7,
	\rel, 0.1,
	\velbOffset, 0.5,
	\velbEnv, 0.5,
	\forceOffset, 0.5,
	\forceEnv, 0.5,
	\pan, Pwhite(),
	\pos, Pbrown(),
	\vibStrength, 1,
	\vibFreq, Prand([5, 3, 10], inf),
	\degree, Pstutter(Pwrand([1, 4, 5, 7], [0.6, 0.2, 0.1, 0.1], inf), Pbrown(1, 36, 1)),
	\scale, Scale.major,
	\octave, Pwrand([4, 3, 2], [0.7, 0.2, 0.1], inf)
).play
)

Pbindef(\bows).stop
