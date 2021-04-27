(
~a[0] = Ppar([
	Pbind(\instrument, \pluck, \dur, 0.5 , \pan, Pbrown(-1, step: 0.05), \degree, Pdefn(\deg1, Pseq([2, 0, 3, 5], inf)), \pAmt, 0, \scale, Scale.minor, \dec, Pdefn(\dec)),
	Pbind(\instrument, \pluck, \dur, 0.809015, \pan, Pbrown(-1, step: 0.05), \degree, Pdefn(\deg2, Pseq([4, 2, 5, 7], inf)), \pAmt, 0, \scale, Scale.minor, \dec, Pdefn(\dec)),
	Pbind(\instrument, \pluck, \dur, 1.30901054045, \pan, Pbrown(-1, step: 0.05), \degree, Pdefn(\deg3, Pseq([6, 4, 7, 9], inf)), \pAmt, 0, \scale, Scale.minor, \dec, Pdefn(\dec))
])
)
~a.play(fadeTime: 10)
Pdefn(\dec, Pwrand([1, 10], [0.6, 0.4], inf))

~a.fadeTime = 5

~a[10] = \filter -> {|in| NHHall.ar(in, LFNoise1.kr(0.05).range(0, 5), 0.25, earlyDiffusion: LFNoise1.kr(0.05).range(0, 1), lateDiffusion: LFNoise1.kr(0.05).range(0, 1))}
~a.set(\wet10, 0.5)

~a[7] = \filter -> {|in, divL=1, divR=1, decL=1, decR=1| var time = p.clock.tempo.reciprocal; [CombC.ar(in[0], time, time / divL, decL), CombC.ar(in[0], time, time / divR, decR)]}

~a[15] = \set -> Pbind(\divL, Prand([1,2,3,4, 8], inf), \decL, Prand([0, 1, 3,5], inf), \divR, Prand([1,2,3,4, 8], inf), \decR, Prand([0, 1, 3,5], inf), \wet7, Prand([0, 0.5], inf).trace)
~a[5] = \filter -> {|in| SelectX.ar(LFNoise1.kr(0.2).range(0, 0.7), [in, Decimator.ar(in, LFNoise1.kr(0.05).range(16, 22050), LFNoise1.kr(0.05).range(2, 24))])}
~a.play

Scale.minor
~a.stop

c = 0
d = 1
eb = 2
f = 3
g = 4
ab = 5
b=6
Array.geom(25, 1/2, 1.61803).rotate()

~b = {SinOscFB.ar(31.midicps, 0, 0.1)!2}
~b.play
50.cpsmidi
31.midicps
