s.boot
(
{
	var sig = SoundIn.ar();
	var local = LocalIn.ar() + sig;
	15.do {
		local = AllpassC.ar(local,0.2, Rand(0.0001, 0.2), 1);
	};

	LocalOut.ar(local * 0.8);

	Out.ar(0, [local + sig]);
}.play
)

(
{
	var sig = SoundIn.ar();
	var local = LocalIn.ar() + sig;
	var counter = 0.0001;
	15.do {
		counter = counter + counter;
		local = AllpassC.ar(local,0.2, counter, 1);
	};

	LocalOut.ar(local * 0);

	Out.ar(0, [local + sig]);
}.play
)
(
{
	var sig = SoundIn.ar();
	var local = LocalIn.ar() + sig;
	var counter = 0.2;
	15.do {
		counter = counter / 2;
		local = AllpassC.ar(local,0.2, Rand(0.0001, counter), 1);
	};

	LocalOut.ar(local * 0.9);

	Out.ar(0, [local + sig]);
}.play
)
(
{
	var sig = SoundIn.ar();
	var local = LocalIn.ar() + sig;
	var counter = 0.2;
	15.do {
		counter = counter /2;
		local = AllpassC.ar(local,0.2, counter, 1);
	};

	LocalOut.ar(local * 0);

	Out.ar(0, [local + sig]);
}.play
)

(
{
	var sig = SoundIn.ar();
	var local = LocalIn.ar() + sig;
	15.do {
		local = AllpassC.ar(local,0.2, LFNoise1.kr(1, 0.1, 0.101), 1);
	};

	LocalOut.ar(local * 0);

	Out.ar(0, [local + sig]);
}.play
)

(
{
	var sig, local, sigs, mixed_sig;
	sig = SoundIn.ar();
	local = LocalIn.ar() + sig;
	sigs = [];
	5.do {
		var single_comb;
		single_comb = CombN.ar(local, 0.1, Rand(0.0001, 0.1), 1);
		sigs = sigs.add(single_comb);
	};

	mixed_sig = Mix.ar(sigs);
	5.do {
		mixed_sig = AllpassN.ar(mixed_sig, 0.2, Rand(0.0001, 0.2), 1);
	};

	LocalOut.ar(mixed_sig * 0.1);

	Out.ar(0, (mixed_sig + sig)!2)
}.play
)

(
{
	var sig, local, counter;
	sig = SoundIn.ar();
	local = LocalIn.ar() + sig;
	counter = 0.0001;
	13.do {
		counter = counter * 2;
		counter.postln;
		local = AllpassN.ar(local, 1, counter);
	};

	LocalOut.ar(local * 0.3);
	Out.ar(0, local + sig);
}.play
)

(
{
	var sig, sigs, local, dec, lp, hp;
	dec = 1;
	sig = SoundIn.ar();
	local = LocalIn.ar() + sig;
	sigs = [];
	4.do {
		sigs = sigs.add(CombN.ar(local, delaytime: Rand(0.0001, 0.2), decaytime: dec));
	};
	sigs = Mix.ar(sigs);

	lp = RLPF.ar(sigs, 250, 0.7);
	4.do {
		lp = RLPF.ar(AllpassN.ar(lp, delaytime: Rand(0.001, 0.2), decaytime: dec), 250, 0.7);
	};

	hp = RHPF.ar(sigs, 1440, 0.7);
	4.do {
		hp = RHPF.ar(AllpassN.ar(hp, delaytime: Rand(0.001, 0.2), decaytime: dec), 1440, 0.7);
	};


	sigs = Mix.ar([lp, hp]);

	LocalOut.ar(sigs * 0);

	Out.ar(0, (sigs + sig)!2);

}.play
)


(
{
	var sig, local, dec, fb, chaos, speed, size;
	dec = 5;
	fb = 0.8;
	chaos = 1;
	speed = 0.5;
	size = 0.2;

	sig = SoundIn.ar();
	local = LocalIn.ar() + sig;

	10.do {
		var chaosSig = LFNoise1.kr(speed, chaos).bi2uni * size * 0.9;
		local = AllpassC.ar(local, size, chaosSig, dec);
	};

	LocalOut.ar(local * fb);

	Out.ar(0, (local + sig)!2);
}.play
)


(
{
	var sig, local, fib;
	sig = SoundIn.ar();
	local = LocalIn.ar() + sig;
	fib= [1, 1];
	10.do{
		var nextFib = fib[fib.size -1] + fib[fib.size - 2];
		local = AllpassN.ar(local, nextFib / 1000, nextFib / 1000 );
		fib= fib.add(nextFib);
	};

	LocalOut.ar(local* 0);
	Out.ar(0, (local + sig)!2);
}.play
)

[1, 1][1]
StageLimiter.activate()

