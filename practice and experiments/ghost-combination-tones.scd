s.boot


p = ProxySpace.push

~a = {|freq=440, spread=0.5| var lo, hi, split; split = freq / 2; lo = freq - split; hi = freq + split; Splay.ar([SinOsc.ar(lo), SinOsc.ar(hi)], spread)}

~a.play


~a[10] = \set -> Pbind(\degree, Prand([1,3,5,7], inf), \spread, Pbrown(), \dur, 1/8)

