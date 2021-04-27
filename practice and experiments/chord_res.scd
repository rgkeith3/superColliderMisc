s.boot


(x = {
	|a=0, b=2, c=4, d=6|
	var sigs, sigIn, del, dec, res;
	del = MouseX.kr(0.5, 500).reciprocal;
	sigIn = SoundIn.ar();
	res = [ 1.0, 1.1224620483089, 1.2599210498937, 1.3348398541685, 1.4983070768743, 1.6817928305039, 1.8877486253586 ];
	sigs = [
		CombC.ar(sigIn, 2, (del * Lag.kr(Select.kr(a, res))), 5),
		CombC.ar(sigIn, 2, (del * Lag.kr(Select.kr(b, res))), 5),
		CombC.ar(sigIn, 2, (del * Lag.kr(Select.kr(c, res))), 5),
		CombC.ar(sigIn, 2, (del * Lag.kr(Select.kr(d, res))), 5),
	];
	Splay.ar(sigs);
}.play)

x.set(\a, 6)
x.set(\b, 5)

Pbindef(\chordres, \type, \set, \id, x.nodeID, \args, [\a, \b, \c, \d], \a, Prand([0,1,2,3,4,5,6], inf), \b, Prand([0,1,2,3,4,5,6], inf), \c, Prand([0,1,2,3,4,5,6], inf), \d, Prand([0,1,2,3,4,5,6], inf)).play
Pbindef(\)

Scale.major.ratios
0.5.reciprocal