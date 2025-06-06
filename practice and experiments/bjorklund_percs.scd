(
var synthDefs = "a b c d e".split($ ).do({|char|
	SynthDef(char.asSymbol.postln, {
		var sig = Ringz.ar(Impulse.ar(0), Array.exprand(5, 50, 5000).sort, Array.exprand(5, 0.01, 1).sort.reverse, 1/10).sum;
		DetectSilence.ar(sig, doneAction: 2);
		Out.ar(\out.kr(0), sig!2);
	}).load;
});
)

ProxySpace.push(s.boot)
currentEnvironment.makeTempoClock
currentEnvironment.quant_(4)

~a = Pbind(\instrument, \a, \dur, Pseq([Bjorklund2(3, 8), Bjorklund2(10, 16), Bjorklund2(1, 8)].flatten.scramble, inf) / 8)
~b = Pbind(\instrument, \b, \dur, Pseq(Bjorklund2(27, 32), inf) / 8)
~c = Pbind(\instrument, \c, \dur, Pbjorklund2(4, 32, offset: 1) / 8)
~d = Pbind(\instrument, \d, \dur, Pseq([Bjorklund2(5, 7), Bjorklund2(7, 10), Bjorklund2(3, 9), Bjorklund2(2, 6)].flatten.scramble, inf) / 8)
~out = ~a + ~b + ~c + ~d; ~out.play; ~a.stop; ~b.stop; ~c.stop; ~d.stop


~out[10] = \filter -> {|in| var sig = CompanderD.ar(in, 0.05, slopeBelow: 4, slopeAbove: 0.5, clampTime: 0.05); LPF.ar(sig, 500) + RLPF.ar((sig * 4).tanh, LFNoise2.ar(0.1).exprange(500, 10000), LFNoise2.ar(0.1).range(0.1, 0.5)).pow(10)};
~out[5] = \filter -> {|in| CombN.ar(in, 0.5, 1.5/2, 1, 0.2) + in}

7 + 10 + 9 - 32




