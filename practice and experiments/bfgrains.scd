~a = {BufGrainBF.ar(Dust.kr(25), 1, Select.kr(LFNoise1.kr(0.1).range(0, 155), d[\samples][\zap2]), LFNoise0.kr(10).range(0.5, 2), azimuth: LFNoise1.kr(1).range(0, 2pi), elevation: LFNoise1.kr(1).range(-0.5pi, 0.5pi), rho: LFNoise1.kr(1).range(0.5, 3))}
~a.play

{BufGrainBF.ar()}

~a.scope
d[\samples][\zaps].size