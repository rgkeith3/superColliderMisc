s.boot

d.play

{Vocode.ar(PlayBuf.ar(1,d, loop: 1), PinkNoise.ar(), LFNoise0.ar(), 0.5, 0.01, 1, 5)!2}.play

(
x = {
	arg freq=50, freq2=50, q=0.05, hpf=50;
	Vocoder.ar(Mix.ar([WhiteNoise.ar(), SinOsc.ar(freq2)]), Saw.ar(freq),12, q: q, hpf: hpf)!2;
}.play)
x.set(\freq, 100, \freq2, 50)

s.boot

