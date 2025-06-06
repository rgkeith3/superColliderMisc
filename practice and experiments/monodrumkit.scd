s.boot


(
SynthDef(\k, {
	var kick = SinOsc.ar(XLine.ar(100000, \freq.kr(40), 0.01)) * Env.perc(0, 0.5).ar(2, \gate.kr(1));
	// var noise = SinOscFB.ar(\freq.kr(40), Array.exprand(2, 5000, 10000), 0.1) * Env.asr(0.1, 1, 0.01).ar(2, \gate.kr(1));
	Out.ar(\out.kr(0), kick!2)
}).load;

SynthDef(\h, {
	var hat = HPF.ar(WhiteNoise.ar, ExpRand(5000, 10000)) * Env.perc(0, 0.01).ar(2, \gate.kr(1));
	// var noise = SinOscFB.ar(40, Array.exprand(2, 500, 1000), 0.1) * Env.asr(0.1, 1, 0.01).ar(2, \gate.kr(1));
	Out.ar(\out.kr(0), hat!2)
}).load;

SynthDef(\s, {
	var sna = BPF.ar(WhiteNoise.ar, 1000, 0.1) + SinOsc.ar(XLine.ar(100000, [500, 750], 0.01),mul: Env.perc(0, 0.05).ar) * Env.perc(0, 0.1).ar(2, \gate.kr(1));
	// var noise = SinOscFB.ar(40, Array.exprand(2, 10000, 500000), 0.1) * Env.asr(0.1, 1, 0.01).ar(2, \gate.kr(1));
	Out.ar(\out.kr(0), sna!2)
}).load
)
p.pop
p = ProxySpace.push(s.boot)
p.makeTempoClock()
p.quant_(4)
~a = Pbind(\instrument, Pseq([Pwrand([\k, \h], [0.6, 0.4], 4), \s, Pwrand([\k, \h], [0.4, 0.5], 3)], inf), \dur, 1/2, \freq, 40)
p.clock.tempo = 3

~a.play
~tempo = {3}
~tempo.asBus.getSynchronous

(~a[5] = \filter -> {|in|
	var noise = SinOscFB.ar(\freq.kr(40), [500, 501]) * Amplitude.ar(in, 0.001, 0.1).linlin(0, 1, 1, 0) * 0.5;
	noise = FreeVerb.ar(HPF.ar(noise, 1000), 1, 1, 1) + noise * \noiseWet.kr(1);
})
~a[10] = \set -> Pbind(\noiseWet, Pwrand([0, 1], [0.1, 0.9], inf), \freq, Pwrand(40 * [1,2,1.5], [0.8, 0.1, 0.1], inf), \dur, 1/4)
~a[15] = nil
~a.set(\wet5, 0.5)
~a[15] = nil
~a.map(\wet10, ~x)

~x = {SinOsc.kr(16.reciprocal).bi2uni}