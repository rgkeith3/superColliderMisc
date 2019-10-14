s = Buffer.readChannel(s, "/Users/greykeith/superCollider/samples/breaks/eric_moore_breaks_cuts_2.wav", channels: 1);


(
x = {
  |clock = 1, stretch = 8, freqRatio=1, windowSize=0.2, stutter=8, rand=0, gate=1 |
	var time = stretch * clock.reciprocal;
	var pointer = SawDPW.ar(time.reciprocal, add: 0.5);
	Warp1.ar(1, s, Gate.ar(pointer, gate), freqRatio, windowSize, overlaps: stutter, windowRandRatio: rand)!2
}.play
)

140/60
x.set(\clock, 140/60)
x.set(\stretch, 4)
x.set(\stutter, 4)
x.set(\freqRatio, 1)
x.set(\windowSize, 1/16)
x.set(\rand, 0)
x.set(\gate, 1)
x.set(\gate, 0)
TempoClock.default.tempo_(140/60)

(
Pbindef(
	\breaks,
	\delta, 1/8,
	\type, \set,
	\id, x.nodeID,
	\args, [\stutter, \freqRatio, \windowSize, \rand, \gate],
	\stutter, Prand([2,4,8], inf),
	\freqRatio, 1.2,
	\windowSize, 1/8,
	\gate, Prand([0, 1], inf)
).play
)



1.sign

{Warp1.ar(1, s, SawDPW.ar(2.reciprocal, add: 0.5), overlaps: 4)}.play

