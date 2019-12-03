p = ProxySpace.push(s.boot)


~pat1 = Pbind(\octave, 5, \degree, Prand([1, 2,3,6], inf))
~pat1.fadeTime_(10)
~pat1.stop

~pat2 = nil

~fx = {CombC.ar(~pat2, 0.2, [0.1, ~lfct1], [5, 2])}
~fx.fadeTime_(10)
~fx.stop

~verbus = Pbind(\dur, Prand([1, 0.2], inf), \octave, 3, \degree, Pwrand([1, 5], [0.9, 0.1], inf),\pan, Pwhite(-1.0), \amp, 2, \legato, 0.1)

StageLimiter.activate()



~verb = {FreeVerb.ar(~verbus, 0.5, 1, 0)}
~verb.play

~lfct1 = {LFNoise2.ar(1, 0.1, 0.11)}
TempoClock.default.tempo_(2)

currentEnvironment

~freeze = {var buf, chain, sig; buf = LocalBuf.new(1024, 2); chain = FFT(buf, ~verb); chain = PV_Freeze(chain, ~freezeTrig); IFFT(chain)}


~freeze.play
~freezeTrig = {ToggleFF.kr(Dust.kr(5))}
~verb.stop
~freezBus = ~verb.read

~pat2.free