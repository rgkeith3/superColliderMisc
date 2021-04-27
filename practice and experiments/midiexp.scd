~a = Pbind(\instrument, \saw, \midinote, Pdefn(\midinote, 64), \dur, Pbjorklund2((Pkr(m[\slider][0]) * 16).asInteger,16) / 4, \legato, Pkr(m[\knob][0]) * 2, \cutoff, Pkr(m[\slider][1]) * 10000, \q, Pkr(m[\knob][1]).max(0.01), \pan, Pkr(m[\knob][2]) * 2 - 1, \atk, Pkr(m[\slider][2]), \rel, Pkr(m[\slider][3]), \dec, Pkr(m[\knob][3]), \amp, Pkr(m[\slider][4]))
~a.play

d[\samples][\drums][\k]

1.1.asInt

Pdefn(\midinote, 64)

MIDIFunc.noteOn({|vel, noteNum| ~notes[noteNum] = noteNum;  Pdefn(\midinote, Pseq(~notes.select({|note| note !== nil}), inf))}, chan: 1)
MIDIFunc.noteOff({|vel, noteNum| ~notes[noteNum] = nil; Pdefn(\midinote, Pseq(~notes.select({|note| note !== nil}) ++ [\], inf))}, chan: 1)

[1,nil,3].select({|el| el !== nil})
[] ++ ["helo"]



// pitch and velocity by keyboard
// knobs:
// atk, dec, sus, rel
// sliders:
// waveMo, waveStart, waveEnd, detune
(
SynthDef(\vosc3, {|freq=440, vel=1, gate=1, out=0|
	var env, bufStart, bufEnd, detune, bufPos, sig;

	env = EnvGen.ar(Env.adsr(m[\knob][0].kr * 5, m[\knob][1].kr, m[\knob][2].kr, m[\knob][3].kr * 10), gate, doneAction: 2);
	bufStart = m[\slider][1].kr * (w.size - 1);
	bufEnd = m[\slider][2].kr * (w.size - 1);
	detune = m[\slider][3].kr.linlin(0, 1, 1, 1.25);
	bufPos = LFNoise1.kr(m[\slider][0].kr + 0.01).range(bufStart + w.first.bufnum, bufEnd + w.first.bufnum).poll;
	sig = VOsc3.ar(bufPos, freq * detune, freq / detune, freq / 2) * SinOsc.ar(XLine.ar(500, 1));

	sig = sig * env;

	Out.ar(out, sig!2);
}).add
)
1.reciprocal / 10

g = Group.new()
g.set(\out, r.index)

Synth(\vosc3, [\freq, 440])

MIDIFunc.noteOn({|vel, noteNum| ~notes[noteNum] = Synth(\vosc3, [\freq, noteNum.midicps, \vel, vel / 127])}, chan: 1);
MIDIFunc.noteOff({|vel, noteNum| ~notes[noteNum].set(\gate, 0); ~notes[noteNum] = nil; }, chan: 1)

SynthDef(\saw1, {Saw.ar()}).add
x = Synth(\saw1)
x.free
w.size


r = Bus.audio(numChannels: 2)