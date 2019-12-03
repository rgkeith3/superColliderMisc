p = ProxySpace.push(s.boot)

~pat = Pbind()

~fx = {CombC.ar(~pat, 0.2, ~ct, 0.1)}
~ct = {LFNoise2.kr(~ct2, 0.005, 0.0051)}
~ct2 = 5
~fx.play
~pat.play

~pat = Pbind(\degree, Pseq([1,2,3], inf), \dur, Pseq([1/3, 1/3, 4/3, 1/2, 5/2], inf), \legato, 1)