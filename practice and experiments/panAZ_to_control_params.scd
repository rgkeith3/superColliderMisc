~a[0] = {|freq=50|RLPF.ar(Saw.ar(Lag.kr(freq)), PanAz.ar(7, K2A.ar(1), LFNoise1.kr(1), width: LFNoise1.kr(0.2).range(2, 7)).linlin(0, 1, 50, 5000), LFNoise1.kr(0.1).range(0.1, 1))}
~a[5] = \set -> Pbind(\degree, Pseq([0,1,2], inf), \octave, 3, \dur, Pseq([1/2, 1], inf), \scale, Scale.harmonicMinor)
~a[10] = \filter -> {|in| FreeVerb.ar(in, room: 2)}

~a[100] = f[\azToHDMI]
~a.play
[1,2,3][0]