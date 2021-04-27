p = ProxySpace.push(s)
s.boot

~a[0] = Pbind(\degree, Prand([1,2,3,4,5,6], inf), \amp, Pwhite(), \dur, 1/4, \pan, )
(
~a[1] = \setsrc -> Pbind(\source, Prand([
	{Pan2.ar(CombC.ar(~a, 0.2, Line.ar(Rand(hi: 0.1), Rand(hi: 0.1), Rand(hi: 5)), decaytime: Rand(hi: 5)), Rand(-1.0))}
], inf), \dur, 1/4)
)
~a.clear
~a.sources
~a[5] = {SinOsc.ar(Line.ar(50, 0, doneAction: 2))}
~a[5] = nil
~a.play

~a.edit


SynthDef(\echoLine, {
	|in, length=1, start=0, end=1, lineDur=1, pan=0, dec=1, out=0|
	var env, sig;
	env = EnvGen.ar(Env([1, 0], length), doneAction: 2);
	sig = CombC.ar(in, start.max(end), Line.ar(start, end, lineDur), dec);
	Out.ar(out, Pan2.ar(sig, pan, env));
}).add

~b = Pbind(\instrument, \echoLine, \in, ~a, \length, Pwhite(hi: 5), \start, Pwhite(), \end, Pwhite(), \lineDur, Pwhite(hi: 5), \pan, Pwhite(-1), \dec, Pwhite(), \dur, Pwhite(hi: 2))
~b.gui

NdefGui.
s.quit
1.max(2)

