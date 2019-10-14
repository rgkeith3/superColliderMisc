// using a ref as a proxy

y = `(nil)

z = y + 10
y.value = 34
z.value

y = nil
z = y + 10
y = [nil]
z = y + 10

currentEnvironment.postln;

~x = 9;
~x + 100

~y + ~x
~y = -90
~y + ~x

// using a function as a proxy
y = nil;
z = {y} + 10;
y = 34
z.value

// using NodeProxy
y = NodeProxy.audio(s, 2);
z = NodeProxy.audio(s, 2);

z.play;
z.source = y.sin * 0.2
y.source = { Saw.ar([300, 301], 4 * pi)}
y.source = 0
y.source

y.clear;z.clear

// using proxy space
p = ProxySpace.push(s)

~z.play
~z = ~y.sin * 0.2;
~y = {Saw.ar([300, 301], 4 * pi)}
p.clear
p.pop

// Ndef
Ndef(\z).play
Ndef(\z, Ndef(\y).sin * 0.2);
Ndef(\y, {Saw.ar([300, 301], 4 * pi)});
Ndef.clear