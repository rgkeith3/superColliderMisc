s.meter

(
SynthDef.new(\shepard, {
	arg freq=250, atk=1, rel=1, climb=1, twist=1, pan=0, out=0;
	var env = EnvGen.ar(Env(times: [atk, rel]), doneAction: 2);
	var pitchLine = Line.kr(start: freq, end: freq + (freq * climb), dur: atk + rel);
	var panLine = Line.kr(start: pan, end: twist + pan, dur: atk + rel);
	var sig = SawDPW.ar(pitchLine) * env;
	Out.ar(
		out,
		PanAz.ar(4, sig, panLine)
	);
}).add;
)

s.options.numOutputBusChannels = 4;
s.reboot;


(
p = Pbind(
	\instrument, \shepard,
	\dur, 2,
	\atk, 5,
	\rel, 5,
	\climb, -0.5
).play
)
p.stop