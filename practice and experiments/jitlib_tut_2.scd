currentEnvironment.postln
~a;
~a = 9;
~a + 100

~b + ~a

x = currentEnvironment
x.know = true
x.b + x.a

p = ProxySpace.new(s)
p.push
currentEnvironment.postln == p

~x + ~y
p.postln

(~x = {
	RLPF.ar(Impulse.ar(4) * 20, [850, 950], 0.2)
})
~x.index
~x.bus
~x.play

p.postln

(
~x = {Saw.ar([50, 51])}
)

~x.fadeTime = 3;

~y = { Pan2.ar(Dust.ar(20), 0)}
~y.bus
~x.bus
~x = { RLPF.ar(~y.ar * 8, [1450, 1234], 0.2)}

~y = { Impulse.ar(MouseX.kr(2, 18, 1)) * [1, 1]}
~y = { PinkNoise.ar(MouseX.kr(0, 0.2))  * [1,1]}
~y.fadeTime  = 5;
~y = nil

~x = nil
// node proxies are created upon first access
~z2 = { LFNoise0.kr([1, 2,3,4])}
~z100 = 0.5
~z34.ar(3)
p.clear

~u.play(0, 2)
~u = {PinkNoise.ar(0.2)}
~u.numChannels
~u.clear

~u = {PinkNoise.ar(0.2)}
~u.play(0, 2)
~u.mold(1)
