s.boot

(x.free; x = {
	var sig = SinOsc.ar(Env([40, 1500, 40], [1, 0.1], 100).ar(0, 1)) * Env(times: [1, 0.01], curve: 2).ar(2, 1);
	sig!2
}.play)

(
SynthDef(\whip, {
	var sig = SinOscFB.ar(Env([\bass_freq.kr(40), \top_freq.kr(10000), \bass_freq.kr(40)], [\sustain.kr(1), \click.kr(0.01)], \curve.kr(100)).ar(0, \gate.kr(1)), Env([\start_fb.kr(100), \top_fb.kr(50), \start_fb.kr(100)], [\sustain.kr(1), \click.kr(0.01)], 100).ar(0, \gate.kr(1))) * Env(times: [\sustain.kr(1), \click.kr(0.01)], curve: 2).ar(2, \gate.kr(1));

	Out.ar(\out.kr(0), sig!2);
}).add
)
p = ProxySpace.push(s)
p.makeTempoClock(145/60);

p.quant_(4)
// not sure why legato isn't making sustain work correctly
~a[0] = Pbind(\instrument, \whip, \dur, Pseq([1, 1, 1/3, 1/3, 2/3, 2/3], inf) * 2, \bass_freq, Pstep(Scale.minor.degreeToFreq([4, 0], 440, -4), 4, inf), \curve, 100, \top_freq, Pseq(Scale.minor.degreeToFreq(Array.rand(6, 0, 4), 440, 3), inf), \legato, 0.5, \click, 0.1, \start_fb, Pseg([1, 1000, 1], 32, \sin, inf), \top_fb, Pseg([1, 1000, 1], 24, \sin, inf))

(
~a[50] = \filterIn -> {|in| var fb = FbNode(2, 4); var sig = fb.delay(~tempo.kr.reciprocal * 1.01/3) + in; fb.write(BPF.ar(sig * 0.9)); sig;}
)
~a[50] = nil

~a[100] = \filterIn -> {|in| NHHall.ar(in)}
~a.set(\wet100, 0.5)


{var sig = In.ar(0, 2); ReplaceOut.ar(0, NHHall.ar(sig) + sig)}.play