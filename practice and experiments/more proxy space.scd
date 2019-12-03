p = ProxySpace.push(s.boot)
p.clock = TempoClock.default;
p.quant = 8;

~a = Pbind(\instrument, \sterOneShot, \buf, ~samples[\Drums][\Kicks][0], \dur, Pseq([4, 4, 6, 2], inf))
~b = Pbind(\instrument, \sterOneShot, \buf, Prand(~samples[\Drums]['Closed Hihat'], inf), \dur, 1)
~c = Pbind(\instrument, \sterOneShot, \buf, ~samples[\Drums][\Eight08s][2], \dur, 8)

~a.play
~a.quant = 4
~b.play
~b.quant = 1
~c.play
~c.quant = 6
~d = Pbind(\instrument, \sterOneShot, \buf, ~samples[\Synths][3], \dur, Pseq([1/3, 1/3, 2/3, 1/3, 1/3, 1/2, 3/4, 3/4], inf))
~d.quant = 4

~e = Pbind(\degree, Pseq([1,3,5], inf), \dur, 1/4)
~e.play
~d.fadeTime = 4
~d.stop
~samples[\Drums].keys
(
~rev = {
	var local = LocalIn.ar() + ~sig;
	5.do {
		local = AllpassN.ar(local, delaytime: Rand(0.0001, 0.01));
	};

	LocalOut.ar(local * 0);

	(local + ~sig)!2
})

~sig.source = ~e
~e.stop
~rev.stop

~rev = nil