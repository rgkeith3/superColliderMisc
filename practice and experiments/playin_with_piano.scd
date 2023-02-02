s.boot

MIDIClient.init
MIDIClient.destinations
MIDIIn.connectAll

MIDIFunc.trace(bool: false)

~notes = Array.fill(127, {nil})


(SynthDef(\test, {|freq=440, vel=64, gate=1|
	var sig, env;
	sig = Saw.ar(freq);
	env = Env.adsr(decayTime: vel.linlin(0,127, 0.1, 1));
	sig = LPF.ar(sig, EnvGen.ar(env, gate, vel.linlin(0, 127, freq / 2, freq * 4))) * EnvGen.ar(env, gate, vel.linlin(0, 127, 0, 1), doneAction: 2);
	sig = Pan2.ar(sig);
	Out.ar(0, sig);
}).load)

MIDIFunc({|val, num, chan, src| ~notes[num] = Synth(\test, [\freq, num.midicps, \vel, val, \gate, 1])}, msgType: \noteOn)

MIDIFunc({|val, num, chan, src| ~notes[num].set(\gate, 0);}, msgType: \noteOff)


(SynthDef(\delay, {
	var in = In.ar(0, 2);
	Out.ar(0, CombL.ar(in, maxdelaytime: 1, delaytime: 0.5, decaytime: 5))
}).load)

~del = Synth(\delay, addAction: 'addToTail')
~del.free
s.scope

~midiDest = MIDIOut.newByName("UM-ONE", "UM-ONE")
~midiDest.connect
~midiDest

(Ndef(\melody,
	Pbind(
		\type, \midi,
		\midiout, ~midiDest,
		\chan, 0,
		\scale, Pdefn(\scale, Scale.major),
		\degree, Pwalk([0,1,2,3,4,5,6,7], Pwrand([-2, -1, 0, 1, 2, 4], [2,3,0.5,3,2,1].normalizeSum, inf), Prand([1, -1], inf)),
		\dur, Pbrown(0.01, 1),
		\legato, Pbrown(0.1, 4),
		\octave, Pwalk([4,5,6], Pwrand([-1, -2, 0, 2, 1], [0.1, 0.1, 0.6, 0.1, 0.1], inf), Prand([1, -1], inf)),
		\amp, Pbrown(hi: 0.5)
	)
))


(Ndef(\chords,
	Pbind(
		\type, \midi,
		\midiout, ~midiDest,
		\chan, 0,
		\scale, Pdefn(\scale, Scale.major),
		\choice, Pwalk([0,1,2,3,4,5,6], Pwrand([-2, -1, 1, 2, 4], [2,3,3,2,1].normalizeSum, inf), Prand([1, -1], inf)),
		\degree, Pindex(~chords, Pkey(\choice), inf),
		\dur, Pbrown(0.5, 4),
		\strum, Pwhite(0.01, 0.1),
		\legato, Pbrown(0.5, 1),
		\octave, Pwalk([3,4,5], Pwrand([-1, -2, 0, 2, 1], [0.1, 0.1, 0.6, 0.1, 0.1], inf), Prand([1, -1], inf)),
		\amp, Pbrown(hi: 0.5)
	)
))
Ndef(\melody).clear
Ndef(\chords).clear

(
~chords = [
	[0,2,4],
	[1,3,5],
	[2,4,6],
	[5,7,1],
	[6,0,2],
	[7,1,3]
])

[ 0, 1, 3, 5, 7, 8, 10 ]
[0,1,2,3,4,5,6,7,8,9,10, 11]
Scale.major.pitchesPerOctave
Scale.phrygian.pitchesPerOctave
Scale.directory


Pdefn(\scale, Scale.new(#[0,1,4,5,7,8, 10], 12, \just, "Phrygian Dominant"))
Pdefn(\scale, Scale.new(#[0,1,3,5,7,8, 10], 12, \just))
Pdefn(\scale, Scale.new(#[0,2,3,5,7,8, 10], 12, \just))
Pdefn(\scale, Scale.new(#[0,2,3,5,7,8, 11], 12, \just))
Pdefn(\scale, Scale.new(#[0,2,4,5,7,9,11], 12, \just))
Scale.phrygian.degrees

Scale.major.degrees

~scale = Scale.major
~scale = Scale.new(#[0,1,4,5,7,8, 10], 12, nil, "Phrygian Dominant")