~a = {Pan2.ar(WarpZ.ar(1, d[\samples][\zap2].choose, Env(Rand(0!3), Rand(hi: 2!2)).kr, Env(Rand(0.5, 2!3), Rand(hi: 2!2)).kr, 0.1, overlaps: 4, windowRandRatio: 0.3), Env(Rand(-1!3), Rand(hi: 2!2)).kr, Env([0,1,1,0], [0.1, 2, 0.1]).kr)}

~a = {WarpZ.ar(1, [d[\samples][\zap2].choose, d[\samples][\zap2].choose], Env(Rand(0!3), Rand(hi: 2!2)).kr, Env(Rand(0.5, 2!3), Rand(hi: 2!2)).kr, 0.1, overlaps: 4, windowRandRatio: 0.1) *  Env([0,1,1,0], [0.1, 2, 0.1]).kr}

~a.play