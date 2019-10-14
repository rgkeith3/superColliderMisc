s.boot

x = {
	arg freq1=27, freq2=26, mix=0.5, room=1, damp=1;
	FreeVerb2.ar(Saw.ar(freq1), Saw.ar(freq2), mix, room, damp)
}.play

x. set(\freq1, 25, \freq2, 12.55, \mix, 0.1, \room, 0.01, \damp, 1);