p = ProxySpace.push(s.boot)

~sin = {SinOsc.ar(500)}
~saw = {SawDPW.ar(50)}
~pulse = {PulseDPW.ar(150)}

~out.play

~out = {Pan2.ar(~mix.ar(1), MouseX.kr(-1, 1))}
~out = {Pan2.ar(~mix.ar(1), LFNoise2.kr(5, 2, -1))}

~mix.read(~sin)
~mix = \default

~mix.fadeTime = 1.5
~mix = {SelectX.ar(LFNoise2.kr(2, 2, 1), [~sin, ~saw, ~pulse])}
~mix.read(~sin)
~mix.nodeMap.parents

~verbBus.read(~mix)

~verb = {FreeVerb.ar(RLPF.ar(~verbBus, MouseY.kr(50, 5000), MouseX.kr(1, 0.0001)), ~verbMix, ~verbRoom, ~verbDamp)!2}
~verbMix = 1;
~verbDamp = 0;
~verbRoom = 1
~verb.play