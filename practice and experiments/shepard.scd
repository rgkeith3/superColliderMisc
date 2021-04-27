s.meter

(
SynthDef.new(\shepard, {
	arg freq=250, atk=1, rel=1, climb=1, twist=1, pan=0, out=0, fbAmt=0.5, fbSpd=1;
	var env = EnvGen.ar(Env(times: [atk, rel]), doneAction: 2);
	var pitchLine = Line.kr(start: freq, end: freq * climb, dur: atk + rel);
	var panLine = Line.kr(start: pan, end: twist + pan, dur: atk + rel);
	var sig = SinOscFB.ar(pitchLine, SinOsc.kr(fbSpd, mul: fbAmt, add: fbAmt)) * env;
	Out.ar(
		out,
		PanAz.ar(2, sig, panLine)
	);
}).add;
)
s.boot
s.options.numOutputBusChannels = 4;
s.reboot;

StageLimiter.activate
(
~a[0] = Pbind(
	\instrument, \shepard,
	\dur, 1/2,
	\atk, 5,
	\rel, 5,
	\climb, Pseq([1,0.5,1,2], inf).stutter(64),
	\twist, Pwhite(-1),
	\pan, Pwhite(-1),
	\degree, Pseq([Prand([1,3,5,7], 96), Prand([0,2,4,6], 128), Prand([1,3,5,7], 32)], inf).trace,
	\octave, Prand([4,5,6,7],inf),
	\fbSpd, Pseq([Pwhite(0, 15), Pwhite(15, 25)], 32),
	\fbAmt, 1
)
)
~a.play
s.record
~a.clear
~fb1 = {LFNoise1.kr(LFNoise1.kr(1).range(0, 5)).range(0, 1.5)}

~sin = {SinOsc.ar(LFNoise1.kr(1).range(5, 25)).range(0.5, 1.5)}


~a[10] = \filter -> {|in| CombN.ar(in, 0.2, [0.1, 0.2], 2)}

~a.play(0, fadeTime: 25)
p = ProxySpace.push
({
	NHHall.ar(~a.ar, ~fb1.kr);
}).play(fadeTime: 5)
p.stop

64 + 32