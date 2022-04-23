(~a[0] = { Splay.ar(PlayBuf.ar(1, d[\samples][\kitchen].choose, LFNoise1.kr(1!10, LFNoise1.kr(0.1).range(0,1)).range(0.75, 1.5), loop: 1) * 0.1) })

~a.play
~a[10] = \filter -> {|in| FreeVerb.ar(in, 0.33, 2)}

d[\samples][\kitchen].choose.play