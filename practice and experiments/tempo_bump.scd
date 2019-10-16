s.boot

(
Tdef(\tempoBump, {
	var bps = 1;
	loop {
		bps = bps + 0.01;
		TempoClock.default.tempo_(bps);
		1.wait
	}
}).play
)